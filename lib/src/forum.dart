import 'dart:convert';

import 'package:bbs_state/src/forum_main.dart';
import 'package:bbs_state/src/search.dart';

import 'importer.dart';

part 'forum.g.dart';

class ThreadDataForDiff {
  const ThreadDataForDiff(
      {required this.id,
      required this.before,
      required this.after,
      this.isNew = false});
  final String id;
  final int before;
  final int after;
  final bool isNew;

  int get diff => after - before;
}

class ForumState = ForumStateBase with _$ForumState;

abstract class ForumStateBase with Store, WithDateTime {
  ForumStateBase({required this.parent, required this.type});
  late MainStoreBase parent;
  late Communities type;
  // late final storage = StorageState(parent: this);
  // late final indexStorage = IndexState(parent: this);
  // late final boardStorage = BoardStorageState(parent: this);
  // late final commentsStorage = CommentsState(parent: this);

  late final forumMain = ForumMainState(
    parent: this,
  );

  late final history = LibraryState(
    parent: this,
  );
  // late final favorite = LibraryState(parent: this, type: LibraryType.favorite);

  late final search = SearchState(parent: this);

  @observable
  ForumSettingsData? settings;

  @observable
  bool loading = false;

  @observable
  ThreadBase? hoverdItem;

  @observable
  double? hoverdItemX;

  @observable
  double? hoverdItemY;

  @observable
  String? errorMessage;

  @action
  void setHoverdItemPosition(
      final ThreadBase? item, final double? x, final double? y) {
    if (item != null) {
      if (item != hoverdItem) {
        hoverdItemX = x;
        hoverdItemY = y;
        hoverdItem = item;
      }
    } else {
      clearHoverdItem();
    }
  }

  @action
  void clearHoverdItem() {
    hoverdItem = null;
    hoverdItemX = null;
    hoverdItemY = null;
  }

  @action
  void setErrorMessage(final String? value) => errorMessage = value;

  // @computed
  // Future<String?> get currentSessionId async =>
  //     await parent.repository.server.userState.currentSessionId;

  @computed
  int get currentTotal => history.markList.length;

  @computed
  ThreadMarkData? get currentContentThreadData {
    return history.markList.firstWhere(
      (element) =>
          element?.id == currentContent?.id &&
          element?.boardId == currentContent?.boardId,
      orElse: () => null,
    );
  }

  @computed
  int? get currentContentDiff {
    final current = currentContent?.content.lastOrNull?.index;
    if (current == null) return null;
    final newResCount = currentContentThreadData?.resCount;
    if (newResCount == null) return null;
    return newResCount - current;
  }

  @computed
  BottomMenu get currentScreen => parent.currentScreen;

  @observable
  double boardsScroll = 0.0;

  @computed
  String? get selectedFonts => settings?.googleFonts;

  @computed
  ThemeList get selectedTheme => settings?.theme ?? ThemeList.m3Purple;

  // @computed
  // bool get userFavoritesBoards => settings?.useFavoritesBoards ?? false;

  @computed
  RetentionPeriodList get retentionPeriod =>
      settings?.retentionPeriod ?? RetentionPeriodList.oneDay;

  @computed
  double get getBoardsScrollTotal {
    if (boardsScroll > 0.0 && boardsScroll <= 100) {
      return 1.0 - (boardsScroll * 0.01);
    }
    if (boardsScroll > 100) {
      return 0.0;
    }
    if (boardsScroll <= 0.0) {
      return 1.0;
    }
    return 0.0;
  }

  @action
  void computeBoardScrol(final double? value) {
    if (value != null) {
      boardsScroll += value;
    }
  }

  // @observable
  // ObservableList<ThreadData?> logList = ObservableList<ThreadData?>();

  @computed
  ContentState? get currentContentState {
    if (parent.largeScreen) {
      return history.content;
    }
    switch (currentScreen) {
      case BottomMenu.forums:
        return forumMain.content;
      case BottomMenu.history:
        return history.content;
      // case 2:
      //   return favorite.selectedContentData;
      case BottomMenu.search:
        return search.content;
      default:
        return null;
    }
  }

  @computed
  bool get contentLoading {
    if (parent.largeScreen) {
      return history.contentLoading;
    }
    switch (currentScreen) {
      case BottomMenu.forums:
        return forumMain.contentLoading;
      case BottomMenu.history:
        return history.contentLoading;
      // case 2:
      //   return favorite.selectedContentData;
      case BottomMenu.search:
        return search.contentLoading;
      default:
        return false;
    }
  }

  void toggleContentLoading() {
    if (parent.largeScreen) {
      history.toggleContentLoading();
    } else {
      switch (currentScreen) {
        case BottomMenu.forums:
          forumMain.toggleContentLoading();
        case BottomMenu.history:
          history.toggleContentLoading();

        case BottomMenu.search:
          search.toggleContentLoading();
        default:
      }
    }
  }

