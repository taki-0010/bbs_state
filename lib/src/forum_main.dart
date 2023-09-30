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

  @computed
  Map<String, int?> get threadsLastReadAt {
    Map<String, int?> result = {};
    for (final i in threadList) {
      if (i != null) {
        final markData = parent.history.getSelectedMarkData(i);
        if (markData != null) {
          result[markData.id] = markData.lastReadAt;
        }
      }
    }
    return result;
  }

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
      case ThreadsOrder.newerResponce:
        list.sort(
            (a, b) => (b?.updateAtStr ?? '').compareTo(a?.updateAtStr ?? ''));
        break;
      case ThreadsOrder.newerThread:
        list.sort((a, b) => (b?.createdAt ?? 0).compareTo(a?.createdAt ?? 0));
        // logger.i('oder: ${list.map((e) => e?.createdAt).toList()}');
        break;
      case ThreadsOrder.resCountDesc:
        list.sort((a, b) => (b?.resCount ?? 0).compareTo(a?.resCount ?? 0));
        break;
      case ThreadsOrder.resCountAsc:
        list.sort((a, b) => (a?.resCount ?? 0).compareTo(b?.resCount ?? 0));
        break;
      case ThreadsOrder.importance:
        final importances = parent.settings!.boardImportanceList;
        final veryIm = importances
            .where((element) => element?.level == ImportanceList.veryImportant)
            .toList();
        final im = importances
            .where((element) => element?.level == ImportanceList.important)
            .toList();
        List<ThreadData?> veryImList = [];
        for (final v in veryIm) {
          for (final e in list) {
            if (e != null &&
                v != null &&
                v.target == ImportanceTarget.title &&
                e.title.toLowerCase().contains(v.strValue.toLowerCase())) {
              veryImList.add(e);
            }
          }
        }
        List<ThreadData?> imList = [];
        for (final v in im) {
          for (final e in list) {
            if (e != null &&
                v != null &&
                v.target == ImportanceTarget.title &&
                e.title.toLowerCase().contains(v.strValue.toLowerCase())) {
              veryImList.add(e);
            }
          }
        }
        for (final i in veryImList) {
          if (i != null) {
            list.removeWhere((element) => element?.id == i.id);
          }
        }
        for (final i in imList) {
          if (i != null) {
            list.removeWhere((element) => element?.id == i.id);
          }
        }
        list.insertAll(0, imList);
        list.insertAll(0, veryImList);
        // logger.i(
        //     'importance: im: ${imList.length}, ${im.length},  very: ${veryImList.length}, ${veryIm.length}');
        break;
      case ThreadsOrder.catalog:
        return list
            .where((element) => element != null && element.catalog)
            .toList();
      default:
    }
    if (settings?.movedToLastThreads == MovedToLastThreads.over1000) {
      List<ThreadData?> over1000 = [];
      List<ThreadData?> notOver1000 = [];
      for (final i in list) {
        if (i != null) {
          if (i.resCount >= 1000) {
            over1000.add(i);
          } else {
            notOver1000.add(i);
          }
        }
      }
      return [...notOver1000, ...over1000];
    } else {
      return list;
    }
  }

  // int? _lastRead(final ThreadBase item) => threadsLastReadAt[item.id];

  // @computed
  // List<ThreadData?> get displayThreads {
  //   final list = [...filterdThreads];
  //   List<(ThreadData, int)> historyList = [];
  //   for (final i in list) {
  //     if (i != null) {
  //       final lastRead = _lastRead(i);
  //       if (lastRead != null) {
  //         historyList.add((i, lastRead));
  //         list.removeWhere((element) => element?.id == i.id);
  //       }
  //     }
  //   }
  //   // historyList.sort((a, b) => a.$2.compareTo(b.$2));
  //   // final newList = historyList.map((e) => e.$1).toList();
  //   // list.insertAll(0, newList);
  //   // logger.i('displayTreads: histry: $historyList');
  //   return list;
  // }

  @computed
  List<ThreadData?> get displayThreads {
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
      case Communities.machi:
        await _getBoardsForMachi();
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
      // final data = pink.where((element) => element.).toList();
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
        .where((element) =>
            element.fiveCh?.directoryName != 'NONE' &&
            !element.fiveCh!.url.contains('headline'))
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
  Future<void> _getBoardsForMachi() async {
    if (boards.isEmpty) {
      final result = await MachiHandler.getBoards();
      if (result == null) {
        return;
      }
      boards.addAll(result);
    }
  }

  // @action
  Future<void> getThreads() async {
    if (board == null) return;
    final currentBoard = threadList.firstOrNull?.boardId;
    if (threadList.isNotEmpty && currentBoard != board?.id) {
      _clearThreads();
    }
    logger.d('getThreads: type:${board?.forum}');
    await _fetchThreads();
  }

  Future<void> _fetchThreads() async {
    List<ThreadData?>? result;
    switch (parent.type) {
      case Communities.fiveCh:
        // if (value == null || value.type == Communities.fiveCh) {
        result = await _getThreadsForFiveCh();
        // }

        break;
      case Communities.girlsCh:
        // _clearThreads();
        result = await _getThreadsForGirlsCh();
        break;
      case Communities.futabaCh:
        // _clearThreads();
        result = await _getThreadsForFutabaCh();
        break;
      case Communities.pinkCh:
        result = await _getThreadsForPinkCh();
        break;
      case Communities.machi:
        result = await _getThreadsForMachi();
        break;
      default:
    }
    if (result != null) {
      await _setThreadsMetadata(
        result,
      );
      if (parent.type == Communities.futabaCh) {
        final jsonData = await FutabaChHandler.fetchThreadsByJson(
            board!.futabaCh!.directory, board!.id);
        if (jsonData != null) {
          await parent.history
              .deleteMarkDataWhenNotFound<FutabaChThread>(jsonData, board!.id);
        }
      }
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
    final history = parent.historyList
        .where((element) => element?.boardId == boardData.id)
        .toList();
    for (final h in history) {
      if (h != null) {
        final exist = newList.firstWhere(
          (element) => element?.id == h.id,
          orElse: () => null,
        );
        if (exist != null) {
          final data = ThreadDataForDiff(
              id: h.id,
              before: h.resCount,
              after: exist.resCount,
              isNew: false);
          threadsDiff[boardData.id]?.add(data);
        }
      }
    }
    for (final e in newList) {
      if (e == null) return;
      final exist = before.firstWhere((element) => element?.id == e.id,
          orElse: () => null);
      if (exist != null) {
        final data = ThreadDataForDiff(
            id: e.id, before: exist.after, after: e.resCount, isNew: false);
        final historyData = threadsDiff[boardData.id]?.firstWhere(
            (element) => element?.id == data.id,
            orElse: () => null);
        if (historyData == null) {
          threadsDiff[boardData.id]?.add(data);
        }
      } else {
        // logger.d('_setThreads: isNew');
        final data = ThreadDataForDiff(
            id: e.id,
            before: e.resCount,
            after: e.resCount,
            isNew: before.isEmpty ? false : true);
        final historyData = threadsDiff[boardData.id]?.firstWhere(
            (element) => element?.id == data.id,
            orElse: () => null);
        if (historyData == null) {
          threadsDiff[boardData.id]?.add(data);
        }
      }
    }

    _clearThreads();
    // logger.i('_setThreads: 1 ${threadList.length}');
    threadList.addAll(newList);
    // logger.i('_setThreads: 2 ${threadList.length}');
  }

  @action
  Future<void> _setThreadsMetadata<T extends ThreadData>(
    final List<T?> result,
  ) async {
    if (board == null) return;

    _setThreads<T>(newList: result, boardData: board!);
    await parent.history.setArchived<T>(result, board!.id);
    await parent.history.updateResCountWhenUpdateBoard(result);
  }

  // @action
  // void setThreadsLastReadAt(final ThreadMarkData item) {
  //   threadsLastReadAt[item.id] = item.lastReadAt;
  // }

  // @action
  Future<List<ThreadData?>?> _getThreadsForFiveCh() async {
    final b = board;
    // logger.d(
    //     '_getThreadsForFiveCh: ${b.runtimeType}, b is FiveChBoardData:${b is FiveChBoardData}');
    if (b?.forum == Communities.fiveCh) {
      // b as FiveChBoardData;
      final domain = b!.fiveCh!.domain;
      if (domain == null) return null;

      // if (board == null) return;
      logger.d('_getThreadsForFiveCh: name: ${b.name}');

      return await FiveChHandler.getThreads(
          domain: domain,
          directoryName: b.fiveCh!.directoryName,
          boardName: b.name);
      // if (result == null) {
      //   return;
      // }
      // await _setThreadsMetadata<FiveChThreadTitleData>(result, b);
    }
    return null;
  }

  // @action
  Future<List<ThreadData?>?> _getThreadsForPinkCh() async {
    final b = board;
    // logger.d(
    //     '_getThreadsForFiveCh: ${b.runtimeType}, b is FiveChBoardData:${b is FiveChBoardData}');
    if (b?.forum == Communities.pinkCh) {
      // b as FiveChBoardData;
      final domain = b!.fiveCh!.domain;
      if (domain == null) return null;

      // if (board == null) return;
      logger.d('_getThreadsForFiveCh: name: ${b.name}');

      return await PinkChHandler.getThreads(
          domain: domain,
          directoryName: b.fiveCh!.directoryName,
          boardName: b.name);
      // if (result == null) {
      //   return;
      // }
      // await _setThreadsMetadata<FiveChThreadTitleData>(result, board!);
    }
    return null;
  }

  // @action
  Future<List<ThreadData?>?> _getThreadsForGirlsCh() async {
    if (board?.girlsCh != null) {
      return await GirlsChHandler.getTitleList(board!.girlsCh!.url,
          categoryId: board!.id);
      // if (result == null) {
      //   return;
      // }
      // await _setThreadsMetadata<GirlsChThread>(result, board!);
    }
    return null;
  }

  Future<List<ThreadData?>?> _getThreadsForMachi() async {
    if (board?.machi != null) {
      final result = await MachiHandler.getThreads(board!.id);
      return setMachiThreads(result);
    }
    return null;
  }

  List<ThreadData?>? setMachiThreads(final MachiThreadsBaseData? value) {
    return value?.thread
        .map((e) => e == null
            ? null
            : MachiThreadData(
                id: e.key,
                title: e.subject,
                resCount: int.tryParse(e.res) ?? 1,
                boardId: value.bbs,
                type: Communities.machi,
                url: e.getUrl(value.bbs),
                updateAtStr: null))
        .toList();
  }

  // @action
  Future<List<ThreadData?>?> _getThreadsForFutabaCh() async {
    if (board?.futabaCh != null) {
      // final futabaBoard = board as FutabaChBoard;
      return await FutabaChHandler.getAllThreads(
          catalog: board!.futabaCh!.catalogUrl,
          newer: board!.futabaCh!.newListUrl,
          hug: board!.futabaCh!.hugListUrl,
          boardId: board!.id,
          directory: board!.futabaCh!.directory);
      // final result =
      //     await FutabaChHandler.getThreads(board!.futabaCh!.catalogUrl, board!);
      // if (result == null) {
      //   return null;
      // }
      // await _setThreadsMetadata<FutabaChThread>(result, board!);
      // final jsonData = await FutabaChHandler.fetchThreadsByJson(
      //     board!.futabaCh!.directory, board!.id);
      // if (jsonData != null) {
      //   await parent.history
      //       .deleteMarkDataWhenNotFound<FutabaChThread>(jsonData, board!.id);
      // }
    }
    return null;
  }

  Future<bool> postThread({required final PostData data}) async {
    bool result = false;
    toggleThreadsLoading();
    switch (parent.type) {
      case Communities.fiveCh || Communities.pinkCh:
        final domain = board?.fiveCh?.domain;
        final bbs = board?.fiveCh?.directoryName;
        if (domain == null ||
            bbs == null ||
            data.body.isEmpty ||
            data.name.isEmpty) {
          return result;
        }
        logger.i('postThread: $domain, $bbs');
        result = await FiveChHandler.postThread(
            forum: parent.type,
            body: data.body,
            title: data.name,
            origin: domain,
            boardId: bbs);
      case Communities.futabaCh:
        final directory = board?.futabaCh?.directory;
        final boardId = board?.id;
        final deleteKey = parent.settings?.deleteKeyForFutaba;
        if (directory == null || boardId == null || deleteKey == null) {
          return false;
        }
        result = await FutabaChHandler.postThread(directory, boardId,
            comment: data, deleteKey: deleteKey);
      case Communities.girlsCh:
        final postResult = await GirlsChHandler.postThread(data);
        if (postResult != null && postResult) {
          return true;
        }
      default:
    }
    if (result) {
      await Future.delayed(const Duration(milliseconds: 500));
      await getThreads();
    }
    toggleThreadsLoading();
    return result;
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
