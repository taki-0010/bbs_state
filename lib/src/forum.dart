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
  List<ThreadBase?> get historyList => history.markList;

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

  @action
  Future<bool> setContent(final String id,
      {required final ThreadBase thread}) async {
    // _toggleLoading();

    final content = await _getData(id, thread: thread);
    if (content == null) {
      logger.e('setContent: null');
      return false;
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
            forumMain.content?.setLastResIndex(exist.resCount);
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

  Future<bool> _updateMark(
      final ThreadBase thread, final ThreadContentData? content) async {
    if (content == null) {
      return false;
    }
    final exist = historyList.firstWhere(
        (element) =>
            element?.id == thread.id && element?.boardId == thread.boardId,
        orElse: () => null);
    logger.i('_updateMarkData: ${exist?.id}');
    if (exist != null && exist is ThreadMarkData) {
      return _updateMarkData(exist, content);
    } else {
      return await _setInitialThreadMarkData(
          content, thread.url, thread.thumbnailStr);
      // if (thread is! ThreadData) return false;
      // final exist = history.markList.firstWhere(
      //   (element) => element?.id == thread.id,
      //   orElse: () => null,
      // );
      // if (exist == null) {
      //   return await _setInitialThreadMarkData(
      //       content, thread.url, thread.thumbnailStr);
      // } else {
      //   return true;
      // }
    }
  }

  int? _getCreatedAtBySecounds(final ThreadContentData value) {
    switch (value.type) {
      case Communities.fiveCh:
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
      case Communities.pinkCh:
        return int.tryParse(value.id);
      default:
        return null;
    }
  }

  // Future<void> setThreadMarkDataToHistoryList(final String url) async {}

  Future<bool> _setInitialThreadMarkData(final ThreadContentData content,
      final String url, final String? thumbnailData) async {
    final session = '';
    // final session = await currentSessionId;
    final user = parent.repository.user;
    // final user = await parent.server.userState.getUserAccount;
    if (user != null && settings != null) {
      final resCount = content.lastIndex ?? 0;
      final title = content.content.firstOrNull?.title;
      final thumbnail = content.content.firstOrNull?.srcThumbnail;
      final hot = getIkioi(int.tryParse(content.id) ?? 0, resCount);
      final retention = _getRetentionPeriodSeconds(hot);
      final documentId = _getDocumentId(content.id, content.boardId);
      final createdAtBySeconds = _getCreatedAtBySecounds(content);

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
          retentionPeriodSeconds: DateTime.now()
              .add(Duration(hours: retention))
              .millisecondsSinceEpoch);

      // history.setLog(newLog);
      logger.f(
          '_setInitialThreadMarkData: $retention, title: $title, hot: $hot, retention: ${settings?.retentionPeriod}');
      await parent.repository.saveThreadMark(newLog);
      return true;
    } else {
      logger.e('_setInitialThreadMarkData: user ==null || settings == null');
      // throw '_setInitialThreadMarkData: user ==null || settings == null';
      return false;
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

  Future<bool> _updateMarkData(
      final ThreadMarkData thread, final ThreadContentData content,
      {final int? lastOpenedIndex}) async {
    final resCount = content.lastIndex ?? thread.resCount;
    if (resCount == thread.resCount) return true;
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
    return true;
  }

  int getRetentionSinceEpoch(final int resCount, final ThreadMarkData thread) {
    if (retentionPeriod != RetentionPeriodList.byPostPace) {
      return thread.retentionPeriodSeconds;
    }
    final hot = getIkioi(int.tryParse(thread.id) ?? 0, resCount);
    final retention = _getRetentionPeriodSeconds(hot);
    logger.i(
        'getRetentionSinceEpoch: hot: $hot, retention: $retention, retentionPeriod: $retentionPeriod, ${thread.retentionPeriodSeconds}');
    return DateTime.now()
        .add(Duration(hours: retention))
        .millisecondsSinceEpoch;
  }

  int _getRetentionPeriodSeconds(final double hot) {
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

  Future<bool> getDataByUrl(final String url,
      {final bool setContent = true}) async {
    List<ContentData?>? result;
    bool archived = false;
    String? id;
    String? boardId;
    switch (type) {
      case Communities.fiveCh:
        id = FiveChParser.getId(url);
        final host = Uri.parse(url).host;
        boardId = FiveChParser.getBoardIdFromDat(url);
        logger.i('getDataByUrl: $url, id:$id, $boardId, host:$host');
        if (id != null && boardId != null) {
          (result, archived) = await _getContentForFiveCh(
            id,
            domain: host,
            directoryName: boardId,
            // title: thread.title
          );
        }
        break;
      case Communities.girlsCh:
        id = GirlsChParser.getIdFromUrl(url);

        final position = settings?.positionToGet;
        if (id != null && position != null) {
          result = await _getContentForGirlsCh(
            id,
            // categoryId: thread.boardId,
            // thumbnail: thread.thumbnailUrl,
            positionToGet: position,
            // title: thread.title
          );
          if (result != null) {
            final item = result.firstOrNull;
            if (item is GirlsChContent) {
              boardId = item.categoryId;
            }
          }
        }
        break;
      case Communities.futabaCh:
        id = FutabaParser.getIdFromUrl(url);
        boardId = FutabaParser.getBoardIdFromUrl(url);
        final directory = FutabaParser.getDirectory(Uri.parse(url));
        if (id != null && boardId != null && directory != null) {
          result = await _getContentForFutabaCh(
              url: url.replaceAll('https://', ''), directory: directory);
        }
        break;
      case Communities.pinkCh:
        id = FiveChParser.getId(url);
        final host = Uri.parse(url).host;
        boardId = FiveChParser.getBoardIdFromDat(url);
        if (id != null && boardId != null) {
          (result, archived) = await _getContentForFiveCh(
            id,
            domain: host,
            directoryName: boardId,
            // title: thread.title
          );
        }
        break;
      default:
    }
    if (result != null) {
      final content = ThreadContentData(
          id: id!,
          boardId: boardId!,
          type: type,
          content: result,
          archived: archived);
      if (setContent) {
        _setContent(content);
      }

      final success = await _setInitialThreadMarkData(
          content, url.replaceAll('https://', ''), null);
      if (setContent) {
        search.setPrimaryView(PrimaryViewState.content);
      }
      return success;
    }
    return false;
  }

  @action
  Future<ThreadContentData?> _getData<T extends ThreadBase>(final String dataId,
      {required final T thread, final PositionToGet? positionToGet}) async {
    // if (board == null) return;
    // _toggleLoading();
    List<ContentData?>? result;
    bool archived = false;
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
        logger.i('_getData: host: $host');

        final data = await _getContentForFiveCh(
          dataId,
          domain: host,
          directoryName: thread.boardId,
          // title: thread.title
        );
        result = data.$1;
        archived = data.$2;
        logger.i('_getData: five: ${result?.length}');
        // _toggleLoading();
        break;
      case Communities.girlsCh:
        // if (thread is! GirlsChThread) return null;
        // final positionToGet = settings!.positionToGet;
        logger.d(
            'girlsCh: positionToGet: $positionToGet, ${T is ThreadMarkData}');
        result = await _getContentForGirlsCh(
          dataId,
          // categoryId: thread.boardId,
          // thumbnail: thread.thumbnailUrl,
          positionToGet: position,
          // title: thread.title
        );
        parent.setLog('_getData: $type, result: ${result?.length}');
        // _toggleLoading();
        break;
      case Communities.futabaCh:
        // if (thread is! FutabaChThread) return null;
        result = await _getContentForFutabaCh(
            url: thread.url, directory: thread.futabaDirectory
            // title: thread.title,
            // boardId: thread.boardId,
            // thumbnail: thread.thumbnailUrl
            );
        // _toggleLoading();
        break;
      case Communities.pinkCh:
        // if (thread is! FiveChThreadTitleData) return null;
        final data = await _getContentForFiveCh(
          dataId,
          domain: thread.uri.host,
          directoryName: thread.boardId,
          // title: thread.title
        );
        result = data.$1;
        archived = data.$2;
        logger.i('_getData: five: ${result?.length}');
        // _toggleLoading();
        break;
      default:
      // _toggleLoading();
    }
    if (result != null) {
      final content = ThreadContentData(
          id: thread.id,
          boardId: thread.boardId,
          type: type,
          content: result,
          archived: archived);
      return content;

      // await _setContent(content);
    }
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

  Future<void> updateContent() async {
    final thread = currentContentThreadData;
    if (thread == null) return;
    // logger.d('position: 2: ${thread.positionToGet}');
    final content = await _getData<ThreadMarkData>(thread.id,
        thread: thread, positionToGet: thread.positionToGet);
    if (content == null) return;
    final lastIndex = currentContentState?.currentContentIndex;
    currentContentState?.setLastResIndex(lastIndex);
    // if (!parent.cancelInitialScroll) {
    //   parent.toggleCancelInitialScroll();
    // }
    _updateContent(content);

    await _updateMarkData(thread, content, lastOpenedIndex: lastIndex);
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
      // case Communities.futabaCh:
      //   final boardId = currentContent?.boardId;
      //   if (boardId == null) return;
      //   final item = value as FutabaChContent;

      //   final result = await FutabaChHandler.sendAgree(
      //       item.directory, boardId, item.number.toString());
      default:
    }
  }

  @action
  Future<(List<FiveChThreadContentData>?, bool)> _getContentForFiveCh(
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
  Future<List<GirlsChContent?>?> _getContentForGirlsCh(final String id,
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
    return null;
  }

  @action
  Future<List<FutabaChContent?>?> _getContentForFutabaCh({
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

  // @action
  // void deleteDataById(final String id) {
  //   // logList.removeWhere((element) => element?.id == id);
  // }

  // Future<void> post(final ContentMetaData value) async {
  //   // if (board == null) return;
  //   // final domain = currentBoardDomain;
  //   // if (domain == null) return;
  //   // logger.d('post: board: ${board?.directoryName}, domain: $currentBoardDomain');
  //   // await FiveChHandler.post(value, domain, board!.directoryName);
  // }

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

  Future<bool> postComment(final CommentData value) async {
    switch (type) {
      case Communities.fiveCh:
        final domain = currentContentThreadData?.uri.host;
        final bbs = currentContentThreadData?.boardId;
        if (domain != null && bbs != null) {
          final result = await FiveChHandler.post(value, domain, bbs);
          if (result != null) {
            final resnum = int.tryParse(result.resnum ?? '0');
            if (resnum == null || resnum == 0) {
              return false;
            }
            final resMark = ResMarkData(index: resnum, icon: MarkIcon.edit);
            await updateMark(resMark);
            return true;
          }
        }
        return false;
      case Communities.pinkCh:
        final domain = currentContentThreadData?.uri.host;
        final bbs = currentContentThreadData?.boardId;
        if (domain != null && bbs != null) {
          final result = await FiveChHandler.post(value, domain, bbs);
          if (result != null) {
            final resnum = int.tryParse(result.resnum ?? '0');
            if (resnum == null || resnum == 0) {
              return false;
            }
            final resMark = ResMarkData(index: resnum, icon: MarkIcon.edit);
            await updateMark(resMark);
            return true;
          }
        }
        return false;
      // case Communities.girlsCh:
      //   final result = await GirlsChHandler.post(value);
      //   if (result != null) {
      //     await commentsStorage.setComment(result);
      //     return true;
      //   }
      //   return false;
      default:
    }
    return false;
  }

  void deleteContent(final ThreadMarkData? value) {
    if (value != null) {
      forumMain.deleteData(value);
      history.deleteData(value);
      search.deleteData(value);
    }
  }

  void clear() {
    forumMain.clear();
    history.clear();
    search.clear();
  }
}
