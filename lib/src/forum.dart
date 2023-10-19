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
  TemplateData? template;

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

  @observable
  int thumbnailCacheSize = 0;

  @observable
  int allCacheSize = 0;

  @computed
  String get thumbnailCacheSizeStr => filesize(thumbnailCacheSize);

  @computed
  String get allCacheSizeStr => filesize(allCacheSize);

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

  @computed
  ListViewStyle get selectedListViewStyle =>
      settings?.listViewStyle ?? ListViewStyle.list;

  @computed
  TimeagoList get selectedTimeagoList =>
      settings?.timeago ?? TimeagoList.enable;

  @computed
  bool get selectedNsfw => settings?.nsfw ?? false;

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

  @action
  void setTemplateData(final TemplateData? value) => template = value;

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

  @action
  Future<void> getAllCacheSize() async {
    final data = await parent.repository.mediaLocal.getTotalSize(type);
    allCacheSize = data;
  }

  @action
  Future<void> getAllThumbnailCacheSize() async {
    final data = await parent.repository.mediaLocal.getThumbnailTotalSize(type);
    thumbnailCacheSize = data;
  }

  Future<void> deleteAllCacheOnForum() async {
    await parent.repository.mediaLocal.deleteForumData(type);
    await getAllCacheSize();
    await getAllThumbnailCacheSize();
  }

  Future<void> deleteThumbnailCacheOnForum() async {
    await parent.repository.mediaLocal.deleteForumThumbnailData(type);
    await getAllThumbnailCacheSize();
    await getAllCacheSize();
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
        forumMain.setThreadScrollOffset(value);
        // forumMain.lastThreadsScrollIndex = value;
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

  ThreadMarkData? getThreadMarkDataByThreadData(final ThreadData value) {
    return historyList.firstWhere(
        (element) =>
            element?.id == value.id && element?.boardId == value.boardId,
        orElse: () => null);
  }

  ThreadContentData? _getData(final FetchContentResultData value,
      final String threadId, final String boardId, final RangeList? range) {
    if (value.contentList != null && value.threadLength != null) {
      final hot = getIkioi(int.tryParse(threadId) ?? 0, value.threadLength!);
      final content = ThreadContentData(
          id: threadId,
          boardId: boardId,
          type: type,
          content: value.contentList!,
          threadLength: value.threadLength!,
          hot: hot,
          range: range,
          girlsPages: value.girlsPages
          // archived: value.archived ?? false
          );
      return content;
    }
    return null;
  }

  int? _getcurrentPageForGirlsCh(final ThreadBase thread) {
    if (thread is ThreadMarkData) {
      return thread.lastPageOfGirlsCh;
    }
    if (thread is ThreadData) {
      final exist = getThreadMarkDataByThreadData(thread);
      if (exist != null) {
        return exist.lastPageOfGirlsCh;
      }
      return 1;
    }
    return null;
  }

  // int? _getLastOpenedIndexFromThread(final ThreadBase thread) {
  //   if (thread is ThreadData) {
  //     final exist = getThreadMarkDataByThreadData(thread);
  //     return exist?.lastOpendIndex;
  //   }
  //   if (thread is ThreadMarkData) {
  //     return thread.lastOpendIndex;
  //   }
  //   return null;
  // }

  @action
  Future<FetchResult> setContent(final String id,
      {required final ThreadBase thread}) async {
    // _toggleLoading();
    // final lastOpenedIndex = _getLastOpenedIndexFromThread(thread);
    final range = ShitarabaData.getRange(thread);
    final currentPageOfGirlsCh = _getcurrentPageForGirlsCh(thread);
    // final position = thread is ThreadMarkData ? thread.positionToGet : null;

    final result = await _fetchData(id,
        uri: thread.uri,
        lastPageForGirlsCh: currentPageOfGirlsCh,
        range: range);
    if (result == null) {
      logger.e('setContent: null');
      return FetchResult.error;
    }
    if (result.result != FetchResult.success) {
      return result.result;
    }
    final content = _getData(result, thread.id, thread.boardId, range);
    if (content == null) {
      logger.e('setContent: null');
      return FetchResult.error;
    }

    _setContent(
      content,
    );
    logger.i(
        'setContent: range:$range, content.range: ${content.range}, page: ${result.girlsPages?.next}');
    if (thread is ThreadMarkData && currentScreen == BottomMenu.history) {
      int lastResIndex = thread.resCount;
      final contains = history.markListDiff.keys.contains(thread.id);
      if (contains) {
        final exist = history.markListDiff[thread.id];
        if (exist != null) {
          lastResIndex -= exist;
        }
        logger.i(
            'lastResIndex: thread: ${thread.resCount}, exist: $exist, lastResIndex:$lastResIndex');
      }
      if (!lastResIndex.isNegative) {
        history.content?.setLastResIndex(lastResIndex);
      }
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
          content, thread.url, thread.thumbnailStr, thread.boardName);
    }
  }

  int? _getCreatedAtBySecounds(final ThreadContentData value) {
    switch (value.type) {
      case Communities.fiveCh ||
            Communities.pinkCh ||
            Communities.machi ||
            Communities.open2Ch ||
            Communities.shitaraba:
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
      case Communities.chan4:
        final first = value.content.firstOrNull;
        if (first is Chan4Content) {
          return first.time;
        }
      default:
        return null;
    }
    return null;
  }

  // Future<void> setThreadMarkDataToHistoryList(final String url) async {}

  Future<FetchResult> _setInitialThreadMarkData(
    final ThreadContentData content,
    final String url,
    final String? thumbnailData,
    final String? boardName,
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
          boardName: boardName,
          range: content.range,
          lastPageOfGirlsCh: content.girlsPages?.current,
          // gotAt: DateTime.now().toIso8601String(),
          resCount: resCount,
          url: url.replaceAll('https://', ''),
          sessionId: session,
          boardId: content.boardId,
          thumbnailStr: thumbnailData ??
              jsonEncode(SrcData(thumbnailUri: thumbnail).toJson()),
          title: title ?? '',
          // boardName: null,
          // positionToGet: settings!.positionToGet,
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
    final ThreadMarkData thread,
    final ThreadContentData content, {
    final int? lastOpenedIndex,
  }) async {
    final resCount = content.threadLength;
    // if (resCount == thread.resCount) return true;
    final index = lastOpenedIndex;
    logger.i('_updateMarkData');

    final newMark = thread.copyWith(
        boardId: content.boardId,
        resCount: resCount,
        range: content.range,
        lastPageOfGirlsCh: content.girlsPages?.current,
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

  // Future<FetchContentResultData> _fetchDataByUri(final Uri uri) async {
  //   switch (type) {
  //     case Communities.fiveCh || Communities.pinkCh || Communities.open2Ch:
  //       final id = FiveChData.getId(uri.toString());
  //       // final host = Uri.parse(url).host;
  //       // final boardId = FiveChData.getBoardIdFromHtmlUrl(url);.
  //       final boardId = FiveChData.getBoardIdFromUri(uri, type);
  //       logger.i('byUrl: $id,  boardId: $boardId');
  //       if (id != null && boardId != null) {
  //         return await _getContentForFiveCh(
  //           id,
  //           domain: uri.host,
  //           directoryName: boardId,
  //           // title: thread.title
  //         );
  //       }
  //     // threadLength = result?.lastOrNull?.index;
  //     // break;
  //     case Communities.girlsCh:
  //       final id = GirlsChParser.getIdFromUrl(uri.toString());

  //       // final position = settings?.positionToGet;
  //       if (id != null) {
  //         return await _getContentForGirlsCh(id, page: 1
  //             // categoryId: thread.boardId,
  //             // thumbnail: thread.thumbnailUrl,
  //             // positionToGet: position,
  //             // title: thread.title
  //             );
  //       }
  //     // break;
  //     case Communities.futabaCh:
  //       final id = FutabaData.getIdFromUrl(uri.toString());
  //       final boardId = FutabaData.getBoardIdFromUri(uri);
  //       final directory = FutabaData.getDirectory(uri);
  //       if (id != null && boardId != null && directory != null) {
  //         // final path = FutabaData.getUrlByPath(directory, boardId, id);

  //         // logger.i('get by url futaba: $path, ');
  //         return await _getContentForFutabaCh(
  //             boardId: boardId, directory: directory, threadId: id);
  //         // threadLength = result?.lastOrNull?.index;
  //       }
  //       break;
  //     // case Communities.pinkCh || Communities.open2Ch:
  //     //   final id = FiveChData.getId(url);
  //     //   final host = Uri.parse(url).host;
  //     //   final boardId = FiveChData.getBoardIdFromHtmlUrl(url);
  //     //   logger.i('byUrl: $id, host:$host, boardId: $boardId');
  //     //   if (id != null && boardId != null) {
  //     //     return await _getContentForFiveCh(
  //     //       id,
  //     //       domain: host,
  //     //       directoryName: boardId,
  //     //       // title: thread.title
  //     //     );
  //     //   }
  //     case Communities.machi:
  //       final id = FiveChData.getId(uri.toString());
  //       // final host = MachiData.host;
  //       final boardId = MachiData.getBoardIdFromUri(uri);
  //       logger.d('url:machi: $id, boardId: $boardId');
  //       if (id != null && boardId != null) {
  //         return await _getContentForMachi(boardId: boardId, threadId: id);
  //       }
  //     case Communities.shitaraba:
  //       final category = ShitarabaData.getCategoryFromUri(uri);
  //       final boardId = ShitarabaData.getBoardIdFromUri(uri);
  //       final threadId = ShitarabaData.getThreadIdFromUri(uri);
  //       logger.d('shitaraba: url: $category, $boardId, $threadId');
  //       if (category != null && boardId != null && threadId != null) {
  //         // final position = settings?.positionToGet;
  //         final thread = await _getContentForShitaraba(
  //             category: category,
  //             boardId: boardId,
  //             threadId: threadId,
  //             range: RangeList.last1000);
  //         if (thread.result == FetchResult.success) {
  //           final uri = Uri.https('${ShitarabaData.sub}.${ShitarabaData.host}',
  //               '${ShitarabaData.htmlPath}/$category/$boardId/$threadId');
  //           await parent.addBoard(uri.toString());
  //           return thread;
  //         }
  //       }

  //     default:
  //   }
  //   return FetchContentResultData();
  // }

  // String? _getThreadIdFromUrl(final String url) {
  //   switch (type) {
  //     case Communities.fiveCh ||
  //           Communities.pinkCh ||
  //           Communities.machi ||
  //           Communities.open2Ch ||
  //           Communities.shitaraba:
  //       return FiveChData.getId(url);
  //     case Communities.girlsCh:
  //       return GirlsChParser.getIdFromUrl(url);
  //     case Communities.futabaCh:
  //       return FutabaData.getIdFromUrl(url);
  //     default:
  //   }
  //   return null;
  // }

  // String? _getBoardIdFromUrl(final String url, final ContentData? item) {
  //   switch (type) {
  //     case Communities.fiveCh || Communities.pinkCh || Communities.open2Ch:
  //       return FiveChData.getBoardIdFromDat(url);
  //     case Communities.girlsCh:
  //       if (item is GirlsChContent) {
  //         return item.categoryId;
  //       }
  //     case Communities.futabaCh:
  //       return FutabaData.getBoardIdFromUrl(url);
  //     case Communities.machi:
  //       return MachiData.getBoardIdFromUrl(url);
  //     case Communities.shitaraba:
  //       return ShitarabaData.getBoardIdFromUrl(url);
  //     default:
  //   }
  //   return null;
  // }

  String? _getBoardId(final Uri uri, final FetchContentResultData content) {
    switch (type) {
      case Communities.girlsCh:
        final data = content.contentList?.lastOrNull;
        if (data is GirlsChContent) {
          return data.categoryId;
        }
        return null;
      default:
        return parent.getBoardIdFromUri(uri, type);
    }
  }

  Future<ContentData?> getSelectedRes(final Uri uri, final int resNum) async {
    List<ContentData?>? contentList;
    switch (type) {
      case Communities.girlsCh:
        final threadId = GirlsChData.getThreadIdFromUri(uri);
        if (threadId != null) {
          final result = await GirlsChHandler.getRes(threadId, resNum);
          contentList = result.contentList;
        }
        break;
      case Communities.shitaraba:
        final category = ShitarabaData.getCategoryFromUri(uri);
        final boardId = ShitarabaData.getBoardIdFromUri(uri);
        final threadId = ShitarabaData.getThreadIdFromUri(uri);
        if (category != null && boardId != null && threadId != null) {
          final result = await ShitarabaHandler.getRes(
              ShitarabaData.getThreadUrlPath(
                  category: category, boardId: boardId, threadId: threadId),
              resNum);
          contentList = result.contentList;
        }

        break;
      default:
        final (
          FetchContentResultData? contentResult,
          String? threadId,
          Uri uri
        )? result = await _getDataByUri(uri);
        final contentData = result?.$1;
        logger.i('getSelectedRes: ${contentData?.contentList?.length}');
        if (result == null ||
            contentData == null ||
            contentData.result != FetchResult.success) {
          return null;
        }
        contentList = contentData.contentList;
    }

    if (contentList == null) {
      return null;
    }

    ContentData? data;
    for (final i in contentList) {
      if (i?.index == resNum) {
        data = i;
      }
    }
    // final data = contentData.contentList!.firstWhere(
    //   (element) => element?.index == resNum,
    //   orElse: () => null,
    // );
    return data;
  }

  Future<(FetchContentResultData? contentResult, String? threadId, Uri uri)?>
      _getDataByUri(final Uri uriData) async {
    final uri = htmlToDatUri(uriData);
    logger.i('getDataByUri: $uri');
    if (uri == null) {
      return null;
    }
    final threadId = parent.getThreadIdFromUri(uri, type);
    if (threadId == null) {
      return null;
    }
    logger.i('getDataByUrl: uri: $uri, threadId: $threadId');
    return (await _fetchData(threadId, uri: uri), threadId, uri);
  }

  Future<FetchResult> getDataByUrl(final Uri uriData,
      {final bool setContent = true}) async {
    // final uri = htmlToDatUri(uriData);
    // logger.i('getDataByUri: $uri');
    // if (uri == null) {
    //   return FetchResult.error;
    // }
    // final threadId = parent.getThreadIdFromUri(uri, type);
    // if (threadId == null) {
    //   return FetchResult.error;
    // }
    // logger.i('getDataByUrl: uri: $uri, threadId: $threadId');
    final (
      FetchContentResultData? contentResult,
      String? threadId,
      Uri uri
    )? result = await _getDataByUri(uriData);
    final contentData = result?.$1;
    if (result == null ||
        contentData == null ||
        contentData.result != FetchResult.success) {
      return contentData?.result ?? FetchResult.error;
    }
    final uri = result.$3;
    final threadId = result.$2!;

    // final threadId = parent.getThreadIdFromUri(uri, type);
    final boardId = _getBoardId(uri, contentData);
    if (boardId == null) {
      return FetchResult.error;
    }

    final content = _getData(contentData, threadId, boardId, null);
    if (content == null) {
      return FetchResult.error;
    }
    if (setContent) {
      _setContent(content);
    }

    final markResult = await _setInitialThreadMarkData(
        content, '${uri.host}${uri.path}', null, null);
    if (markResult != FetchResult.success) {
      return contentData.result;
    }
    if (setContent) {
      search.setPrimaryView(PrimaryViewState.content);
    }

    return FetchResult.success;
  }

  Uri? htmlToDatUri(
    final Uri uri,
  ) {
    switch (type) {
      case Communities.shitaraba:
        return ShitarabaData.htmlToDatUri(uri);
      case Communities.fiveCh || Communities.pinkCh:
        return FiveChData.htmlToDatUri(uri, type);
      case Communities.machi:
        return MachiData.htmlToDatUri(uri);
      case Communities.open2Ch:
        return Open2ChData.htmlToDatUri(uri);
      default:
    }
    return uri;
  }

  @action
  Future<FetchContentResultData?> _fetchData<T extends ThreadBase>(
      final String dataId,
      {required final Uri uri,
      final int? lastPageForGirlsCh,
      final RangeList? range}) async {
    // final position =
    //     positionToGet ?? settings?.positionToGet ?? PositionToGet.first;
    switch (type) {
      case Communities.fiveCh || Communities.pinkCh:
        final host = uri.host;
        final boardId = FiveChData.getBoardIdFromUri(uri, type);
        if (boardId != null) {
          logger.i('_fetchData: host: $host');

          return await _getContentForFiveCh(
            dataId,
            domain: host,
            directoryName: boardId,
            // title: thread.title
          );
        }

      case Communities.girlsCh:
        // if (thread is! GirlsChThread) return null;
        // final positionToGet = settings!.positionToGet;
        // logger.d(
        //     'girlsCh: positionToGet: $positionToGet, ${T is ThreadMarkData}');
        return await _getContentForGirlsCh(dataId,
            page: lastPageForGirlsCh ?? 1);
      case Communities.futabaCh:
        final boardId = FutabaData.getBoardIdFromUri(uri);
        final directory = FutabaData.getDirectoryFromUri(uri);
        if (boardId != null && directory != null) {
          return await _getContentForFutabaCh(
              boardId: boardId, directory: directory, threadId: dataId
              // title: thread.title,
              // boardId: thread.boardId,
              // thumbnail: thread.thumbnailUrl
              );
        }
      // if (thread is! FutabaChThread) return null;

      case Communities.open2Ch:
        final host = uri.host;
        final boardId = Open2ChData.getBoardIdFromUri(uri);
        if (boardId != null) {
          logger.i('_fetchData: open: host: $host, $dataId, $boardId');

          return await _getContentForFiveCh(
            dataId,
            domain: host,
            directoryName: boardId,
            // title: thread.title
          );
        }

      case Communities.machi:
        final boardId = MachiData.getBoardIdFromUri(uri);
        logger.d('fetchData: $boardId, $dataId, uri: $uri');
        if (boardId != null) {
          return await _getContentForMachi(boardId: boardId, threadId: dataId);
        }

      case Communities.shitaraba:
        final category = ShitarabaData.getCategoryFromUri(uri);
        final boardId = ShitarabaData.getBoardIdFromUri(uri);
        final threadId = ShitarabaData.getThreadIdFromUri(uri);
        logger.d('shitaraba: url: $category, $boardId, $threadId');
        if (category != null && boardId != null && threadId != null) {
          return await _getContentForShitaraba(
              category: category,
              boardId: boardId,
              threadId: dataId,
              range: range ?? RangeList.last1000);
        }
      case Communities.chan4:
        final boardId = Chan4Data.getBoardIdFromUri(uri);
        final threadId = Chan4Data.getThreadIdFromUri(uri);
        logger.i('chan4: $uri, threadId: $threadId, $boardId');
        if (boardId != null && threadId != null) {
          return await _getContentForChan4(
              boardId: boardId, threadId: threadId);
        }

      default:
      // _toggleLoading();
    }
    return null;
  }

  ContentState? _getContentState(
    final ThreadContentData value,
  ) {
    if (parent.userData != null) {
      final data =
          ContentState(content: value, locale: parent.userData!.language.name);
      data.setHot(value.hot);
      data.setTimeago(selectedTimeagoList);
      data.setSelectedRangeList(value.range);
      data.setSelectedPage(value.girlsPages?.current);
      return data;
    }
    return null;
  }

  @action
  void _setContent(
    final ThreadContentData value,
  ) {
    final data = _getContentState(value);
    if (parent.largeScreen) {
      history.setContent(data);
    } else {
      switch (currentScreen) {
        case BottomMenu.forums:
          forumMain.setContent(data);
          break;
        case BottomMenu.history:
          history.setContent(data);
          break;
        case BottomMenu.search:
          search.setContent(data);
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

  Future<FetchResult> updateContent(
      {final RangeList? changedRange, final int? changedPage
      // final RangeList range = RangeList.last1000
      }) async {
    final thread = currentContentThreadData;
    if (thread == null) return FetchResult.error;
    // logger.d('position: 2: ${thread.positionToGet}');
    final currentRange = changedRange ?? currentContentState?.selectedRange;
    final selectedPage = changedPage ?? currentContentState?.selectedPage;
    final result = await _fetchData<ThreadMarkData>(thread.id,
        uri: thread.uri, lastPageForGirlsCh: selectedPage, range: currentRange);
    if (result == null) return FetchResult.error;
    final content = _getData(result, thread.id, thread.boardId, currentRange);
    if (content == null) return FetchResult.error;
    final lastReadIndex = changedPage != null || changedRange != null
        ? null
        : currentContentState?.content.content.lastOrNull?.index;
    final lastIndex = changedPage != null || changedRange != null
        ? null
        : currentContentState?.currentContentIndex;
    currentContentState?.setLastResIndex(lastReadIndex);
    // if (!parent.cancelInitialScroll) {
    //   parent.toggleCancelInitialScroll();
    // }
    _updateContent(content);

    return await _updateMarkData(
      thread,
      content,
      lastOpenedIndex: lastIndex,
    );
  }

  // Future<void> updatePositionToGet(final PositionToGet value) async {
  //   final thread = currentContentThreadData;
  //   if (thread == null) return;
  //   final current = thread.positionToGet;
  //   if (current == value) return;
  //   final newData = thread.copyWith(
  //     positionToGet: value,
  //     lastOpendIndex: null,
  //   );
  //   await updateContent(changedPositiontoGet: newData);
  //   // await parent.repository.updateThreadMark(newData);
  // }

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
        forum: type, domain: domain, directoryName: directoryName);
    return result;
  }

  @action
  Future<FetchContentResultData> _getContentForGirlsCh(final String id,
      {required final int page
      // required final PositionToGet positionToGet
      }) async {
    try {
      final result = await GirlsChHandler.getContent(id, page
          // categoryId: categoryId,
          // toGet: positionToGet
          );
      return result;
    } catch (e) {
      logger.e(e);
      parent.setLog(e.toString());
    }
    return FetchContentResultData();
  }

  @action
  Future<FetchContentResultData> _getContentForFutabaCh(
      {
      // required final String url,
      required final String boardId,
      required final String directory,
      required final String threadId}) async {
    // if (thread is! FutabaChThread) return;
    final result =
        await FutabaChHandler.getContent(boardId, directory, threadId);
    return result;
  }

  Future<FetchContentResultData> _getContentForShitaraba(
      {required final String category,
      required final String boardId,
      required final String threadId,
      required final RangeList range}) async {
    return await ShitarabaHandler.getContent(
        category, boardId, threadId, range);
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

  Future<FetchContentResultData> _getContentForChan4({
    required final String boardId,
    required final String threadId,
  }) async {
    // if (thread is! FutabaChThread) return;
    final result = await Chan4Handler.getContent(
      boardId,
      threadId,
    );
    return result;
  }

  // String? getBoardNameFromUri(final Uri uri, final Communities forum){

  // }

  Future<List<BoardData?>?> searchBoards(final String keyword,
      {final String? category}) async {
    late FetchBoardsResultData result;
    switch (type) {
      case Communities.shitaraba:
        if (category == null) return null;
        result = await ShitarabaHandler.searchBoards(category, keyword);
        break;
      default:
    }
    if (result.result == FetchResult.success) {
      return result.boards;
    }
    return null;
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

  Future<void> setLastOpenedContentIndex(
      final int? index, final String? contentId) async {
    final id = contentId ?? currentContent?.id;
    logger.d('setLastOpenedContentIndex: id:$id');
    if (index == null || id == null) return;

    // await indexStorage.setLastOpenedContentIndex(id, index);
  }

  Future<bool> postComment(final PostData value) async {
    final thread = currentContentThreadData;
    if (thread == null) return false;
    final uri = currentContentThreadData?.uri;
    if (uri == null) return false;

    switch (type) {
      case Communities.fiveCh || Communities.pinkCh:
        final domain = thread.uri.host;
        final bbs = thread.boardId;
        final threadId = FiveChData.getThreadIdFromUri(uri, type);
        if (threadId != null) {
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
      case Communities.girlsCh:
        final threadId = GirlsChData.getThreadIdFromUri(uri);
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
        // final thread = currentContentThreadData;
        // if (thread == null) return false;
        final directory = FutabaData.getDirectoryFromUri(uri);
        final id = FutabaData.getThreadIdFromUri(uri);
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
        final bbs = thread.boardId;
        final threadId = MachiData.getThreadIdFromUri(uri);
        // logger.d('machi post: bbs:$bbs, threadId: $threadId, ');
        if (threadId == null) return false;
        return await MachiHandler.post(value, bbs, threadId);
      case Communities.shitaraba:
        await ShitarabaHandler.post(value,
            category: thread.shitarabaCategory,
            boardId: thread.boardId,
            threadId: thread.id);
        break;
      case Communities.open2Ch:
        final domain = thread.uri.host;
        final bbs = thread.boardId;
        final threadId = Open2ChData.getThreadIdFromUri(uri);
        if (threadId != null) {
          final result =
              await Open2ChHandler.post(value, domain, bbs, threadId);
          if (result != null) {
            // await Future.delayed(const Duration(milliseconds: 500));
            final resMark = ResMarkData(index: result, icon: MarkIcon.edit);
            await updateMark(resMark);
            return true;
          }
        }
        return false;

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
        final directory = FutabaData.getDirectoryFromUri(thread.uri);
        final id = FutabaData.getThreadIdFromUri(thread.uri);
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