  @computed
  ThreadContentData? get currentContent {
    return currentContentState?.content;
    // if (parent.largeScreen) {
    //   return history.content?.content;
    // }
    // switch (currentScreen) {
    //   case BottomMenu.forums:
    //     return forumMain.content?.content;
    //   case BottomMenu.history:
    //     return history.content?.content;
    //   // case 2:
    //   //   return favorite.selectedContentData;
    //   case BottomMenu.search:
    //     return search.content?.content;
    //   default:
    //     return null;
    // }
  }

  @computed
  List<ImportanceData?> get getCurrentImportanceList {
    final thread = currentContentThreadData;
    if (thread == null) return [];
    final settingsData = settings?.threadsImportanceList;
    return [...thread.importanceList, ...?settingsData];
  }

  // @action
  void setLastThreadsScrollOffset(final BottomMenu screen, final double value) {
    switch (screen) {
      case BottomMenu.forums:
        forumMain.lastThreadsScrollIndex = value;
        break;
      case BottomMenu.history:
        history.lastThreadsScrollOffset = value;
        break;
      case BottomMenu.search:
        search.lastThreadsScrollOffset = value;
        break;
      default:
    }
  }

  // @computed
  // List<ImportanceData?> get getCurrentBoardImportanceList {
  //   final thread = settings.boardImportanceList;
  //   if (thread == null) return [];
  //   return thread.importanceList;
  // }

  // Future<void> setSelectedFont(final String? value) async{

  // }

  ImportanceData? getImportanceByPostId(final String postId) {
    return getCurrentImportanceList.firstWhere(
      (element) =>
          element?.target == ImportanceTarget.postId &&
          element?.strValue == postId,
      orElse: () => null,
    );
  }

  ImportanceData? getImportanceByUserId(final String userId) {
    return getCurrentImportanceList.firstWhere(
      (element) =>
          element?.target == ImportanceTarget.userId &&
          element?.strValue == userId,
      orElse: () => null,
    );
  }

  ImportanceData? getImportanceByUserName(final String userName) {
    return getCurrentImportanceList.firstWhere(
      (element) =>
          element?.target == ImportanceTarget.userName &&
          element?.strValue == userName,
      orElse: () => null,
    );
  }

  ImportanceData? getImportanceByBody(final String body) {
    return getCurrentImportanceList.firstWhere(
      (element) =>
          element != null &&
          element.target == ImportanceTarget.body &&
          body.contains(element.strValue),
      orElse: () => null,
    );
  }

  @action
  void setSettings(final ForumSettingsData value) => settings = value;

  // @computed
  // ThreadContentData? get secondaryContent{
  //   if(parent.largeScreen){
  //     return
  //   }

  // }

  // @computed
  // List<ThreadBase?> get currentLibrary {
  //   switch (currentScreen) {
  //     case BottomMenu.history:
  //       return history.markList;
  //     case BottomMenu.search:
  //       return search.searchThreadList;
  //     default:
  //       return [];
  //   }
  // }

  @computed
  List<ThreadMarkData?> get historyList => history.markList;

  @computed
  List<ThreadBase?> get searchList => search.searchThreadList;

  @computed
  String get appBarTitle {
    if (parent.largeScreen) {
      switch (forumMain.selectedPrimaryView) {
        case PrimaryViewState.boards:
          return type.label;
        case PrimaryViewState.threads:
          return forumMain.board?.name ?? '';
        default:
          return '';
      }
    } else {
      switch (currentScreen) {
        case BottomMenu.forums:
          switch (forumMain.selectedPrimaryView) {
            case PrimaryViewState.boards:
              return type.label;
            case PrimaryViewState.threads:
              return forumMain.board?.name ?? '';
            case PrimaryViewState.content:
              return currentContentThreadData?.title ?? '';
            default:
              return '';
          }
        case BottomMenu.history:
          return history.appBarTitle;
        // case 2:
        //   return await favorite.appBarTitle;
        case BottomMenu.search:
          return search.appBarTitle;
        default:
      }
    }

    return type.label;
  }

  @computed
  PrimaryViewState get _primaryViewState {
    switch (currentScreen) {
      case BottomMenu.forums:
        return forumMain.selectedPrimaryView;
      case BottomMenu.history:
        return history.selectedPrimaryView;
      case BottomMenu.search:
        return search.primaryView;
      default:
        return PrimaryViewState.boards;
    }
  }

  ThreadBase? getThreadMarkDataByThreadData(final ThreadData value) {
    return historyList.firstWhere(
        (element) =>
            element?.id == value.id && element?.boardId == value.boardId,
        orElse: () => null);
  }

  ThreadContentData? _getData(final FetchContentResultData value,
      final String threadId, final String boardId) {
    if (value.contentList != null && value.threadLength != null) {
      final content = ThreadContentData(
        id: threadId,
        boardId: boardId,
        type: type,
        content: value.contentList!,
        threadLength: value.threadLength!,
        // archived: value.archived ?? false
      );
      return content;
    }
    return null;
  }

