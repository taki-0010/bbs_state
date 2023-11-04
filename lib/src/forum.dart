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

  @observable
  ObservableSet<BoardMetaData?> boardMetadataSet =
      ObservableSet<BoardMetaData?>();

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

  void setResultMessage(final FetchResult? result, final int? statuscode) {
    switch (result) {
      case FetchResult.error:
        setErrorMessage('Error!');
        break;
      case FetchResult.networkError:
        setErrorMessage('Statuscode: $statuscode');
      default:
        setErrorMessage('Error!');
    }
  }

  @action
  Future<void> setBoardMetadata(
      final String directory, final String boardId) async {
    switch (type) {
      case Communities.fiveCh || Communities.pinkCh:
        final data =
            await FiveChHandler.getSettingTxt(directory, boardId, type);
        if (data != null) {
          final meta =
              BoardMetaData(data: data, directory: directory, boardId: boardId);
          boardMetadataSet.add(meta);
        }
        break;
      case Communities.shitaraba:
        final data = await ShitarabaHandler.getMetadata(directory, boardId);
        if (data != null) {
          final meta =
              BoardMetaData(data: data, directory: directory, boardId: boardId);
          boardMetadataSet.add(meta);
        }
      default:
    }
  }

  String boardNameByIdFromMetadataSet(final String boardId) {
    switch (type) {
      case Communities.fiveCh || Communities.pinkCh:
        final name = boardMetadataSet.firstWhere(
          (value) => value?.boardId == boardId,
          orElse: () => null,
        );
        if (name != null) {
          final result = FiveChData.boardNameById(name.data);
          if (result != null) {
            return result;
          }
        }
        break;

      default:
    }
    return boardId;
  }

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

  @computed
  List<ImportanceData?> get forumVeryImList =>
      getImpList(ImportanceList.veryImportant);

  @computed
  List<ImportanceData?> get forumImList => getImpList(ImportanceList.important);
  @computed
  List<ImportanceData?> get forumUnimList =>
      getImpList(ImportanceList.unimportant);
  @computed
  List<ImportanceData?> get forumVeryUnimList =>
      getImpList(ImportanceList.veryUnimportant);

  @computed
  List<ImportanceData?> get titleImportanceList =>
      settings?.getImportanceList
          .where((element) => element?.target == ImportanceTarget.title)
          .toList() ??
      [];

  @computed
  List<ImportanceData?> get nameImportanceList {
    return settings?.getImportanceList
            .where((element) => element?.target == ImportanceTarget.userName)
            .toList() ??
        [];
  }

  @computed
  List<ImportanceData?> get postIdImportanceList {
    return settings?.getImportanceList
            .where((element) => element?.target == ImportanceTarget.postId)
            .toList() ??
        [];
  }

  @computed
  List<ImportanceData?> get userIdImportanceList {
    return settings?.getImportanceList
            .where((element) => element?.target == ImportanceTarget.userId)
            .toList() ??
        [];
  }

  @computed
  List<ImportanceData?> get bodyImportanceList {
    return settings?.getImportanceList
            .where((element) => element?.target == ImportanceTarget.body)
            .toList() ??
        [];
  }

  List<ImportanceData?> getImpList(final ImportanceList value) =>
      settings?.getImportanceList
          .where((element) => element?.level == value)
          .toList() ??
      [];

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
    final settingsData = settings?.getImportanceList;
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

  // ThreadContentData? _getData(final FetchContentResultData value,
  //     final String threadId, final String boardId, final RangeList? range) {
  //   if (value.contentList != null && value.threadLength != null) {
  //     final hot = getIkioi(int.tryParse(threadId) ?? 0, value.threadLength!);
  //     final content = ThreadContentData(
  //         id: threadId,
  //         boardId: boardId,
  //         type: type,
  //         content: value.contentList!,
  //         threadLength: value.threadLength!,
  //         hot: hot,
  //         range: range,
  //         girlsPages: value.girlsPages,
  //         tags: value.tags
  //         // archived: value.archived ?? false
  //         );
  //     return content;
  //   }
  //   return null;
  // }

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

  Future<ThreadContentData?> _getThreadContent(final String id,
      {required final ThreadBase thread}) async {
    final range = ShitarabaData.getRange(thread);
    final currentPageOfGirlsCh = _getcurrentPageForGirlsCh(thread);
    // final position = thread is ThreadMarkData ? thread.positionToGet : null;
    // logger.d('_getThreadContent: id');
    final result = await _fetchData(id,
        uri: thread.uri,
        lastPageForGirlsCh: currentPageOfGirlsCh,
        range: range);
    if (result == null) {
      logger.e('_getThreadContent: null');
      return null;
    }
    if (result.result != FetchResult.success) {
      return null;
    }
    return result.content;
    // return _getData(result, thread.id, thread.boardId, range);
  }

  @action
  Future<FetchResult> setContent(final String id,
      {required final ThreadBase thread}) async {
    final content = await _getThreadContent(id, thread: thread);
    if (content == null) {
      logger.e('setContent: null');
      setResultMessage(FetchResult.error, null);
      return FetchResult.error;
    }

    _setContent(
      content,
    );
    // logger.i(
    //     'setContent: range:$range, content.range: ${content.range}, page: ${result.girlsPages?.next}');
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
          case BottomMenu.forums || BottomMenu.history:
            final diff = forumMain.currentBoardDiff?.firstWhere(
              (element) => element?.id == thread.id,
              orElse: () => null,
            );
            if (diff != null) {
              if (currentScreen == BottomMenu.forums) {
                forumMain.content?.setLastResIndex(diff.before);
              }
              if (currentScreen == BottomMenu.history && parent.largeScreen) {
                history.content?.setLastResIndex(diff.before);
              }
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
          content, thread.url, thread.thumbnailFullUrl, thread.boardName);
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
      case Communities.hatena:
        final last =
            value.content.length >= 2 ? value.content.lastOrNull : null;
        if (last?.createdAt != null) {
          return (last!.createdAt!.millisecondsSinceEpoch * 0.001).toInt();
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
    // final session = '';
    // final session = await currentSessionId;
    final user = parent.repository.user;
    // final user = await parent.server.userState.getUserAccount;
    if (user != null && settings != null) {
      final resCount = content.threadLength;
      // final resCount = content.lastIndex ?? 0;
      final title = content.content.firstOrNull?.title;
      // final thumbnail = content.content.firstOrNull?.srcThumbnail;
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
          // sessionId: session,
          boardId: content.boardId,
          // thumbnailStr: thumbnailData,
          thumbnailFullUrl: thumbnailData,
          // thumbnailStr: thumbnailData ??
          //     jsonEncode(SrcData(thumbnailUri: thumbnail).toJson()),
          title: title ?? '',
          // boardName: null,
          // positionToGet: settings!.positionToGet,
          createdAtBySeconds: createdAtBySeconds ?? 0,
          lastReadAt: now.millisecondsSinceEpoch,
          retentionPeriodSeconds:
              now.add(Duration(hours: retention)).millisecondsSinceEpoch);

      // history.setLog(newLog);
      logger.f(
          '_setInitialThreadMarkData: $retention, title: $title, hot: $hot, retention: $thumbnailData, lastRead: ${newLog.lastReadAt}');
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

  Future<String?> _getBoardId(
      final Uri uri, final FetchContentResultData content) async {
    switch (type) {
      case Communities.girlsCh:
        final data = content.content?.content.lastOrNull;
        if (data is GirlsChContent) {
          return data.categoryId;
        }
      case Communities.hatena:
        final item = content.content?.content.firstOrNull;
        if (item is HatenaContent) {
          return item.boardId;
        }
      default:
        return parent.getBoardIdFromUri(uri, type);
    }
    return null;
  }

  Future<ContentData?> getSelectedRes(final Uri uri, final int resNum) async {
    List<ContentData?>? contentList;
    switch (type) {
      case Communities.girlsCh:
        final threadId = GirlsChData.getThreadIdFromUri(uri);
        if (threadId != null) {
          final result = await GirlsChHandler.getRes(threadId, resNum);
          contentList = result.content?.content;
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
          contentList = result.content?.content;
        }

        break;
      default:
        final (
          FetchContentResultData? contentResult,
          String? threadId,
          Uri uri
        )? result = await _getDataByUri(uri);
        final contentData = result?.$1;
        // logger.i('getSelectedRes: ${contentData?.contentList?.length}');
        if (result == null ||
            contentData == null ||
            contentData.result != FetchResult.success) {
          return null;
        }
        contentList = contentData.content?.content;
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
    final uri = _htmlToDatUri(uriData);
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
    // final threadId = result.$2!;

    // final threadId = parent.getThreadIdFromUri(uri, type);
    final boardId = await _getBoardId(uri, contentData);
    if (boardId == null) {
      return FetchResult.error;
    }
    final content = contentData.content;

    // final content = _getData(contentData, threadId, boardId, null);
    if (content == null) {
      return FetchResult.error;
    }
    if (setContent) {
      _setContent(content);
    }
    final thmb = contentData.thumbnailUrl;
    // final thumbnail =
    //     thmb != null ? jsonEncode(SrcData(thumbnailUri: thmb).toJson()) : null;
    // logger.d('thmb: $thmb');

    final markResult = await _setInitialThreadMarkData(
        content, '${uri.host}${uri.path}', thmb, null);
    if (markResult != FetchResult.success) {
      return contentData.result;
    }
    if (setContent) {
      search.setPrimaryView(PrimaryViewState.content);
    }

    return FetchResult.success;
  }

  Uri? _htmlToDatUri(
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
      // case Communities.hatena:
      //   return HatenaData.htmlToJsonUri(uri);
      default:
    }
    return uri;
  }

  @action
  Future<FetchContentResultData?> _fetchData<T extends ThreadBase>(
      final String dataId,
      {required final Uri uri,
      // final ThreadData? threadData,
      final int? lastPageForGirlsCh,
      final RangeList? range,
      final int? malOffset}) async {
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
      case Communities.hatena:
        // final url = !dataId.startsWith('http') ? 'https://$dataId' : dataId;
        return await _getContentForHatena(dataId);
      case Communities.mal:
        return await _getContentForMal(dataId, offset: malOffset);

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
      final ikioi = getIkioi(value.createdAt ?? 0, value.threadLength);
      data.setHot(ikioi);
      data.setTimeago(selectedTimeagoList);
      data.setSelectedRangeList(value.range);
      data.setSelectedPage(value.girlsPages?.current);
      data.setPoll(value.malOption?.poll);
      data.setMalPaging(value.malOption?.paging);
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

  Future<(FetchResult, int?)> updateContent(
      {final RangeList? changedRange,
      final int? changedPage,
      final int? malOffset
      // final RangeList range = RangeList.last1000
      }) async {
    final thread = currentContentThreadData;
    if (thread == null) return (FetchResult.error, null);
    final disableUpdateIndex =
        changedPage != null || changedRange != null || malOffset != null;
    // logger.d('position: 2: ${thread.positionToGet}');
    final currentRange = changedRange ?? currentContentState?.selectedRange;
    final selectedPage = changedPage ?? currentContentState?.selectedPage;
    final result = await _fetchData<ThreadMarkData>(thread.id,
        uri: thread.uri,
        lastPageForGirlsCh: selectedPage,
        range: currentRange,
        malOffset: malOffset);
    if (result == null) return (FetchResult.error, null);
    // final content = _getData(result, thread.id, thread.boardId, currentRange);
    final content = result.content;
    if (content == null) return (FetchResult.error, null);
    final oldLength = thread.resCount;
    final newLength = content.threadLength;
    final diff = newLength - oldLength;
    logger.d('updateContent: $oldLength, $newLength, diff: $diff');
    final lastReadIndex = disableUpdateIndex
        ? null
        : currentContentState?.content.content.lastOrNull?.index;
    final lastIndex =
        disableUpdateIndex ? null : currentContentState?.currentContentIndex;
    currentContentState?.setLastResIndex(lastReadIndex);

    _updateContent(content);

    final updated = await _updateMarkData(
      thread,
      content,
      lastOpenedIndex: lastIndex,
    );
    return (updated, diff);
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

  Future<void> updateForumImportance(final List<ImportanceData?> value,
      {final bool delete = false}) async {
    final current = settings?.getImportanceList;
    if (current == null) {
      return;
    }
    final copied = [...current];
    for (final i in value) {
      if (i != null) {
        copied.removeWhere((element) => element?.id == i.id);
        if (!delete) {
          copied.insert(0, i);
        }
      }
    }
    final strList =
        copied.map((e) => e != null ? jsonEncode(e.toJson()) : null).toList();
    final newData = settings!.copyWith(importanceList: strList);
    await _updateSettings(newData);
    // await parent.updateForumSettings();
  }

  Future<void> clearForumImportance(final ImportanceList value) async {
    final current = settings?.getImportanceList;
    if (current == null) {
      return;
    }
    final copied = [...current];
    copied.removeWhere((element) => element?.level == value);
    final strList =
        copied.map((e) => e != null ? jsonEncode(e.toJson()) : null).toList();
    final newData = settings!.copyWith(importanceList: strList);
    await _updateSettings(newData);
  }

  Future<void> deleteTemplate(
      final InputCommentFields field, final String value) async {
    TemplateData? current = template;
    if (current == null) {
      return;
    }
    switch (field) {
      case InputCommentFields.body:
        final list = [...current.bodys];
        list.removeWhere((element) => element == value);
        current = current.copyWith(bodys: list);
        break;
      case InputCommentFields.name:
        final list = [...current.names];
        list.removeWhere((element) => element == value);
        current = current.copyWith(names: list);
        break;
      case InputCommentFields.email:
        final list = [...current.emails];
        list.removeWhere((element) => element == value);
        current = current.copyWith(emails: list);
        break;
      case InputCommentFields.subject:
        final list = [...current.subjects];
        list.removeWhere((element) => element == value);
        current = current.copyWith(subjects: list);
        break;
      default:
    }
    await parent.repository.updateTemplateData(current);
  }

  Future<void> clearTemplate(final InputCommentFields value) async {
    TemplateData? current = template;
    if (current == null) {
      return;
    }
    switch (value) {
      case InputCommentFields.body:
        current = current.copyWith(bodys: []);
        break;
      case InputCommentFields.name:
        current = current.copyWith(names: []);
        break;
      case InputCommentFields.email:
        current = current.copyWith(emails: []);
        break;
      case InputCommentFields.subject:
        current = current.copyWith(subjects: []);
        break;
      default:
    }
    await parent.repository.updateTemplateData(current);
  }

  Future<void> updateThreadImportance(final ImportanceData value,
      {final bool delete = false}) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final current = [...thread.importanceList];
    current.removeWhere((element) => element?.id == value.id);
    if (!delete) {
      current.insert(0, value);
    }
    logger.i('imp: ${value.level}, str: ${value.strValue}');
    final strList =
        current.map((e) => e != null ? jsonEncode(e.toJson()) : null).toList();
    final newData = thread.copyWith(importance: strList);
    await parent.repository.updateThreadMark(newData);
  }

  Future<void> clearThreadImportance(final ImportanceList value) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final current = [...thread.importanceList];
    current.removeWhere((element) => element?.level == value);
    final strList =
        current.map((e) => e != null ? jsonEncode(e.toJson()) : null).toList();
    final newData = thread.copyWith(importance: strList);
    await parent.repository.updateThreadMark(newData);
  }

  Future<void> allClearThreadImportance() async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final newData = thread.copyWith(importance: []);
    await parent.repository.updateThreadMark(newData);
  }

  Future<void> _updateSettings(final ForumSettingsData value) async {
    setSettings(value);
    await parent.updateForumSettings();
  }

  Future<void> setSaveLastUsedText(
      final InputCommentFields target, final bool value) async {
    final current = settings;
    if (current == null) {
      return;
    }
    bool currentValue = false;
    switch (target) {
      case InputCommentFields.name:
        currentValue = current.saveLastUsedName;
        break;
      case InputCommentFields.email:
        currentValue = current.saveLastUsedEmail;
        break;
      case InputCommentFields.subject:
        currentValue = current.saveLastUsedSubject;
        break;
      default:
    }
    if (currentValue == value) return;
    ForumSettingsData data = current;
    switch (target) {
      case InputCommentFields.name:
        data = current.copyWith(saveLastUsedName: value);
        break;
      case InputCommentFields.email:
        data = current.copyWith(saveLastUsedEmail: value);
        break;
      case InputCommentFields.subject:
        data = current.copyWith(saveLastUsedSubject: value);
        break;
      default:
    }
    await _updateSettings(data);
  }

  Future<void> saveLastUsedText(final PostData value) async {
    ForumSettingsData? current = settings;
    if (current == null) {
      return;
    }
    final saveName = current.saveLastUsedName;
    final saveEmail = current.saveLastUsedEmail;
    final saveSubject = current.saveLastUsedSubject;
    final data = current.copyWith(
        lastUsedName: saveName ? value.name : null,
        lastUsedEmail: saveEmail ? value.email : null,
        lastUsedSubject: saveSubject ? value.title : null);
    await _updateSettings(data);
  }

  // Future<void> deleteImportance(final ImportanceData value) async {
  //   final thread = currentContentThreadData;
  //   if (thread == null) return;
  //   final current = [...thread.importanceList];
  //   current.removeWhere((element) => element?.id == value.id);
  //   final strList = current.map((e) => jsonEncode(e?.toJson())).toList();
  //   final newData = thread.copyWith(importance: strList);
  //   await parent.repository.updateThreadMark(newData);
  // }

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

  // @action
  Future<FetchContentResultData> _getContentForHatena(final String url) async {
    final result = await HatenaHandler.getContent(url);
    return result;
  }

  Future<FetchContentResultData> _getContentForMal(final String threadId,
      {final int? offset}) async {
    int? threadLength;
    String? boardId;
    final threadMain = forumMain.threadList.firstWhere(
      (e) => e?.id == threadId,
      orElse: () => null,
    );
    final threadHistory = history.markList.firstWhere(
      (e) => e?.id == threadId,
      orElse: () => null,
    );
    if (threadMain != null || threadHistory != null) {
      threadLength = threadMain?.resCount ?? threadHistory?.resCount;
      boardId = threadMain?.boardId ?? threadHistory?.boardId;
    } else {
      final fields = await MalHandler.getFieldsFromHtml(threadId);
      boardId = fields?.$1;
      threadLength = fields?.$2;
      logger.d('_getContentForMal: $boardId, $threadLength');
    }
    if (boardId != null && boardId.isNotEmpty) {
      final result = await MalHandler.getContent(
          threadId, threadLength, boardId,
          offset: offset);
      return result;
    }
    return FetchContentResultData();
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
    if (result.result == FetchResult.success) {
      final sub = domain.split('.').first;
      final boardMetadata = boardMetadataSet.firstWhere(
        (value) => value?.directory == sub && value?.boardId == directoryName,
        orElse: () => null,
      );
      if (boardMetadata == null) {
        await setBoardMetadata(sub, directoryName);
      }
    }
    return result;
  }

  Future<FetchThreadsResultData> getFiveChThreads(
      final String domain, final String directory, final String name) async {
    return await FiveChHandler.getThreads(
        domain: domain,
        directoryName: directory,
        boardName: name,
        forum: Communities.fiveCh);
  }

  Future<FetchThreadsResultData> getPinkChThreads(
      final String domain, final String directory, final String name) async {
    return await PinkChHandler.getThreads(
        domain: domain, directoryName: directory, boardName: name);
  }

  Future<FetchThreadsResultData> getOpen2chThreads(
      final String directory, final String boardId, final String name) async {
    return await Open2ChHandler.getThreads(directory, boardId, name);
  }

  Future<FetchThreadsResultData> getMachiThreads(final String boardId) async {
    return await MachiHandler.getThreads(boardId);
  }

  Future<FetchThreadsResultData> getChan4Threads(final String boardId) async {
    return await Chan4Handler.getThreads(boardId);
  }

  Future<FetchThreadsResultData> getShitarabaThreads(
      final String category, final String boardId, final String? name) async {
    return await ShitarabaHandler.getThreads(category, boardId, name ?? '');
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
    final result =
        await ShitarabaHandler.getContent(category, boardId, threadId, range);
    if (result.result == FetchResult.success) {
      final boardMetadata = boardMetadataSet.firstWhere(
        (value) => value?.directory == category && value?.boardId == boardId,
        orElse: () => null,
      );
      if (boardMetadata == null) {
        await setBoardMetadata(category, boardId);
      }
      return result;
    }
    return FetchContentResultData();
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

  Future<void> blockThreadPostUser(final ThreadData thread) async {
    final content = await _getThreadContent(thread.id, thread: thread);
    if (content != null) {
      final first = content.content.first;
      if (first != null) {
        final data = first.getPostId != null
            ? ImportanceData(
                id: randomInt(),
                target: ImportanceTarget.postId,
                level: ImportanceList.veryUnimportant,
                strValue: first.getPostId!)
            : null;
        final title = ImportanceData(
            id: randomInt(),
            target: ImportanceTarget.title,
            level: ImportanceList.veryUnimportant,
            strValue: thread.title);
        await parent.updateForumImportance([data, title]);
      }
    }
  }

  Future<void> blockThreadResponseUser(final ContentData value) async {
    final postId = value.getPostId != null
        ? ImportanceData(
            id: randomInt(),
            target: ImportanceTarget.postId,
            level: ImportanceList.veryUnimportant,
            strValue: value.getPostId!)
        : null;
    final userId = value.getUserId != null
        ? ImportanceData(
            id: randomInt(),
            target: ImportanceTarget.userId,
            level: ImportanceList.veryUnimportant,
            strValue: value.getUserId!)
        : null;
    logger.d('userId: ${value.getUserId}');
    // await _updateImportantResponse([postId, userId]);
    await parent.updateForumImportance([postId, userId]);
  }

  Future<void> hideResponse(final ContentData value) async {
    String body = value.body;
    if (body.length >= ConstantsDataBase.importanceMaxLength) {
      body = body.substring(0, ConstantsDataBase.importanceMaxLength);
    }
    final data = ImportanceData(
        id: randomInt(),
        target: ImportanceTarget.body,
        level: ImportanceList.veryUnimportant,
        strValue: body);
    await _updateImportantResponse([data]);
  }

  Future<void> _updateImportantResponse(
      final List<ImportanceData?> value) async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    final current = [...thread.importanceList];
    current.insertAll(0, value);
    // logger.i('imp: ${value.level}, str: ${value.strValue}');
    final strList =
        current.map((e) => e != null ? jsonEncode(e.toJson()) : null).toList();
    final newData = thread.copyWith(importance: strList);
    await parent.repository.updateThreadMark(newData);
    return;
  }

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
            await Future.delayed(const Duration(milliseconds: 500));
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
