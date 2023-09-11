import 'importer.dart';

part 'forum_main.g.dart';

class ForumMainState = ForumMainStateBase with _$ForumMainState;

abstract class ForumMainStateBase with Store, WithDateTime {
  ForumMainStateBase({
    required this.parent,
  });
  late ForumStateBase parent;

  @observable
  ContentState? content;

  @observable
  bool contentLoading = false;
  @observable
  bool threadsLoading = false;

  // @observable
  double? lastThreadsScrollIndex;

  @computed
  ForumSettingsData? get settings => parent.settings;

  @observable
  PrimaryViewState selectedPrimaryView = PrimaryViewState.boards;

  @observable
  ObservableList<BoardData?> boards = ObservableList<BoardData?>();

  @observable
  BoardData? board;

  @observable
  ObservableList<ThreadData?> threadList = ObservableList<ThreadData?>();

  @observable
  ObservableMap<String, List<ThreadDataForDiff?>> threadsDiff = ObservableMap();

  // @observable
  // ThreadContentData? mainContent;

  @observable
  String? searchThreadWord;

  @computed
  List<BoardData?> get boardsData {
    if (userFavoritesBoards) {
      switch (parent.type) {
        case Communities.fiveCh:
          List<BoardData?> boardList = [];
          for (final element in boards) {
            if (element?.fiveChCategory != null) {
              final i = element!.fiveChCategory!.categoryContent;
              for (final t in i) {
                boardList.add(t);
              }
            }
          }
          return favoritesBoards
              .map((e) => boardList.firstWhere(
                  (final element) => element?.id == e,
                  orElse: () => null))
              .toList();
        default:
          return favoritesBoards
              .map((e) => boards.firstWhere((final element) => element?.id == e,
                  orElse: () => null))
              .toList();
      }
    } else {
      return boards;
    }
  }

  @computed
  List<ThreadData?> get sortedThreads {
    final list = [...threadList];
    // list.sort((a, b) => (b?.ikioi ?? 0).compareTo(a?.ikioi ?? 0));
    // return list;
    switch (threadsOrder) {
      case ThreadsOrder.hot:
        list.sort((a, b) => (b?.ikioi ?? 0).compareTo(a?.ikioi ?? 0));
        break;
      case ThreadsOrder.newOrder:
        list.sort(
            (a, b) => (b?.updateAtStr ?? '').compareTo(a?.updateAtStr ?? ''));
        break;
      case ThreadsOrder.oldOrder:
        list.sort(
            (a, b) => (a?.updateAtStr ?? '').compareTo(b?.updateAtStr ?? ''));
        break;
      case ThreadsOrder.resCountDesc:
        list.sort((a, b) => (b?.resCount ?? 0).compareTo(a?.resCount ?? 0));
        break;
      case ThreadsOrder.resCountAsc:
        list.sort((a, b) => (a?.resCount ?? 0).compareTo(b?.resCount ?? 0));
        break;
      case ThreadsOrder.catalog:
        return list
            .where((element) => element != null && element.catalog)
            .toList();
      default:
    }
    return list;
  }

  @computed
  List<ThreadData?> get displayTreads {
    if (searchThreadWord == null) {
      return sortedThreads;
    }
    return sortedThreads
        .where((element) =>
            element != null &&
            element.title
                .toLowerCase()
                .contains(searchThreadWord!.toLowerCase()))
        .toList();
  }

  @computed
  List<ThreadDataForDiff?> get primaryViewDiff {
    if (board == null) return [];
    return threadsDiff[board?.id] ?? [];
  }

  @computed
  bool get userFavoritesBoards => settings?.useFavoritesBoards ?? false;

  @computed
  List<String?> get favoritesBoards => settings?.favoritesBoardList ?? [];

  @computed
  ThreadsOrder get threadsOrder =>
      settings?.threadsOrder ?? ThreadsOrder.newOrder;

  @action
  void toggleContentLoading() => contentLoading = !contentLoading;

  @action
  void toggleThreadsLoading() => threadsLoading = !threadsLoading;