  @action
  Future<FetchResult> setContent(final String id,
      {required final ThreadBase thread}) async {
    // _toggleLoading();
    final position = thread is ThreadMarkData ? thread.positionToGet : null;

    final result = await _fetchData(id, thread: thread, positionToGet: position);
    if (result == null) {
      logger.e('setContent: null');
      return FetchResult.error;
    }
    if (result.result != FetchResult.success) {
      return result.result;
    }
    final content = _getData(result, thread.id, thread.boardId);
    if (content == null) {
      logger.e('setContent: null');
      return FetchResult.error;
    }

    _setContent(
      content,
    );
    if (thread is ThreadMarkData && currentScreen == BottomMenu.history) {
      history.content?.setLastResIndex(thread.resCount);
    }
    if (thread is ThreadData) {
      final exist = getThreadMarkDataByThreadData(thread);
      if (exist != null) {
        switch (currentScreen) {
          case BottomMenu.forums:
            final diff = forumMain.currentBoardDiff?.firstWhere(
              (element) => element?.id == thread.id,
              orElse: () => null,
            );
            if (diff != null) {
              forumMain.content?.setLastResIndex(diff.before);
              logger.d('setContent: exist.resCount: ${diff.before}');
            }

            break;
          case BottomMenu.search:
            search.content?.setLastResIndex(exist.resCount);
            break;
          default:
        }
      }
    }
    if (!parent.largeScreen) {
      switch (currentScreen) {
        case BottomMenu.forums:
          forumMain.setPrimaryView(PrimaryViewState.content);
          break;
        case BottomMenu.history:
          history.setPrimaryView(PrimaryViewState.content);
          break;
        case BottomMenu.search:
          // setSearchedContentId(selected.id);
          search.setPrimaryView(PrimaryViewState.content);
          break;
        default:
      }
    }
    return await _updateMark(thread, content);
    // _toggleLoading();

    // return true;
  }

  Future<FetchResult> _updateMark(
      final ThreadBase thread, final ThreadContentData content) async {
    final exist = historyList.firstWhere(
        (element) =>
            element?.id == thread.id && element?.boardId == thread.boardId,
        orElse: () => null);
    logger.i('_updateMarkData: ${exist?.id}');
    if (exist != null) {
      return _updateMarkData(exist, content);
    } else {
      return await _setInitialThreadMarkData(
        content,
        thread.url,
        thread.thumbnailStr,
      );
    }
  }

  int? _getCreatedAtBySecounds(final ThreadContentData value) {
    switch (value.type) {
      case Communities.fiveCh || Communities.pinkCh || Communities.machi:
        return int.tryParse(value.id);
      case Communities.girlsCh:
        final first = value.content.firstOrNull;
        if (first == null) {
          return null;
        }
        if (first is! GirlsChContent) {
          return null;
        }
        final datetime = first.createdAt;
        return (datetime.millisecondsSinceEpoch * 0.001).toInt();
      case Communities.futabaCh:
        final first = value.content.firstOrNull;
        if (first == null) {
          return null;
        }
        if (first is! FutabaChContent) {
          return null;
        }
        final datetime = first.createdAt;
        return (datetime.millisecondsSinceEpoch * 0.001).toInt();
      // case Communities.pinkCh:
      //   return int.tryParse(value.id);
      default:
        return null;
    }
  }

  // Future<void> setThreadMarkDataToHistoryList(final String url) async {}

  Future<FetchResult> _setInitialThreadMarkData(
    final ThreadContentData content,
    final String url,
    final String? thumbnailData,
  ) async {
    final session = '';
    // final session = await currentSessionId;
    final user = parent.repository.user;
    // final user = await parent.server.userState.getUserAccount;
    if (user != null && settings != null) {
      final resCount = content.threadLength;
      // final resCount = content.lastIndex ?? 0;
      final title = content.content.firstOrNull?.title;
      final thumbnail = content.content.firstOrNull?.srcThumbnail;
      final hot = getIkioi(int.tryParse(content.id) ?? 0, resCount);
      final retention = _getRetentionPeriodSeconds(hot);
      final documentId = _getDocumentId(content.id, content.boardId);
      final createdAtBySeconds = _getCreatedAtBySecounds(content);
      final now = DateTime.now();

      final newLog = ThreadMarkData(
          id: content.id,
          documentId: documentId,
          userId: user.id,
          type: type,
          // gotAt: DateTime.now().toIso8601String(),
          resCount: resCount,
          url: url.replaceAll('https://', ''),
          sessionId: session,
          boardId: content.boardId,
          thumbnailStr: thumbnailData ??
              jsonEncode(SrcData(thumbnailUri: thumbnail).toJson()),
          title: title ?? '',
          // boardName: null,
          positionToGet: settings!.positionToGet,
          createdAtBySeconds: createdAtBySeconds ?? 0,
          lastReadAt: now.millisecondsSinceEpoch,
          retentionPeriodSeconds:
              now.add(Duration(hours: retention)).millisecondsSinceEpoch);

      // history.setLog(newLog);
      logger.f(
          '_setInitialThreadMarkData: $retention, title: $title, hot: $hot, retention: ${settings?.retentionPeriod}');
      await parent.repository.saveThreadMark(newLog);
      return FetchResult.success;
    } else {
      logger.e('_setInitialThreadMarkData: user ==null || settings == null');
      // throw '_setInitialThreadMarkData: user ==null || settings == null';
      return FetchResult.error;
    }
  }

