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
        case Communities.fiveCh || Communities.open2Ch:
          List<BoardData?> boardList = [];
          for (final element in boards) {
            if (element is FiveChCategoryData) {
              final i = element.categoryContent;
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
        // case Communities.open2Ch:
        //   List<BoardData?> boardList = [];
        //   for (final element in boards) {
        //     if (element is FiveChCategoryData) {
        //       final i = element.categoryContent;
        //       for (final t in i) {
        //         boardList.add(t);
        //       }
        //     }
        //   }
        //   return favoritesBoards
        //       .map((e) => boardList.firstWhere(
        //           (final element) => element?.id == e,
        //           orElse: () => null))
        //       .toList();
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
        list.sort((a, b) => (b?.updateAt ?? 0).compareTo(a?.updateAt ?? 0));
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
      // logger.i('sortedThreads: ${notOver1000.length}, ${over1000.length}');
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
        if (board is ShitarabaBoardData) {
          final category = (board as ShitarabaBoardData).category;
          final str = ShitarabaData.favoriteBoardStr(
              category: category, boardId: board!.id);
          return favoritesBoards.contains(str);
        }
      default:
        return favoritesBoards.contains(board!.id);
    }
    return false;
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
    if (value == selectedPrimaryView) {
      return;
    }
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

  BoardData? getSelectedBoardDataById(final String id) {
    BoardData? boardData;
    switch (parent.type) {
      case Communities.fiveCh || Communities.open2Ch:
        for (final c in boards) {
          if (c is FiveChCategoryData) {
            for (final b in c.categoryContent) {
              if (b.id == id) {
                boardData = b;
              }
            }
          }
        }
        break;
      default:
        boardData = boards.firstWhere(
          (element) => element?.id == id,
          orElse: () => null,
        );
    }
    return boardData;
  }

  Future<void> openBoardByUri(final Uri uri) async {
    final boardId = parent.parent.getBoardIdFromUri(uri, parent.type);
    if (boardId == null) {
      return;
    }
    if (boards.isEmpty) {
      await getBoards();
    }
    final boardData = getSelectedBoardDataById(boardId);
    if (boardData == null) {
      return;
    }
    await setThreads(boardData);
  }

  @action
  void setThreadScrollOffset(final double? value) =>
      lastThreadsScrollIndex = value;

  @action
  void setBoard(final BoardData value) => board = value;

  @action
  Future<void> reloadBoards() async {
    boards.clear();
    await getBoards();
  }

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
      case Communities.chan4:
        result = await _getBoardsForChan4();
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
        // boards.clear();
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
  // Future<void>

  Future<FetchBoardsResultData?> _getBoardsForChan4() async =>
      await Chan4Handler.getBoards(parent.selectedNsfw);

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
      case Communities.chan4:
        result = await _getThreadsForChan4();
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
          if (board is FutabaChBoard) {
            final jsonData = await FutabaChHandler.fetchThreadsByJson(
                (board as FutabaChBoard).directory, board!.id);
            if (jsonData != null) {
              await parent.history.deleteMarkDataWhenNotFound<FutabaChThread>(
                  jsonData, board!.id);
            }
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
    // logger.i('_setThreadsMetadat: length: ${result.length}');
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
    if (b?.forum == Communities.fiveCh && b is FiveChBoardData) {
      // b as FiveChBoardData;
      final domain = b.domain;
      if (domain == null) return null;

      // if (board == null) return;
      logger.d('_getThreadsForFiveCh: name: ${b.name}');

      return await FiveChHandler.getThreads(
          domain: domain,
          directoryName: b.directoryName,
          boardName: b.name,
          forum: Communities.fiveCh);
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
    if (b?.forum == Communities.pinkCh && b is FiveChBoardData) {
      // b as FiveChBoardData;
      final domain = b.domain;
      if (domain == null) return null;

      // if (board == null) return;
      logger.d('_getThreadsForFiveCh: name: ${b.name}');

      return await PinkChHandler.getThreads(
          domain: domain, directoryName: b.directoryName, boardName: b.name);
      // if (result == null) {
      //   return;
      // }
      // await _setThreadsMetadata<FiveChThreadTitleData>(result, board!);
    }
    return null;
  }

  Future<FetchThreadsResultData?> _getThreadsForOpen2Ch() async {
    final b = board;
    if (b?.forum == Communities.open2Ch && b is FiveChBoardData) {
      return await Open2ChHandler.getThreads(
          b.directoryName, board!.id, board!.name);
      // if (result == null) {
      //   return;
      // }
      // await _setThreadsMetadata<FiveChThreadTitleData>(result, board!);
    }
    return null;
  }

  // @action
  Future<FetchThreadsResultData?> _getThreadsForGirlsCh() async {
    final b = board;
    if (b is GirlsChCategory) {
      return await GirlsChHandler.getTitleList(b.url, categoryId: b.id);
      // if (result == null) {
      //   return;
      // }
      // await _setThreadsMetadata<GirlsChThread>(result, board!);
    }
    return null;
  }

  Future<FetchThreadsResultData?> _getThreadsForMachi() async {
    final b = board;
    if (b is MachiBoardData) {
      return await MachiHandler.getThreads(b.id);
      // return setMachiThreads(result);
    }
    return null;
  }

  Future<FetchThreadsResultData?> _getThreadsForChan4() async {
    final b = board;
    if (b is Chan4BoardData) {
      return await Chan4Handler.getThreads(b.id);
      // return setMachiThreads(result);
    }
    return null;
  }

  Future<FetchThreadsResultData?> _getThreadsForShitaraba() async {
    final b = board;
    if (b is ShitarabaBoardData) {
      return await ShitarabaHandler.getThreads(b.category, b.id, b.name);
      // return setMachiThreads(result);
    }
    return null;
  }

  // @action
  Future<FetchThreadsResultData?> _getThreadsForFutabaCh() async {
    final b = board;
    if (b is FutabaChBoard) {
      // final futabaBoard = board as FutabaChBoard;
      return await FutabaChHandler.getAllThreads(
          catalog: b.catalogUrl,
          newer: b.newListUrl,
          hug: b.hugListUrl,
          boardId: board!.id,
          directory: b.directory);
    }
    return null;
  }

  List<String?>? toggleFavoriteBoard() {
    final b = board;
    if (b == null) return null;
    String? boardId;
    switch (parent.type) {
      case Communities.shitaraba:
        if (b is ShitarabaBoardData) {
          boardId = ShitarabaData.favoriteBoardStr(
              category: b.category, boardId: b.id);
        }

      default:
        boardId = b.id;
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
    final b = board;
    bool result = false;
    toggleThreadsLoading();
    switch (parent.type) {
      case Communities.fiveCh || Communities.pinkCh:
        if (b is FiveChBoardData) {
          final domain = b.domain;
          final bbs = b.directoryName;
          if (domain == null ||
              // bbs == null ||
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
        }

      case Communities.futabaCh:
        if (b is FutabaChBoard) {
          final directory = b.directory;
          final boardId = b.id;
          final deleteKey = parent.settings?.deleteKeyForFutaba;
          if (deleteKey == null) {
            return false;
          }
          result = await FutabaChHandler.postThread(directory, boardId,
              comment: data, deleteKey: deleteKey);
        }

      case Communities.girlsCh:
        final postResult = await GirlsChHandler.postThread(data);
        if (postResult != null && postResult) {
          result = true;
        }
      case Communities.shitaraba:
        if (b is! ShitarabaBoardData) {
          return false;
        }
        final postResult = await ShitarabaHandler.postThread(data,
            boardId: b.id, category: b.category);
        if (postResult) {
          result = true;
        }
      case Communities.open2Ch:
        if (b is FiveChBoardData) {
          final domain = b.domain;
          final bbs = b.id;
          if (domain == null ||
              // bbs == null ||
              data.body.isEmpty ||
              data.name.isEmpty) {
            return result;
          }
          result = await Open2ChHandler.postThread(data, domain, bbs);
        }

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