  @action
  Future<void> setPrimaryView(final PrimaryViewState value) async {
    final beforIsConent = selectedPrimaryView == PrimaryViewState.content;
    selectedPrimaryView = value;
    if (value == PrimaryViewState.threads && beforIsConent) {
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
  void setBoard(final BoardData value) => board = value;

  @action
  Future<void> getBoards() async {
    switch (parent.type) {
      case Communities.fiveCh:
        await _getBoardsForFiveCh();
        break;
      case Communities.girlsCh:
        await _getBoardsForGirlsCh();
        break;
      case Communities.futabaCh:
        await _getBoardsForFutaba();
        break;
      case Communities.pinkCh:
        await _getBoardsForPinkCh();
        break;
      default:
    }
  }

  @action
  Future<void> _getBoardsForFiveCh() async {
    if (boards.isEmpty) {
      final boardsData = await FiveChHandler.getBoard();
      if (boardsData == null) {
        return;
      }
      final result = boardsData.menuList
          .map((e) => e.categoryName != 'BBSPINK'
              ? BoardData(
                  id: '',
                  name: e.categoryName,
                  forum: Communities.fiveCh,
                  fiveChCategory: FiveChCategoryData(
                    categoryContent: _getFiveChBoardList(e.categoryContent),
                    categoryNumber: e.categoryNumber,
                  ))
              : null)
          .toList();
      boards.addAll([...result]);
    }
  }

  @action
  Future<void> _getBoardsForPinkCh() async {
    if (boards.isEmpty) {
      final boardsData = await PinkChHandler.getBoard();
      if (boardsData == null) {
        return;
      }
      final category = boardsData
          .map((e) => BoardData(
              id: '',
              name: e.categoryName,
              forum: Communities.pinkCh,
              fiveChCategory: FiveChCategoryData(
                categoryContent: _getFiveChBoardList(e.categoryContent),
                categoryNumber: e.categoryNumber,
              )))
          .toList();
      final result = category.firstOrNull?.fiveChCategory?.categoryContent;
      if (result == null) {
        return;
      }
      final pink =
          result.map((e) => e.copyWith(forum: Communities.pinkCh)).toList();
      // final data = pink.where((element) => element.fiveCh?.directoryName != 'NONE').toList();
      boards.addAll([...pink]);
    }
  }

  List<BoardData> _getFiveChBoardList(final List<FiveChBoardJsonData> value) {
    final data = value
        .map((e) => BoardData(
            id: e.directoryName,
            name: e.boardName,
            forum: Communities.fiveCh,
            fiveCh: FiveChBoardData(
                // id: e.directoryName,
                // name: e.boardName,
                category: e.category,
                categoryName: e.categoryName,
                categoryOrder: e.categoryOrder,
                url: e.url,
                directoryName: e.directoryName)))
        .toList();
    return data
        .where((element) => element.fiveCh?.directoryName != 'NONE')
        .toList();
  }

  @action
  Future<void> _getBoardsForGirlsCh() async {
    if (boards.isEmpty) {
      final result = await GirlsChHandler.getCategory();
      if (result == null) {
        return;
      }
      boards.addAll(result);
    }
  }

  @action
  Future<void> _getBoardsForFutaba() async {
    if (boards.isEmpty) {
      final result = await FutabaChHandler.getBoards();
      if (result == null) {
        return;
      }
      boards.addAll(result);
    }
  }

  @action
  Future<void> getThreads() async {
    if (board == null) return;
    final currentBoard = threadList.firstOrNull?.boardId;
    if (threadList.isNotEmpty && currentBoard != board?.id) {
      _clearThreads();
    }
    logger.d('getThreads: type:${board?.forum}');
    await _fetchThreads();
  }

  Future<void> _fetchThreads({final BoardData? value}) async {
    switch (parent.type) {
      case Communities.fiveCh:
        // if (value == null || value.type == Communities.fiveCh) {
        await _getThreadsForFiveCh(value: value);
        // }

        break;
      case Communities.girlsCh:
        // _clearThreads();
        await _getThreadsForGirlsCh();
        break;
      case Communities.futabaCh:
        // _clearThreads();
        await _getThreadsForFutabaCh();
        break;
      case Communities.pinkCh:
        await _getThreadsForPinkCh();
        break;
      default:
    }
  }

  @action
  void _clearThreads() => threadList.clear();

  @action
  void _setThreads<T extends ThreadData>(
      {
      // required final List<T?> oldList,
      required final List<T?> newList,
      required final BoardData boardData}) {
    //  final before = cache.threads;
    final before = [...?threadsDiff[boardData.id]];
    threadsDiff[boardData.id]?.clear();
    threadsDiff[boardData.id] = [];
    for (final e in newList) {
      if (e == null) return;
      final exist = before.firstWhere((element) => element?.id == e.id,
          orElse: () => null);
      if (exist != null) {
        final data = ThreadDataForDiff(
            id: e.id, before: exist.after, after: e.resCount, isNew: false);

        threadsDiff[boardData.id]?.add(data);
      } else {
        // logger.d('_setThreads: isNew');
        final data = ThreadDataForDiff(
            id: e.id,
            before: e.resCount,
            after: e.resCount,
            isNew: before.isEmpty ? false : true);
        threadsDiff[boardData.id]?.add(data);
      }
    }

    _clearThreads();
    // logger.i('_setThreads: 1 ${threadList.length}');
    threadList.addAll(newList);
    // logger.i('_setThreads: 2 ${threadList.length}');
  }

  @action
  Future<void> _setThreadsAndCache<T extends ThreadData>(
      final List<T?> result, final BoardData boardData) async {
    // final cache = await boardStorage.getBoardData(boardData.id);
    // final oldList = [...threadList];
    // if (oldList.isNotEmpty) {
    _setThreads<T>(
        // oldList: oldList.whereType<T?>().toList(),
        newList: result,
        boardData: boardData);
    // } else {

    //   threadList.addAll(result);
    // }
    // logger.d(
    //     '_setThreadsAndCache: ${boardData.id}, cache: ${cache != null}, cacheId: ${cache?.board.id}');
    // await boardStorage.setBoardData(boardData.id, threadList);
  }

  @action
  Future<void> _getThreadsForFiveCh({final BoardData? value}) async {
    final b = value ?? board;
    // logger.d(
    //     '_getThreadsForFiveCh: ${b.runtimeType}, b is FiveChBoardData:${b is FiveChBoardData}');
    if (b?.forum == Communities.fiveCh) {
      // b as FiveChBoardData;
      final domain = b!.fiveCh!.domain;
      if (domain == null) return;

      // if (board == null) return;
      logger.d('_getThreadsForFiveCh: name: ${b.name}');

      final result = await FiveChHandler.getThreads(
          domain: domain,
          directoryName: b.fiveCh!.directoryName,
          boardName: b.name);
      if (result == null) {
        return;
      }
      await _setThreadsAndCache<FiveChThreadTitleData>(result, b);
    }
  }

  // @action
  Future<void> _getThreadsForPinkCh({final BoardData? value}) async {
    final b = value ?? board;
    // logger.d(
    //     '_getThreadsForFiveCh: ${b.runtimeType}, b is FiveChBoardData:${b is FiveChBoardData}');
    if (b?.forum == Communities.pinkCh) {
      // b as FiveChBoardData;
      final domain = b!.fiveCh!.domain;
      if (domain == null) return;

      // if (board == null) return;
      logger.d('_getThreadsForFiveCh: name: ${b.name}');

      final result = await PinkChHandler.getThreads(
          domain: domain,
          directoryName: b.fiveCh!.directoryName,
          boardName: b.name);
      if (result == null) {
        return;
      }
      //  await _setThreadsAndCache<FiveChThreadTitleData>(result, b);
      _setThreads<FiveChThreadTitleData>(
          // oldList: oldList.whereType<T?>().toList(),
          newList: result,
          boardData: b);
    }
  }

  @action
  Future<void> _getThreadsForGirlsCh() async {
    if (board?.girlsCh != null) {
      final result = await GirlsChHandler.getTitleList(board!.girlsCh!.url,
          categoryId: board!.id);
      if (result == null) {
        return;
      }
      await _setThreadsAndCache<GirlsChThread>(result, board!);
      // final cache = await boardStorage.getBoardData(board!.id);
      // if (cache != null && cache.threads.isNotEmpty) {
      //   _setThreads(oldList: cache.threads, newList: result);
      // } else {
      //   threadList.addAll(result);
      // }
      // logger.d(
      //     '_getThreadsForGirlsCh: ${board!.id}, cache: ${cache != null}, cacheId: ${cache?.board.id}');
      // await boardStorage.setBoardData(board!.id, threadList);
    }
  }

  @action
  Future<void> _getThreadsForFutabaCh() async {
    if (board?.futabaCh != null) {
      // final futabaBoard = board as FutabaChBoard;
      final result = await FutabaChHandler.getAllThreads(
          catalog: board!.futabaCh!.catalogUrl,
          newer: board!.futabaCh!.newListUrl,
          hug: board!.futabaCh!.hugListUrl,
          boardId: board!.id,
          directory: board!.futabaCh!.directory);
      // final result =
      //     await FutabaChHandler.getThreads(board!.futabaCh!.catalogUrl, board!);
      if (result == null) {
        return;
      }
      await _setThreadsAndCache<FutabaChThread>(result, board!);
      // final cache = await boardStorage.getBoardData(board!.id);
      // if (cache != null && cache.threads.isNotEmpty) {
      //   _setThreads(oldList: cache.threads, newList: result);
      // } else {
      //   threadList.addAll(result);
      // }
      // logger.d(
      //     '_getThreadsForFutabaCh: ${board!.id}, cache: ${cache != null}, cacheId: ${cache?.board.id}');
      // await boardStorage.setBoardData(board!.id, threadList);
    }
  }

  @action
  void setContent(
    final ThreadContentData? value,
  ) {
    if (value != null && parent.parent.userData != null) {
      final data = ContentState(
          content: value, locale: parent.parent.userData!.language.name);
      // data.setLastOpenedIndex(lastOpenedIndex);
      content = data;
    } else {
      content = null;
    }
  }

  // void updateMarkData(final ThreadMarkData value) =>
  //     content?.updateMarkData(value);

  // @action
  void updateContent(final ThreadContentData value) =>
      content?.updateContent(value);

  // @action
  // void setContent(final ThreadContentData? value) {
  //   mainContent = value;
  // }

  @action
  void setSearchWord(final String value) {
    searchThreadWord = value;
  }

  @action
  void clearSearchWord() {
    searchThreadWord = null;
  }

  void deleteData(final ThreadMarkData value) {
    if (content?.content.id == value.id) {
      deleteContentState();
    }
  }

  @action
  void deleteContentState() => content = null;

  @action
  void clear() {
    boards.clear();
    threadList.clear();
    threadsDiff.clear();
    deleteContentState();
  }
}
