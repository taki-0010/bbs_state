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
  @observable
  bool boardLoading = false;

  // @observable
  double? lastThreadsScrollIndex;

  @computed
  ForumSettingsData? get settings => parent.settings;

  @observable
  PrimaryViewState selectedPrimaryView = PrimaryViewState.boards;

  @observable
  ObservableList<BoardData?> boards = ObservableList<BoardData?>();

  @observable
  ObservableList<BoardData?> favoriteBoardsData = ObservableList<BoardData?>();

  @observable
  BoardData? board;

  @observable
  ObservableList<ThreadData?> threadList = ObservableList<ThreadData?>();

  @observable
  ObservableMap<String, List<ThreadDataForDiff?>> threadsDiff = ObservableMap();

  @computed
  List<ThreadDataForDiff?>? get currentBoardDiff => threadsDiff[board?.id];

  @computed
  Map<String, int?> get threadsLastReadAt {
    Map<String, int?> result = {};
    for (final i in threadList) {
      if (i != null) {
        final markData = parent.history.getSelectedMarkData(i);
        // logger.i('threadsLastReadAt: ${parent.history.markList.map((element) => (element?.id, element?.boardId, element?.type)).toList()}, i:${i.boardId}, i: ${i.id}, ${markData?.type}, ${markData?.lastReadAt}');
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
        case Communities.open2Ch:
          List<BoardData?> boardList = [];
          for (final element in boards) {
            if (element?.open2chBoards != null) {
              final i = element!.open2chBoards;
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
        case Communities.shitaraba:
          return favoriteBoardsData;

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

  // @computed
  // Future<List<BoardData?>> get boardDataByFetched async {
  //   if (userFavoritesBoards) {
  //     switch (parent.type) {
  //       case Communities.shitaraba:
  //         final favorites = settings?.favoritesBoardList;

  //         if (favorites == null || favorites.isEmpty) {
  //           return [];
  //         }

  //         final result = await ShitarabaHandler.getBoardInfoList(favorites);
  //         logger.d('shitaraba f: $favorites, result: ${result?.length}');
  //         return result ?? [];

  //       // break;
  //       default:
  //     }
  //   }
  //   return boards;
  // }

  @computed
  List<ThreadData?> get sortedThreads {
    final list = [...threadList];
    // list.sort((a, b) => (b?.ikioi ?? 0).compareTo(a?.ikioi ?? 0));
    // return list;

    switch (threadsOrder) {
      case ThreadsOrderType.hot:
        list.sort((a, b) => (b?.ikioi ?? 0).compareTo(a?.ikioi ?? 0));
        // logger
        //     .i('shitarabaThreads: 1: ${list[0]?.title}, 2: ${list[1]?.title}');
        break;
      case ThreadsOrderType.newerResponce:
        list.sort(
            (a, b) => (b?.updateAtStr ?? '').compareTo(a?.updateAtStr ?? ''));
        break;
      case ThreadsOrderType.newerThread:
        list.sort((a, b) => (b?.createdAt ?? 0).compareTo(a?.createdAt ?? 0));
        // logger.i('oder: ${list.map((e) => e?.createdAt).toList()}');
        break;
      case ThreadsOrderType.resCountDesc:
        list.sort((a, b) => (b?.resCount ?? 0).compareTo(a?.resCount ?? 0));
        break;
      case ThreadsOrderType.resCountAsc:
        list.sort((a, b) => (a?.resCount ?? 0).compareTo(b?.resCount ?? 0));
        break;
      case ThreadsOrderType.importance:
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
      case ThreadsOrderType.catalog:
        list.removeWhere((element) => element != null && !element.catalog);
        break;
      default:
    }
    List<ThreadData?> removeSameId = [];
    for (final i in list) {
      final exist = removeSameId.firstWhere(
        (element) => element?.id == i?.id,
        orElse: () => null,
      );
      if (exist == null) {
        removeSameId.add(i);
      }
    }
    if (settings?.movedToLastThreads == MovedToLastThreads.over1000) {
      List<ThreadData?> over1000 = [];
      List<ThreadData?> notOver1000 = [];
      for (final i in removeSameId) {
        if (i != null) {
          if (i.resCount >= 1000) {
            over1000.add(i);
          } else {
            notOver1000.add(i);
          }
        }
      }
      over1000.sort((a, b) => (a?.resCount ?? 1).compareTo((b?.resCount ?? 1)));
      return [...notOver1000, ...over1000];
    } else {
      return removeSameId;
    }
  }

  // int? _lastRead(final ThreadBase item) => threadsLastReadAt[item.id];

  @computed
  bool get currentBoardIsFavorite {
    if (board == null) return false;
    switch (parent.type) {
      case Communities.shitaraba:
        final str = ShitarabaData.favoriteBoardStr(
            category: board!.shitarabaBoard!.category, boardId: board!.id);
        return favoritesBoards.contains(str);
      default:
        return favoritesBoards.contains(board!.id);
    }
  }

  @computed
  List<ThreadData?> get displayThreads {
    // logger
    //     .i('shitarabaThreads: 1: ${sortedThreads[0]?.title}, 2: ${sortedThreads[1]?.title}');
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
  ThreadsOrderType get threadsOrder =>
      settings?.threadsOrderType ?? ThreadsOrderType.newerResponce;

  @action
  void toggleContentLoading() => contentLoading = !contentLoading;

  @action
  void toggleThreadsLoading() => threadsLoading = !threadsLoading;

  @action
  void toggleBoardLoading() => boardLoading = !boardLoading;

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
  void setThreadScrollOffset(final double? value) =>
      lastThreadsScrollIndex = value;

  @action
  void setBoard(final BoardData value) => board = value;

  @action
  Future<void> getBoards() async {
    clearSearchWord();
    if (boards.isNotEmpty) return;
    toggleBoardLoading();
    FetchBoardsResultData? result;
    switch (parent.type) {
      case Communities.fiveCh:
        result = await _getBoardsForFiveCh();
        break;
      case Communities.girlsCh:
        result = await _getBoardsForGirlsCh();
        break;
      case Communities.futabaCh:
        result = await _getBoardsForFutaba();
        break;
      case Communities.pinkCh:
        result = await _getBoardsForPinkCh();
        break;
      case Communities.machi:
        result = await _getBoardsForMachi();
        break;
      case Communities.shitaraba:
        result = await _getBoardsForShitaraba();
        await getFavBoards();

        break;
      case Communities.open2Ch:
        result = await _getBoardsForOpen2ch();
        break;
      default:
    }
    toggleBoardLoading();
    // if (result == null)
    switch (result?.result) {
      case FetchResult.error:
        parent.setErrorMessage('Error!');
        break;
      case FetchResult.networkError:
        parent.setErrorMessage('Status Code: ${result!.statusCode}');
      case FetchResult.success:
        boards.addAll([...?result?.boards]);
      default:
        parent.setErrorMessage('Error!');
    }
  }

  Future<void> getFavBoards() async {
    final favorites = settings?.favoritesBoardList;

    if (favorites != null && favorites.isNotEmpty) {
      switch (parent.type) {
        case Communities.shitaraba:
          toggleBoardLoading();
          final fav = await ShitarabaHandler.getBoardInfoList(favorites);
          favoriteBoardsData.clear();
          favoriteBoardsData.addAll([...?fav]);
          toggleBoardLoading();
          break;
        default:
      }
    }
  }

  Future<FetchBoardsResultData?> _getBoardsForOpen2ch() async {
    if (boards.isEmpty) {
      return await Open2ChHandler.getBoards();
    }
    return null;
  }

  // @action
  Future<FetchBoardsResultData?> _getBoardsForFiveCh() async {
    if (boards.isEmpty) {
      return await FiveChHandler.getBoard();
      // if (boardsData.) {
      //   return;
      // }
      // final result = boardsData.menuList
      //     .map((e) => e.categoryName != 'BBSPINK'
      //         ? BoardData(
      //             id: '',
      //             name: e.categoryName,
      //             forum: Communities.fiveCh,
      //             fiveChCategory: FiveChCategoryData(
      //               categoryContent: _getFiveChBoardList(e.categoryContent),
      //               categoryNumber: e.categoryNumber,
      //             ))
      //         : null)
      //     .toList();
      // boards.addAll([...result]);
    }
    return null;
  }

  // @action
  Future<FetchBoardsResultData?> _getBoardsForPinkCh() async {
    if (boards.isEmpty) {
      return await PinkChHandler.getBoard();
      // if (boardsData == null) {
      //   return;
      // }
      // final category = boardsData
      //     .map((e) => BoardData(
      //         id: '',
      //         name: e.categoryName,
      //         forum: Communities.pinkCh,
      //         fiveChCategory: FiveChCategoryData(
      //           categoryContent: _getFiveChBoardList(e.categoryContent),
      //           categoryNumber: e.categoryNumber,
      //         )))
      //     .toList();
      // final result = category.firstOrNull?.fiveChCategory?.categoryContent;
      // if (result == null) {
      //   return;
      // }
      // final pink =
      //     result.map((e) => e.copyWith(forum: Communities.pinkCh)).toList();
      // // final data = pink.where((element) => element.fiveCh?.directoryName != 'NONE').toList();
      // // final data = pink.where((element) => element.).toList();
      // boards.addAll([...pink]);
    }
    return null;
  }

  // @action
  Future<FetchBoardsResultData?> _getBoardsForGirlsCh() async {
    if (boards.isEmpty) {
      return await GirlsChHandler.getCategory();
      // if (result == null) {
      //   return;
      // }
      // boards.addAll(result);
    }
    return null;
  }

  // @action
  Future<FetchBoardsResultData?> _getBoardsForFutaba() async {
    if (boards.isEmpty) {
      return await FutabaChHandler.getBoards();
      // if (result == null) {
      //   return;
      // }
      // boards.addAll(result);
    }
    return null;
  }

  // @action
  Future<FetchBoardsResultData?> _getBoardsForMachi() async {
    if (boards.isEmpty) {
      return await MachiHandler.getBoards();
      // if (result == null) {
      //   return;
      // }
      // boards.addAll(result);
    }
    return null;
  }

  Future<FetchBoardsResultData?> _getBoardsForShitaraba() async {
    if (boards.isEmpty) {
      return await ShitarabaHandler.getCategories();
    }
    return null;
  }

  @action
  void deleteDiffField(final String? id) {
    threadsDiff[board?.id]?.removeWhere((element) => element?.id == id);
  }

  Future<void> setThreads(final BoardData value) async {
    setBoard(value);
    setThreadScrollOffset(null);
    toggleBoardLoading();
    final result = await getThreads();
    toggleBoardLoading();
    switch (result?.result) {
      case FetchResult.success:
        setPrimaryView(PrimaryViewState.threads);
        break;
      case FetchResult.error:
        parent.setErrorMessage('Error!');
        break;
      case FetchResult.networkError:
        parent.setErrorMessage('Status Code: ${result!.statusCode}');
      default:
        parent.setErrorMessage('Error!');
    }
  }

  // @action
  Future<FetchThreadsResultData?> getThreads() async {
    if (board == null) return null;
    final currentBoard = threadList.firstOrNull?.boardId;
    if (threadList.isNotEmpty && currentBoard != board?.id) {
      _clearThreads();
    }
    logger.d('getThreads: type:${board?.forum}');
    final result = await _fetchThreads();
    return result;
  }

  Future<FetchThreadsResultData?> _fetchThreads() async {
    FetchThreadsResultData? result;
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
      case Communities.shitaraba:
        result = await _getThreadsForShitaraba();
        break;
      case Communities.open2Ch:
        result = await _getThreadsForOpen2Ch();
        break;
      default:
    }
    logger.d('fetchThreads: ${result?.result}');

    switch (result?.result) {
      case FetchResult.error:
        parent.setErrorMessage('Error!');
        break;
      case FetchResult.networkError:
        parent.setErrorMessage('Status Code: ${result!.statusCode}');
      case FetchResult.success:
        await _setThreadsMetadata(
          result!.threads!,
        );
        if (parent.type == Communities.futabaCh) {
          final jsonData = await FutabaChHandler.fetchThreadsByJson(
              board!.futabaCh!.directory, board!.id);
          if (jsonData != null) {
            await parent.history.deleteMarkDataWhenNotFound<FutabaChThread>(
                jsonData, board!.id);
          }
        }
      default:
        parent.setErrorMessage('Error!');
    }
    return result;
  }

  @action
  void _clearThreads() => threadList.clear();

  @action
  void _setThreadsDiff<T extends ThreadData>(
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
          parent.history.deleteDiffField(h.id);
          parent.history.setDiffValue(h.id, (exist.resCount - h.resCount));
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

    // _clearThreads();
    // // logger.i('_setThreads: 1 ${threadList.length}');
    // threadList.addAll(newList);
    // // logger.i('_setThreads: 2 ${threadList.length}');
  }

  @action
  Future<void> _setThreadsMetadata<T extends ThreadData>(
    final List<T?> result,
  ) async {
    if (board == null) return;

    _setThreadsDiff<T>(newList: result, boardData: board!);
    _clearThreads();
    threadList.addAll(result);
    await parent.history.setArchived<T>(result, board!.id);
    await parent.history.updateResCountWhenUpdateBoard(result);
  }

  // @action
  // void setThreadsLastReadAt(final ThreadMarkData item) {
  //   threadsLastReadAt[item.id] = item.lastReadAt;
  // }

  // @action
  Future<FetchThreadsResultData?> _getThreadsForFiveCh() async {
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
          boardName: b.name, forum: Communities.fiveCh);
      // if (result == null) {
      //   return;
      // }
      // await _setThreadsMetadata<FiveChThreadTitleData>(result, b);
    }
    return null;
  }

  // @action
  Future<FetchThreadsResultData?> _getThreadsForPinkCh() async {
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

  Future<FetchThreadsResultData?> _getThreadsForOpen2Ch() async {
    if (board?.forum == Communities.open2Ch) {
      // b as FiveChBoardData;
      // final domain = '${board?.fiveCh?.directoryName}.${Open2ChData.host}';
      if (board?.fiveCh?.directoryName == null) return null;

      // if (board == null) return;
      // logger.d('_getThreadsForFiveCh: name: ${b.name}');

      return await Open2ChHandler.getThreads(
          board!.fiveCh!.directoryName, board!.id, board!.name);
      // if (result == null) {
      //   return;
      // }
      // await _setThreadsMetadata<FiveChThreadTitleData>(result, board!);
    }
    return null;
  }

  // @action
  Future<FetchThreadsResultData?> _getThreadsForGirlsCh() async {
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

  Future<FetchThreadsResultData?> _getThreadsForMachi() async {
    if (board?.machi != null) {
      return await MachiHandler.getThreads(board!.id);
      // return setMachiThreads(result);
    }
    return null;
  }

  Future<FetchThreadsResultData?> _getThreadsForShitaraba() async {
    if (board?.shitarabaBoard != null) {
      return await ShitarabaHandler.getThreads(
          board!.shitarabaBoard!.category, board!.id, board!.name);
      // return setMachiThreads(result);
    }
    return null;
  }

  // @action
  Future<FetchThreadsResultData?> _getThreadsForFutabaCh() async {
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

  List<String?>? toggleFavoriteBoard() {
    if (board == null) return null;
    String? boardId;
    switch (parent.type) {
      case Communities.shitaraba:
        boardId = ShitarabaData.favoriteBoardStr(
            category: board!.shitarabaBoard!.category, boardId: board!.id);
      default:
        boardId = board?.id;
    }
    if (boardId == null) return null;
    return _setFavorite(boardId);
  }

  List<String?> _setFavorite(final String boardId) {
    List<String?> current = [...favoritesBoards];
    if (current.contains(boardId)) {
      current.removeWhere((element) => element == boardId);
    } else {
      current.insert(0, boardId);
    }
    return current;
  }

  List<String?>? setFavoriteBoardByUri(final Uri uri) {
    final boardId = parent.parent.getBoardIdFromUri(uri, parent.type);
    if (boardId != null) {
      return _setFavorite(boardId);
    }
    return null;
  }

  List<String?>? addBoard(final String url) {
    if (parent.type != Communities.shitaraba) {
      return null;
    }
    final uri = Uri.parse(url);
    final result = ShitarabaData.uriIsThreadOrBoard(uri);
    if (result != null && !result) {
      final favoriteStr = ShitarabaData.getFavoriteStr(uri);
      if (favoriteStr != null) {
        return _setFavorite(favoriteStr);
      }
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
          result = true;
        }
      case Communities.shitaraba:
        if (board?.shitarabaBoard == null) {
          return false;
        }
        final postResult = await ShitarabaHandler.postThread(data,
            boardId: board!.id, category: board!.shitarabaBoard!.category);
        if (postResult) {
          result = true;
        }
      case Communities.open2Ch:
        final domain = board?.fiveCh?.domain;
        final bbs = board?.id;
        if (domain == null ||
            bbs == null ||
            data.body.isEmpty ||
            data.name.isEmpty) {
          return result;
        }
        result = await Open2ChHandler.postThread(data, domain, bbs);
      default:
    }
    if (result) {
      await Future.delayed(const Duration(milliseconds: 800));
      await getThreads();
    }
    toggleThreadsLoading();
    return result;
  }

  // bool isFavBoardByUri(final Uri uri) {
  //   if (settings == null) {
  //     return false;
  //   }
  //   final favs = settings!.favoritesBoardList;
  //   String? id;
  //   switch (parent.type) {
  //     case Communities.shitaraba:
  //       final isThread = ShitarabaData.uriIsThreadOrBoard(uri);
  //       if (isThread != null && !isThread) {
  //         final category = ShitarabaData.getCategoryFromUrl(uri.toString());
  //         final boardId = ShitarabaData.getBoardIdFromUrl(uri.toString());
  //         if (category != null && boardId != null) {
  //           id = ShitarabaData.favoriteBoardStr(
  //               boardId: boardId, category: category);
  //         }
  //       }

  //       break;
  //     default:
  //   }
  //   return favs.contains(id);
  // }

  @action
  void setContent(final ContentState? value) {
    content = value;
  }

  void updateContent(final ThreadContentData value) =>
      content?.updateContent(value);

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
