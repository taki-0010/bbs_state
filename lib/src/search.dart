import 'importer.dart';

part 'search.g.dart';

class SearchState = SearchStateBase with _$SearchState;

abstract class SearchStateBase with Store {
  SearchStateBase({
    required this.parent,
  });
  late ForumStateBase parent;

  @observable
  ContentState? content;

  @observable
  String? searchWord;

  @observable
  bool contentLoading = false;
  @observable
  bool threadsLoading = false;

  // @observable
  double? lastThreadsScrollOffset;

  @computed
  ForumSettingsData? get settings => parent.settings;

  @observable
  PrimaryViewState primaryView = PrimaryViewState.threads;

  @observable
  ObservableList<ThreadData?> searchThreadList = ObservableList<ThreadData?>();

  // @observable
  // ThreadContentData? searchedContent;

  // @observable
  // int viewIndex = 0;

  // @computed
  // bool get viewByBoard => settings?.viewByBoardInSearch ?? false;

  //   @observable
  // int viewIndex = 0;

  @computed
  Set<String?> get boardIdSetOfContentList {
    final boardIdSet =
        searchThreadList.map((element) => element?.boardId).toSet();
    // final boardsData = boardIdSet
    //     .map((e) => boards.firstWhere((element) => element?.id == e,
    //         orElse: () => null))
    //     .toList();
    logger.d('searchListByBoard: ${boardIdSet.map((e) => e)},');
    return boardIdSet;
  }

  @computed
  Map<String, List<ThreadData?>?> get searchListByBoardId {
    Map<String, List<ThreadData?>?> result = {};
    for (final b in boardIdSetOfContentList) {
      if (b != null) {
        final list =
            searchThreadList.where((element) => element?.boardId == b).toList();
        result[b] = [];
        result[b]?.addAll([...list]);
      }
    }
    return result;
  }

  // @computed
  // String? get selectedBoardName {
  //   if (boardIdSetOfContentList.isEmpty) return null;
  //   final boardId = boardIdSetOfContentList.elementAt(viewIndex);
  //   if (boardId == null) return null;
  //   final mark = searchThreadList.firstWhere(
  //     (element) => element?.boardId == boardId,
  //     orElse: () => null,
  //   );
  //   logger.d(
  //       'selectedBoardName: vewIndex: $viewIndex, boardId: $boardId, name: ${mark?.boardName}');
  //   // final data = await parent.boardStorage.getBoardData(boardId);
  //   // if (data != null) {
  //   //   return data.board.name;
  //   // }
  //   return mark?.boardName;
  // }

  @computed
  String get appBarTitle => switch (primaryView) {
        PrimaryViewState.content => '${parent.currentContentThreadData?.title}',
        PrimaryViewState.threads => parent.type.label,
        PrimaryViewState.boards => '',
      };

  @computed
  List<String?> get searchWords => settings?.searchWordList ?? [];

  @action
  Future<void> setPrimaryView(final PrimaryViewState value) async {
    primaryView = value;
    if (value == PrimaryViewState.threads) {
      if (content != null) {
        await parent.parent.setLastOpenedContentIndexById(
            content!.currentContentIndex,
            type: content!.content.type,
            threadId: content!.content.id,
            boardId: content!.content.boardId);
      }

      deleteContentState();
    }
  }

  @action
  void toggleContentLoading() => contentLoading = !contentLoading;

  @action
  void toggleThreadsLoading() => threadsLoading = !threadsLoading;

  @action
  void setContent(final ContentState? value) {
    content = value;
  }
  // void updateMarkData(final ThreadMarkData value) =>
  //   content?.updateMarkData(value);

  // @action
  void updateContent(final ThreadContentData value) =>
      content?.updateContent(value);
  // @action
  // void setContent(final ThreadContentData? value) => searchedContent = value;

  // @action
  // void setViewIndex(final int index) => viewIndex = index;

  Future<void> searchServerThreads<T extends ThreadData>(
      final String keyword) async {
    List<ThreadData?>? result = [];
    switch (parent.type) {
      case Communities.fiveCh:
        result = await FiveChHandler.searchTheads<T>(keyword);
        // _setSearchThreads(result);
        break;
      case Communities.girlsCh:
        result = await GirlsChHandler.searchThreads(keyword);
        // _setSearchThreads(result);
        break;
      case Communities.futabaCh:
        final board = await parent.parent.boardForSearch;
        if (board is! FutabaChBoard) return;
        result = await FutabaChHandler.searchThreadsByJson(
            keyword, board.directory, board.id);
        break;
      case Communities.pinkCh:
        result = await PinkChHandler.searchTheads<T>(keyword);

        break;
      case Communities.machi:
        final boardId = parent.parent.boardIdForSearch;
        if (boardId == null) return;
        result = await MachiHandler.searchThreads(keyword, boardId);
      case Communities.open2Ch:
        result = await Open2ChHandler.getSearchThreads(keyword);
      case Communities.chan4:
        final boardId = parent.parent.boardIdForSearch;
        if (boardId == null) return;
        final data = await Chan4Handler.searchThreads(keyword, boardId);
        result = data.threads;
      case Communities.hatena:
        result = await HatenaHandler.searchThreads(keyword);
      case Communities.mal:
        final boardId = parent.parent.boardIdForSearch;
        if (boardId == null) return;
        final data = await MalHandler.searchThreads(keyword, boardId);
        result = data.threads;
      default:
    }
    logger.i('search result: ${result?.length}');
    _setSearchThreads(result);
    _setSearchWord(keyword);
    await setSearchWords(keyword);
    // await parent.parent.userStorage.setSearchWords(keyword);
  }

  Future<void> setSearchWords(final String value) async {
    if (settings == null) return;
    final list = [...?settings?.searchWordList];
    if (list.contains(value)) {
      list.removeWhere((element) => element == value);
    }
    list.insert(0, value);
    if (list.length >= 21) {
      list.removeLast();
    }
    final newForum = settings!.copyWith(searchWordList: list);
    parent.setSettings(newForum);
  }

  @action
  void _setSearchWord(final String? value) {
    searchWord = value;
  }

  @action
  void _setSearchThreads(final List<ThreadData?>? value) {
    searchThreadList.clear();
    if (value != null) {
      // value.sort((a, b) => a.c);
      searchThreadList.addAll([...value]);
    }
  }

  void deleteData(final ThreadMarkData value) {
    if (content?.content.id == value.id) {
      deleteContentState();
      if (primaryView == PrimaryViewState.content) {
        setPrimaryView(PrimaryViewState.threads);
      }
    }
  }

  @action
  void deleteContentState() => content = null;

  @action
  void clear() {
    _setSearchWord(null);
    searchThreadList.clear();
    deleteContentState();
  }
}