  String _getDocumentId(final String threadId, final String boardId) {
    final random = StringMethodData.generateRandomString();
    final result = '${boardId}_${threadId}_$random';
    // final result = '${value.boardId}_${value.id}_${value.userId}';
    logger.d('id: $result, boardId:$boardId, length: ${result.length}');
    if (result.length > 36) {
      return result.substring(0, 36);
    }
    return result;
  }

  Future<FetchResult> _updateMarkData(
      final ThreadMarkData thread, final ThreadContentData content,
      {final int? lastOpenedIndex}) async {
    final resCount = content.threadLength;
    // if (resCount == thread.resCount) return true;
    final index = lastOpenedIndex;
    logger.i('_updateMarkData');

    final newMark = thread.copyWith(
        boardId: content.boardId,
        resCount: resCount,
        lastOpendIndex: index ?? thread.lastOpendIndex,
        lastReadAt: index != null
            ? DateTime.now().millisecondsSinceEpoch
            : thread.lastReadAt,
        retentionPeriodSeconds: getRetentionSinceEpoch(resCount, thread));
    await parent.repository.updateThreadMark(newMark);
    forumMain.deleteDiffField(newMark.id);
    history.deleteDiffField(newMark.id);
    return FetchResult.success;
  }

  int getRetentionSinceEpoch(final int resCount, final ThreadMarkData thread) {
    if (retentionPeriod != RetentionPeriodList.byPostPace) {
      return thread.retentionPeriodSeconds;
    }
    final hot = thread.ikioi;
    final retention = _getRetentionPeriodSeconds(hot);
    logger.i(
        'getRetentionSinceEpoch: hot: $hot, retention: $retention, retentionPeriod: $retentionPeriod, ${thread.retentionPeriodSeconds}');
    return DateTime.now()
        .add(Duration(hours: retention))
        .millisecondsSinceEpoch;
  }

  int _getRetentionPeriodSeconds(double hot) {
    // if (hot == 0) {
    //   hot = 0.1;
    // }
    if (retentionPeriod == RetentionPeriodList.byPostPace) {
      final hours = hot >= 4000 ? 4 : 15000 ~/ hot;
      return hours < 4
          ? 4
          : hours > 720
              ? 720
              : hours;
    } else {
      return (retentionPeriod.days) * 24;
    }
  }

  Future<FetchContentResultData> _fetchDataByUrl(final String url) async {
    switch (type) {
      case Communities.fiveCh:
        final id = FiveChData.getId(url);
        final host = Uri.parse(url).host;
        final boardId = FiveChData.getBoardIdFromDat(url);
        logger.i('getDataByUrl: $url, id:$id, $boardId, host:$host');
        if (id != null && boardId != null) {
          return await _getContentForFiveCh(
            id,
            domain: host,
            directoryName: boardId,
            // title: thread.title
          );
        }
      // threadLength = result?.lastOrNull?.index;
      // break;
      case Communities.girlsCh:
        final id = GirlsChParser.getIdFromUrl(url);

        final position = settings?.positionToGet;
        if (id != null && position != null) {
          return await _getContentForGirlsCh(
            id,
            // categoryId: thread.boardId,
            // thumbnail: thread.thumbnailUrl,
            positionToGet: position,
            // title: thread.title
          );
        }
      // break;
      case Communities.futabaCh:
        final id = FutabaData.getIdFromUrl(url);
        final boardId = FutabaData.getBoardIdFromUrl(url);
        final directory = FutabaData.getDirectory(Uri.parse(url));
        if (id != null && boardId != null && directory != null) {
          return await _getContentForFutabaCh(
              url: url.replaceAll('https://', ''), directory: directory);
          // threadLength = result?.lastOrNull?.index;
        }
        break;
      case Communities.pinkCh:
        final id = FiveChData.getId(url);
        final host = Uri.parse(url).host;
        final boardId = FiveChData.getBoardIdFromDat(url);
        if (id != null && boardId != null) {
          return await _getContentForFiveCh(
            id,
            domain: host,
            directoryName: boardId,
            // title: thread.title
          );
        }
      case Communities.machi:
        final id = FiveChData.getId(url);
        // final host = MachiData.host;
        final boardId = MachiData.getBoardIdFromUrl(url);
        logger.d('url:machi: $id, boardId: $boardId');
        if (id != null && boardId != null) {
          return await _getContentForMachi(boardId: boardId, threadId: id);
        }

      default:
    }
    return FetchContentResultData();
  }

  String? _getThreadIdFromUrl(final String url) {
    switch (type) {
      case Communities.fiveCh || Communities.pinkCh || Communities.machi:
        return FiveChData.getId(url);
      case Communities.girlsCh:
        return GirlsChParser.getIdFromUrl(url);
      case Communities.futabaCh:
        return FutabaData.getIdFromUrl(url);
      default:
    }
    return null;
  }

  String? _getBoardIdFromUrl(final String url, final ContentData? item) {
    switch (type) {
      case Communities.fiveCh || Communities.pinkCh:
        return FiveChData.getBoardIdFromDat(url);
      case Communities.girlsCh:
        if (item is GirlsChContent) {
          return item.categoryId;
        }
      case Communities.futabaCh:
        return FutabaData.getBoardIdFromUrl(url);
      case Communities.machi:
        return MachiData.getBoardIdFromUrl(url);
      default:
    }
    return null;
  }

  Future<FetchResult> getDataByUrl(final String url,
      {final bool setContent = true}) async {
    // List<ContentData?>? result;
    // bool archived = false;
    // String? id;
    // String? boardId;
    // int? threadLength;
    final result = await _fetchDataByUrl(url);
    if (result.result != FetchResult.success) {
      return result.result;
    }

    final threadId = _getThreadIdFromUrl(url);
    final boardId = _getBoardIdFromUrl(url, result.contentList?.firstOrNull);
    if (threadId == null || boardId == null) {
      return FetchResult.error;
    }

    final content = _getData(result, threadId, boardId);
    if (content == null) {
      return FetchResult.error;
    }
    if (setContent) {
      _setContent(content);
    }
    final markResult = await _setInitialThreadMarkData(
        content, url.replaceAll('https://', ''), null);
    if (markResult != FetchResult.success) {
      return result.result;
    }
    if (setContent) {
      search.setPrimaryView(PrimaryViewState.content);
    }
    // switch (type) {
    //   case Communities.fiveCh:
    //     id = FiveChData.getId(url);
    //     final host = Uri.parse(url).host;
    //     boardId = FiveChData.getBoardIdFromDat(url);
    //     logger.i('getDataByUrl: $url, id:$id, $boardId, host:$host');
    //     if (id != null && boardId != null) {
    //       (result, archived) = await _getContentForFiveCh(
    //         id,
    //         domain: host,
    //         directoryName: boardId,
    //         // title: thread.title
    //       );
    //     }
    //     threadLength = result?.lastOrNull?.index;
    //     break;
    //   case Communities.girlsCh:
    //     id = GirlsChParser.getIdFromUrl(url);

    //     final position = settings?.positionToGet;
    //     if (id != null && position != null) {
    //       final resultRecord = await _getContentForGirlsCh(
    //         id,
    //         // categoryId: thread.boardId,
    //         // thumbnail: thread.thumbnailUrl,
    //         positionToGet: position,
    //         // title: thread.title
    //       );
    //       result = resultRecord?.$1;
    //       threadLength = resultRecord?.$2;
    //       if (result != null) {
    //         final item = result.firstOrNull;
    //         if (item is GirlsChContent) {
    //           boardId = item.categoryId;
    //         }
    //       }
    //     }
    //     break;
    //   case Communities.futabaCh:
    //     id = FutabaData.getIdFromUrl(url);
    //     boardId = FutabaData.getBoardIdFromUrl(url);
    //     final directory = FutabaData.getDirectory(Uri.parse(url));
    //     if (id != null && boardId != null && directory != null) {
    //       result = await _getContentForFutabaCh(
    //           url: url.replaceAll('https://', ''), directory: directory);
    //       threadLength = result?.lastOrNull?.index;
    //     }
    //     break;
    //   case Communities.pinkCh:
    //     id = FiveChData.getId(url);
    //     final host = Uri.parse(url).host;
    //     boardId = FiveChData.getBoardIdFromDat(url);
    //     if (id != null && boardId != null) {
    //       (result, archived) = await _getContentForFiveCh(
    //         id,
    //         domain: host,
    //         directoryName: boardId,
    //         // title: thread.title
    //       );
    //     }
    //     threadLength = result?.lastOrNull?.index;
    //     break;
    //   default:
    // }
    // if (result != null && threadLength != null) {
    //   final content = ThreadContentData(
    //       id: id!,
    //       boardId: boardId!,
    //       type: type,
    //       content: result,
    //       threadLength: threadLength,
    //       archived: archived);
    //   if (setContent) {
    //     _setContent(content);
    //   }

    //   final success = await _setInitialThreadMarkData(
    //       content, url.replaceAll('https://', ''), null);
    //   if (setContent) {
    //     search.setPrimaryView(PrimaryViewState.content);
    //   }
    //   return success;
    // }
    return FetchResult.success;
  }

  @action
  Future<FetchContentResultData?> _fetchData<T extends ThreadBase>(
      final String dataId,
      {required final T thread,
      final PositionToGet? positionToGet}) async {
    // if (board == null) return;
    // _toggleLoading();
    // List<ContentData?>? result;
    // bool archived = false;
    // int? threadLength;
    // final boardId = thread.boardId;
    // final title = thread.title;
    // final thumbnail = SrcData(thumbnailUri: thread.thumbnailUrl);
    // final positionToGet =
    //     T is ThreadMarkData ? thread.positionToGet : settings!.positionToGet;
    final position =
        positionToGet ?? settings?.positionToGet ?? PositionToGet.first;
    switch (type) {
      case Communities.fiveCh:
        final host = thread.uri.host;
        logger.i('_fetchData: host: $host');

        return await _getContentForFiveCh(
          dataId,
          domain: host,
          directoryName: thread.boardId,
          // title: thread.title
        );
      case Communities.girlsCh:
        // if (thread is! GirlsChThread) return null;
        // final positionToGet = settings!.positionToGet;
        logger.d(
            'girlsCh: positionToGet: $positionToGet, ${T is ThreadMarkData}');
        return await _getContentForGirlsCh(
          dataId,
          // categoryId: thread.boardId,
          // thumbnail: thread.thumbnailUrl,
          positionToGet: position,
          // title: thread.title
        );
      case Communities.futabaCh:
        // if (thread is! FutabaChThread) return null;
        return await _getContentForFutabaCh(
            url: thread.url, directory: thread.futabaDirectory
            // title: thread.title,
            // boardId: thread.boardId,
            // thumbnail: thread.thumbnailUrl
            );
      case Communities.pinkCh:
        // if (thread is! FiveChThreadTitleData) return null;
        return await _getContentForFiveCh(
          dataId,
          domain: thread.uri.host,
          directoryName: thread.boardId,
          // title: thread.title
        );
      case Communities.machi:
        return await _getContentForMachi(
            boardId: thread.boardId, threadId: thread.id);
      default:
      // _toggleLoading();
    }
    // if (result != null && threadLength != null) {
    //   final content = ThreadContentData(
    //       id: thread.id,
    //       boardId: thread.boardId,
    //       type: type,
    //       content: result,
    //       threadLength: threadLength,
    //       archived: archived);
    //   return content;

    //   // await _setContent(content);
    // }
    return null;
  }

  @action
  void _setContent(
    final ThreadContentData value,
  ) {
    if (parent.largeScreen) {
      history.setContent(value);
    } else {
      switch (currentScreen) {
        case BottomMenu.forums:
          forumMain.setContent(value);
          break;
        case BottomMenu.history:
          history.setContent(value);
          break;
        case BottomMenu.search:
          search.setContent(value);
        default:
      }
    }
  }

  @action
  void _updateContent(final ThreadContentData value) {
    if (parent.largeScreen) {
      history.updateContent(value);
    } else {
      switch (currentScreen) {
        case BottomMenu.forums:
          forumMain.updateContent(value);
          break;
        case BottomMenu.history:
          history.updateContent(value);
          break;
        case BottomMenu.search:
          search.updateContent(value);
        default:
      }
    }
  }

  Future<FetchResult> updateContent() async {
    final thread = currentContentThreadData;
    if (thread == null) return FetchResult.error;
    // logger.d('position: 2: ${thread.positionToGet}');
    final result = await _fetchData<ThreadMarkData>(thread.id,
        thread: thread, positionToGet: thread.positionToGet);
    if (result == null) return FetchResult.error;
    final content = _getData(result, thread.id, thread.boardId);
    if (content == null) return FetchResult.error;
    final lastReadIndex =
        currentContentState?.content.content.lastOrNull?.index;
    final lastIndex = currentContentState?.currentContentIndex;
    currentContentState?.setLastResIndex(lastReadIndex);
    // if (!parent.cancelInitialScroll) {
    //   parent.toggleCancelInitialScroll();
    // }
    _updateContent(content);

    return await _updateMarkData(thread, content, lastOpenedIndex: lastIndex);
  }

  Future<void> updatePositionToGet(final PositionToGet value) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final current = thread.positionToGet;
    if (current == value) return;
    final newData = thread.copyWith(positionToGet: value);
    await parent.repository.updateThreadMark(newData);
  }

  Future<void> updateMark(final ResMarkData value) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final current = [...thread.markList];
    current.removeWhere((element) => element?.index == value.index);
    current.add(value);
    // logger.i('imp: ${value.level}, str: ${value.strValue}');
    final strList =
        current.map((e) => e != null ? jsonEncode(e.toJson()) : null).toSet();
    final newData = thread.copyWith(marks: strList);
    await parent.repository.updateThreadMark(newData);
  }

  Future<void> deleteMark(final ContentData value) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final current = [...thread.markList];
    current.removeWhere((element) => element?.index == value.index);
    // logger.i('imp: ${value.level}, str: ${value.strValue}');
    final strList =
        current.map((e) => e != null ? jsonEncode(e.toJson()) : null).toSet();
    final newData = thread.copyWith(marks: strList);
    await parent.repository.updateThreadMark(newData);
  }

  Future<void> updateImportance(final ImportanceData value) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final current = [...thread.importanceList];
    current.removeWhere((element) => element?.id == value.id);
    current.add(value);
    logger.i('imp: ${value.level}, str: ${value.strValue}');
    final strList = current.map((e) => jsonEncode(e?.toJson())).toList();
    final newData = thread.copyWith(importance: strList);
    await parent.repository.updateThreadMark(newData);
  }

  Future<void> deleteImportance(final ImportanceData value) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final current = [...thread.importanceList];
    current.removeWhere((element) => element?.id == value.id);
    final strList = current.map((e) => jsonEncode(e?.toJson())).toList();
    final newData = thread.copyWith(importance: strList);
    await parent.repository.updateThreadMark(newData);
  }

  Future<void> updateAgreeSet(final int index) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final current = {...thread.agreedIndexSet};
    current.add(index);
    // logger.i('imp: ${value.level}, str: ${value.strValue}');
    final newData = thread.copyWith(agreedIndexSet: current);
    await parent.repository.updateThreadMark(newData);
  }

  Future<void> sendAgree(final ContentData value,
      {final bool good = true}) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    switch (type) {
      case Communities.girlsCh:
        final index = (value as GirlsChContent).index;
        final result =
            await GirlsChHandler.sendAgree(index, thread.id, good: good);
        if (result) {
          await updateAgreeSet(index);
          currentContentState?.updateAgree(type, index, good);
        }
        break;
      case Communities.futabaCh:
        final boardId = currentContent?.boardId;
        if (boardId == null) return;
        final item = value as FutabaChContent;

        final result = await FutabaChHandler.sendAgree(
            item.directory, boardId, item.number.toString());
        logger.d('agree:futaba: $result');
      default:
    }
  }

  @action
  Future<FetchContentResultData> _getContentForFiveCh(
    final String id, {
    required final String domain,
    required final String directoryName,
    // required final String title
  }) async {
    final result = await FiveChHandler.getDat(id,
        domain: domain, directoryName: directoryName);
    return result;
  }

  @action
  Future<FetchContentResultData> _getContentForGirlsCh(final String id,
      {
      // required final String categoryId,
      required final PositionToGet positionToGet}) async {
    try {
      final result = await GirlsChHandler.getContent(id,
          // categoryId: categoryId,
          toGet: positionToGet);
      return result;
    } catch (e) {
      logger.e(e);
      parent.setLog(e.toString());
    }
    return FetchContentResultData();
  }

  @action
  Future<FetchContentResultData> _getContentForFutabaCh({
    required final String url,
    required final String directory,
  }) async {
    // if (thread is! FutabaChThread) return;
    final result = await FutabaChHandler.getContent(
      url,
      directory,
    );
    return result;
  }

  Future<FetchContentResultData> _getContentForMachi({
    required final String boardId,
    required final String threadId,
  }) async {
    // if (thread is! FutabaChThread) return;
    final result = await MachiHandler.getContent(
      boardId,
      threadId,
    );
    return result;
  }

  @action
  void disposeNonLargeContent() {
    // switch (_primaryViewState) {
    //   case PrimaryViewState.content:
    final currentContent = forumMain.content;
    if (currentContent != null) {
      forumMain.deleteContentState();
    }

    if (history.content == null && currentContent != null) {
      history.replaceContent(currentContent);
    }
    // if(search.content != null){

    // }
    if (forumMain.board != null) {
      forumMain.setPrimaryView(PrimaryViewState.threads);
    } else {
      forumMain.setPrimaryView(PrimaryViewState.boards);
    }

    history.setPrimaryView(PrimaryViewState.threads);
    search.setPrimaryView(PrimaryViewState.threads);
    //   break;
    // case PrimaryViewState.threads:
    //   // if (parent.bottomBarIndex == 1 || parent.bottomBarIndex == 2) {

    //   // }
    // default:
    // }
    clearHoverdItem();
  }

  Future<int?> getThreadDiffById(final String value,
      {final bool onLibraryView = false}) async {
    // if (!onLibraryView) {
    //   final current = threadList.firstWhere((element) => element?.id == value,
    //       orElse: () => null);
    //   if (current != null) {
    //     return current.difference;
    //   }
    // } else {
    //   final content = logList.firstWhere((element) => element?.id == value,
    //       orElse: () => null);
    //   if (content == null) return null;
    //   // return content.difference;
    //   final lastResCount = content.resCount;
    //   final boardData = await boardStorage.getBoardData(content.boardId);
    //   if (boardData == null) return null;
    //   final thread = boardData.threads
    //       .firstWhere((element) => element?.id == value, orElse: () => null);
    //   if (thread == null) return null;
    //   return thread.resCount - lastResCount;
    // }
    return null;
  }

  // Future<bool> existThreadFromStrorage(
  //     final String threadId, final String boardId) async {
  //   // final boardData = await boardStorage.getBoardData(boardId);
  //   // if (boardData == null) return false;
  //   // final thread = boardData.threads
  //   //     .firstWhere((element) => element?.id == threadId, orElse: () => null);
  //   // if (thread == null) return false;
  //   return true;
  // }

  Future<void> setLastOpenedContentIndex(
      final int? index, final String? contentId) async {
    final id = contentId ?? currentContent?.id;
    logger.d('setLastOpenedContentIndex: id:$id');
    if (index == null || id == null) return;

    // await indexStorage.setLastOpenedContentIndex(id, index);
  }

  Future<bool> postComment(final PostData value) async {
    switch (type) {
      case Communities.fiveCh || Communities.pinkCh:
        final domain = currentContentThreadData?.uri.host;
        final bbs = currentContentThreadData?.boardId;
        final threadId = FiveChData.getId(currentContentThreadData?.url ?? '');
        if (domain != null && bbs != null && threadId != null) {
          final result = await FiveChHandler.post(value, domain, bbs, threadId);
          if (result != null) {
            final resnum = result.resnum;
            if (resnum == null || resnum == 0) {
              return false;
            }
            final resMark = ResMarkData(index: resnum, icon: MarkIcon.edit);
            await updateMark(resMark);
            return true;
          }
        }
        return false;
      // case Communities.pinkCh:
      //   final domain = currentContentThreadData?.uri.host;
      //   final bbs = currentContentThreadData?.boardId;
      //   if (domain != null && bbs != null) {
      //     final result = await FiveChHandler.post(value, domain, bbs);
      //     if (result != null) {
      //       final resnum = int.tryParse(result.resnum ?? '0');
      //       if (resnum == null || resnum == 0) {
      //         return false;
      //       }
      //       final resMark = ResMarkData(index: resnum, icon: MarkIcon.edit);
      //       await updateMark(resMark);
      //       return true;
      //     }
      //   }
      //   return false;
      case Communities.girlsCh:
        final threadId = FiveChData.getId(currentContentThreadData?.url ?? '');
        if (threadId == null) {
          return false;
        }
        final result = await GirlsChHandler.post(
          value,
          threadId,
          // value.media,
        );
        if (result != null) {
          // await commentsStorage.setComment(result);
          return true;
        }
        return false;
      case Communities.futabaCh:
        final contentData = currentContent?.content.firstOrNull;
        final thread = currentContentThreadData;
        if (thread == null) return false;
        final directory = FutabaData.getDirectory(thread.uri);
        final id = FutabaData.getIdFromUrl(thread.url);
        final boardId = thread.boardId;
        final deleteKey = settings?.deleteKeyForFutaba;
        if (directory == null || id == null || deleteKey == null) {
          return false;
        }
        if (contentData is FutabaChContent) {
          final resto = contentData.resto;
          final hash = contentData.hash;
          if (resto != null && hash != null) {
            return await FutabaChHandler.post(directory, boardId, id,
                comment: value, deleteKey: deleteKey, resto: resto, hash: hash);
          }
        }
        return false;
      case Communities.machi:
        final thread = currentContentThreadData;
        if (thread == null) return false;
        final bbs = thread.boardId;
        final threadId = FiveChData.getId(thread.url);
        if (threadId == null) return false;
        return await MachiHandler.post(value, bbs, threadId);

      default:
    }
    return false;
  }

  Future<bool> deleteRes(final ContentData value) async {
    bool result = false;
    switch (type) {
      case Communities.futabaCh:
        // final contentData = currentContent?.content.firstOrNull;
        if (value is! FutabaChContent) {
          return result;
        }
        final thread = currentContentThreadData;
        if (thread == null) return result;
        final directory = FutabaData.getDirectory(thread.uri);
        final id = FutabaData.getIdFromUrl(thread.url);
        final boardId = thread.boardId;
        final deleteKey = settings?.deleteKeyForFutaba;
        if (directory == null || id == null || deleteKey == null) {
          return result;
        }

        result = await FutabaChHandler.deleteRes(
            directory, boardId, value.number.toString(), deleteKey, thread.id);
        break;
      default:
    }
    return result;
  }

  void deleteContent(final ThreadMarkData? value) {
    if (value != null) {
      forumMain.deleteData(value);
      history.deleteData(value);
      search.deleteData(value);
      clearHoverdItem();
    }
  }

  void clear() {
    forumMain.clear();
    history.clear();
    search.clear();
  }
}
