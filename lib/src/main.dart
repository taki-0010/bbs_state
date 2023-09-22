// import 'dart:typed_data';

// import 'dart:math';
import 'dart:convert';
// import 'dart:html';
import 'dart:typed_data';

import 'importer.dart';

part 'main.g.dart';

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store, WithDateTime {
  // late final userStorage = UserStorageState(parent: this);
  late final repository = RepositoryState(parent: this);
  // late final server = AppwriteState(parent: this);

  late final fiveCh = ForumState(parent: this, type: Communities.fiveCh);
  late final girlsCh = ForumState(parent: this, type: Communities.girlsCh);
  late final futabaCh = ForumState(parent: this, type: Communities.futabaCh);
  late final pinkCh = ForumState(parent: this, type: Communities.pinkCh);

  // late final SembastCacheStore store;

  @observable
  LaunchStatus launchStatus = LaunchStatus.loading;

  @observable
  bool devMode = false;

  @observable
  int devModeCount = 0;

  @action
  void toggleDevMode() {
    devMode = true;
  }

  @action
  void devCount() {
    devModeCount += 1;
    if (devModeCount >= 30) {
      toggleDevMode();
    }
    logger.d('devmode on: $devModeCount');
  }

  @observable
  ObservableList<String?> debugLog = ObservableList<String?>();

  @observable
  String? overlayId;

  @action
  void setOverlayId(final String? id) => overlayId = id;

  // bool? isWeb;
  // bool? isDebugMode;

  // @observable
  // UserSettingsData? userSettings;

  // @computed
  // String? get randomStr => repository.threadLocal.randomString;

  @observable
  bool largeScreen = false;

  // @observable
  // bool contentLoading = false;

  @observable
  bool entireLoading = false;
  // @observable
  // bool primaryViewLoading = false;
  // @observable
  // bool secondaryViewLoading = false;

  @observable
  Communities? selectedForum;

  @observable
  int bottomBarIndex = 0;

  // @observable
  // double panY = 30.0;

  // @observable
  // bool showSeekBar = false;

  @observable
  int currentContentIndex = 1;
  @observable
  int currentContentItemIndex = 1;
  // @observable
  // double onChangedContentIndex = 1;

  @observable
  String? deletedThreadTitle;
  @observable
  String? addForumName;

  // @observable
  // bool cancelInitialScroll = false;

  @computed
  bool get contentLoading => selectedForumState?.contentLoading ?? false;

  @computed
  int? get selectedForumIndex {
    final result = selectedForum != null
        ? selectedForumList?.indexOf(selectedForum!)
        : null;
    return result == -1 ? null : result;
  }

  @computed
  ThreadMarkData? get currentContentThreadData =>
      selectedForumState?.currentContentThreadData;

  @computed
  int? get currentContentLastReadAt => currentContentThreadData?.lastReadAt;

  @computed
  ContentState? get currentContentState =>
      selectedForumState?.currentContentState;

  @computed
  List<ThreadData?> get searchServerThreads =>
      selectedForumState?.search.searchThreadList ?? [];

  @computed
  bool get showHot =>
      selectedForum == Communities.fiveCh ||
      selectedForum == Communities.pinkCh;

  @computed
  int? get lastOpenedIndexForVisibleContent {
    return currentContentThreadData?.lastOpendIndex;
    // final current = lastOpenedIndex?.contents?.firstWhere(
    //     (element) => element?.id == currentContent?.id,
    //     orElse: () => null);
    // return current?.index;
  }

  @computed
  UserData? get userData => repository.user;

  @computed
  List<Communities>? get selectedForumList => userData?.forums;

  @computed
  LangList get getLocale => userData?.language ?? LangList.ja;

  @observable
  bool reverseForumSwitchAnimation = false;

  @observable
  bool reverseAnimationForPrymaryScreen = false;

  @computed
  List<String?> get fontsList {
    final list = GoogleFontsList().list;
    return [...?selectedForumState?.settings?.addedFonts, ...list];
  }

  // @computed
  // ContentMetaData? get visibleContent => selectedForumState?.visibleContent;

  // @computed
  // Communities? get selectedForum {
  //   if (selectedForumIndex == null) {
  //     return null;
  //   }
  //   final current = selectedForumList?.elementAtOrNull(selectedForumIndex!);
  //   if (current != null) {
  //     return current;
  //   } else {
  //     return selectedForumList?.firstOrNull;
  //   }
  // }

  @computed
  ForumState? get selectedForumState {
    switch (selectedForum) {
      case Communities.fiveCh:
        return fiveCh;
      case Communities.girlsCh:
        return girlsCh;
      case Communities.futabaCh:
        return futabaCh;
      case Communities.pinkCh:
        return pinkCh;
      default:
        return null;
    }
  }

  @computed
  ThemeList get selectedTheme =>
      selectedForumState?.selectedTheme ?? ThemeList.m3Purple;

  @computed
  ThreadsOrder get currentThreadsOrder =>
      selectedForumState?.settings?.threadsOrder ?? ThreadsOrder.newOrder;

  @computed
  PositionToGet get currentPositionToGet =>
      selectedForumState?.settings?.positionToGet ?? PositionToGet.first;

  @computed
  bool get blurThumbnail =>
      selectedForumState?.settings?.blurThumbnail ?? false;

  @computed
  ThreadContentData? get currentContent {
    // if (largeScreen) {
    //   return selectedForumState?.history.libraryContent;
    // }
    return selectedForumState?.currentContent;
  }

  @computed
  bool get currentMainThreadsLoading =>
      selectedForumState?.forumMain.threadsLoading ?? false;

  @computed
  bool get currentHistoryThreadsLoading =>
      selectedForumState?.history.threadsLoading ?? false;

  @computed
  bool get currentSearchThreadsLoading =>
      selectedForumState?.search.threadsLoading ?? false;

  @computed
  bool get currentSecondaryThreadsLoading =>
      switch (currentScreen) {
        BottomMenu.history => selectedForumState?.history.threadsLoading,
        BottomMenu.search => selectedForumState?.search.threadsLoading,
        BottomMenu.forums => false,
      } ??
      false;

  @computed
  String? get selectedFonts => selectedForumState?.selectedFonts;
  @computed
  List<ImportanceData?> get boardImportance =>
      selectedForumState?.settings?.boardImportanceList ?? [];

  @computed
  List<ImportanceData?> get threadsImportance =>
      selectedForumState?.settings?.threadsImportanceList ?? [];

  @computed
  List<GroupData?> get currentGroupList =>
      selectedForumState?.currentContentState?.groupList ?? [];

  @computed
  List<String?> get currentFavoritesBoards =>
      selectedForumState?.forumMain.favoritesBoards ?? [];

  @computed
  RetentionPeriodList get retentionPeriod =>
      selectedForumState?.retentionPeriod ?? RetentionPeriodList.oneDay;

  @computed
  bool get userFavoritesBoards =>
      selectedForumState?.forumMain.userFavoritesBoards ?? false;
  @computed
  bool get sortHistoryByRetention =>
      selectedForumState?.history.sortHistoryByRetention ?? false;
  @computed
  SortHistory get sortHistory =>
      selectedForumState?.history.sortHistory ?? SortHistory.history;
  // @computed
  // bool get viewByBoard => switch (currentScreen) {
  //       BottomMenu.history => selectedForumState?.history.viewByBoard ?? false,
  //       BottomMenu.search => selectedForumState?.search.viewByBoard ?? false,
  //       BottomMenu.forums => false
  //     };

  // @computed
  // bool get viewByBoardInFavorites =>
  //     selectedForumState?.favorite.viewByBoard ?? false;
  @computed
  bool get openLinkByWebView => selectedForumState?.settings?.openLink ?? false;

  // @computed
  // int get libraryIndex => switch (currentScreen) {
  //       BottomMenu.history => selectedForumState?.history.viewIndex ?? 0,
  //       BottomMenu.search => selectedForumState?.search.viewIndex ?? 0,
  //       BottomMenu.forums => 0
  //     };

  @computed
  Map<String, int> get historyDiff =>
      selectedForumState?.history.markListDiff ?? {};

  @computed
  String? get currentBoardUrl {
    final board = selectedForumState?.forumMain.board;
    switch (selectedForum) {
      case Communities.fiveCh:
        return board?.fiveCh?.url;
      case Communities.girlsCh:
        final data = board?.girlsCh?.url;
        return 'https://${GirlsChHandler.main}/$data';
      case Communities.futabaCh:
        final data = board?.futabaCh?.path;
        return 'https://$data/';
      case Communities.pinkCh:
        return board?.fiveCh?.url;
      default:
    }
    return null;
  }

  @computed
  String? get currentBoardId => selectedForumState?.forumMain.board?.id;

  // @computed
  // String? get boardNameForSecondaryNav =>
  //     selectedForumState?.boardNameForSecondaryNav;

  @computed
  Set<String?> get boardIdSetOfForLibrary => switch (currentScreen) {
        BottomMenu.history =>
          selectedForumState?.history.boardIdSetOfContentList ?? {},
        BottomMenu.search =>
          selectedForumState?.search.boardIdSetOfContentList ?? {},
        BottomMenu.forums => {}
      };

  @computed
  Map<ImportanceList, List<ImportanceData?>>
      get importanceMapDataForCurrentContent {
    Map<ImportanceList, List<ImportanceData?>> mapData = {};
    final data = currentContentThreadData?.importanceList;
    if (data == null) {
      return mapData;
    }
    for (final element in data) {
      if (element != null) {
        mapData[element.level] = [...?mapData[element.level], element];
      }
    }
    return mapData;
  }

  @computed
  Map<ImportanceList, List<ImportanceData?>>
      get importanceMapDataForCurrentBoard {
    Map<ImportanceList, List<ImportanceData?>> mapData = {};
    final data = boardImportance;
    // if (data == null) {
    //   return mapData;
    // }
    for (final element in data) {
      if (element != null) {
        mapData[element.level] = [...?mapData[element.level], element];
      }
    }
    return mapData;
  }

  @computed
  Map<ImportanceList, List<ImportanceData?>>
      get importanceMapDataForCurrentThreads {
    Map<ImportanceList, List<ImportanceData?>> mapData = {};
    final data = threadsImportance;
    // if (data == null) {
    //   return mapData;
    // }
    for (final element in data) {
      if (element != null) {
        mapData[element.level] = [...?mapData[element.level], element];
      }
    }
    return mapData;
  }

  @computed
  List<ThreadsOrder> get enabledOrder {
    switch (selectedForum) {
      case Communities.futabaCh:
        return ThreadsOrder.values
            .where((element) =>
                element == ThreadsOrder.catalog ||
                element == ThreadsOrder.newerThread ||
                element == ThreadsOrder.importance ||
                element == ThreadsOrder.resCountDesc)
            .toList();
      case Communities.girlsCh:
        return ThreadsOrder.values
            .where((element) =>
                element == ThreadsOrder.hot ||
                element == ThreadsOrder.newerResponce ||
                element == ThreadsOrder.importance ||
                element == ThreadsOrder.resCountDesc)
            .toList();
      default:
        return ThreadsOrder.values
            .where((element) =>
                element == ThreadsOrder.hot ||
                element == ThreadsOrder.newerThread ||
                element == ThreadsOrder.importance ||
                // element == ThreadsOrder.oldOrder ||
                element == ThreadsOrder.resCountDesc)
            .toList();
    }
  }

  @computed
  List<RetentionPeriodList> get selectableRetentionPeriod {
    switch (selectedForum) {
      case Communities.fiveCh:
        return RetentionPeriodList.values;
      case Communities.pinkCh:
        return RetentionPeriodList.values;
      default:
        return RetentionPeriodList.values
            .where((element) => element != RetentionPeriodList.byPostPace)
            .toList();
    }
  }

  @computed
  String? get boardIdForSearch {
    switch (selectedForum) {
      case Communities.futabaCh:
        return futabaCh.settings?.searchBoardIdForFutaba;
      default:
    }
    return null;
  }

  @computed
  Future<List<BoardData?>?> get boardListForSearch async {
    switch (selectedForum) {
      case Communities.futabaCh:
        final boards = futabaCh.forumMain.boards;
        if (boards.isNotEmpty) {
          return boards;
        } else {
          final boards = await FutabaChHandler.getBoards();
          return boards;
        }
      default:
    }
    return null;
  }

  @computed
  Future<BoardData?> get boardForSearch async {
    final boards = await boardListForSearch;
    if (boards == null || boards.isEmpty) return null;

    return boards.firstWhere((element) => element?.id == boardIdForSearch,
        orElse: () => null);
  }

  @computed
  ThreadContentData? get selectedHistoryData =>
      selectedForumState?.history.content?.content;
  // @computed
  // ThreadData? get selectedFavoriteData =>
  //     selectedForumState?.favorite.selectedContentData;

  @computed
  PrimaryViewState get selectedForumPrimaryBody =>
      selectedForumState?.forumMain.selectedPrimaryView ??
      PrimaryViewState.boards;

  // @computed
  // String? get historyAppBarTitle => selectedForumState?.history.appBarTitle;

  @computed
  BottomMenu get currentScreen => BottomMenu.values[bottomBarIndex];

  @computed
  List<bool> get secondaryBodyToggleValue {
    switch (bottomBarIndex) {
      case 1:
        return [true, false];
      case 2:
        return [false, true];
      // case 3:
      //   return [false, false, true];
      default:
        return [true, false];
    }
  }

  @computed
  String get secondaryAppBarTitle => currentContentThreadData?.title ?? '';
  // @computed
  // List<bool> get secondaryBodyToggleValue =>
  //     selectedForumState?.secondaryBodyToggleValue ?? [true, false, false];

  @computed
  PrimaryViewState get primaryHistoryView =>
      selectedForumState?.history.selectedPrimaryView ??
      PrimaryViewState.threads;

  @computed
  PrimaryViewState get primarySearchView =>
      selectedForumState?.search.primaryView ?? PrimaryViewState.threads;

  @computed
  PrimaryViewState? get prymaryViewState {
    switch (currentScreen) {
      case BottomMenu.forums:
        return selectedForumPrimaryBody;
      case BottomMenu.history:
        return largeScreen ? selectedForumPrimaryBody : primaryHistoryView;
      case BottomMenu.search:
        return largeScreen ? selectedForumPrimaryBody : primarySearchView;
      default:
        return PrimaryViewState.boards;
    }
  }

  @computed
  int? get currentContentDiff => selectedForumState?.currentContentDiff;

  @computed
  String get appBarTitle => selectedForumState?.appBarTitle ?? '';

  // @computed
  // List<ThreadBase?> get currentLibrary => switch (currentScreen) {
  //       BottomMenu.history => selectedForumState?.historyList ?? [],
  //       BottomMenu.search => selectedForumState?.searchList ?? [],
  //       BottomMenu.forums => const []
  //     };

  @computed
  List<ThreadBase?> get historyList => selectedForumState?.historyList ?? [];

  @computed
  Map<String, List<ThreadBase?>?> get listByBoardId => switch (currentScreen) {
        BottomMenu.history => currentHistoryList,
        BottomMenu.search => currentSearchList,
        BottomMenu.forums => {}
      };

  @computed
  Map<String, List<ThreadBase?>?> get currentHistoryList =>
      selectedForumState?.history.markListByBoardId ?? {};

  @computed
  Map<String, List<ThreadBase?>?> get currentSearchList =>
      selectedForumState?.search.searchListByBoardId ?? {};

  @computed
  List<ThreadBase?> get searchList => selectedForumState?.searchList ?? [];

  void setCurrentContentIndex(final int index) {
    currentContentState?.setCurrentContentIndex(index);
  }

  // @computed
  // String? get selectedBoardName => switch (currentScreen) {
  //       BottomMenu.history => selectedForumState?.history.selectedBoardName,
  //       BottomMenu.search => selectedForumState?.search.selectedBoardName,
  //       BottomMenu.forums => null,
  //     };

  String? boardNameById(final String id) => switch (selectedForum) {
        Communities.fiveCh => FiveChBoardNames.getById(id),
        Communities.girlsCh => GirlsChBoardNames.getById(id),
        Communities.futabaCh => FutabaChBoardNames.getById(id),
        Communities.pinkCh => FiveChBoardNames.getById(id),
        null => null
      };

  // @computed
  // Future<String?> get selectedBoardNameFavorite async {
  //   return await selectedForumState?.favorite.selectedBoardName;
  // }

  @computed
  List<String?> get searchWords =>
      selectedForumState?.settings?.searchWordList ?? [];

  @computed
  PrimaryViewState get searchViewState =>
      selectedForumState?.search.primaryView ?? PrimaryViewState.threads;

  Future<void> setPrimaryView(final PrimaryViewState value) async =>
      await selectedForumState?.forumMain.setPrimaryView(value);

  Future<void> setPrimarySearchViewState(final PrimaryViewState value) async =>
      await selectedForumState?.search.setPrimaryView(value);

  Future<void> setPrimaryLibraryView(final PrimaryViewState value) async =>
      await selectedForumState?.history.setPrimaryView(value);

  void setLastThreadsScrollOffset(final BottomMenu screen, final double value) {
    selectedForumState?.setLastThreadsScrollOffset(screen, value);
  }

  // Future<void> saveLastIndexBeforeSetContent() async {
  //   if (currentContentState == null) return;
  //   await setLastOpenedContentIndexById(
  //       currentContentState!.currentContentIndex,
  //       type: currentContentState!.content.type,
  //       threadId: currentContentState!.content.id,
  //       boardId: currentContentState!.content.boardId);
  // }

  @action
  void setLog(final String value) {
    debugLog.add(value);
  }

  Future<bool> setContent(final String id,
      {required final ThreadBase thread}) async {
    // toggleContentLoading();
    if (largeScreen) {
      await _updateLastOpenedIndexWhenScreenTransition();
    }
    final result = await selectedForumState?.setContent(id, thread: thread);
    // toggleContentLoading();
    return result ?? false;
  }

  // Future<bool> setVisibleContentForSecondry(final String id,
  //     {required final ThreadBase thread}) async {
  //   toggleContentLoading();
  //   // setLastReIndex(null);
  //   try {
  //     await _updateLastOpenedIndexWhenScreenTransition();
  //     final result = await selectedForumState?.setVisibleContentForSecondry(id,
  //         thread: thread);
  //     setLog('setVisibleContentForSecondry: id:$id, thread: ${thread.url}');
  //     toggleContentLoading();
  //     return result ?? false;
  //   } catch (e) {
  //     setLog(e.toString());
  //   }
  //   return false;
  // }

  List<int?>? setFilterWordForContent(final String value) =>
      selectedForumState?.currentContentState?.filterdIndexList(value);

  @action
  void setLaunchStatus(final LaunchStatus value) => launchStatus = value;

  Future<int?> getThreadDiffById(final String value,
          {final bool onLibraryView = false}) async =>
      await selectedForumState?.getThreadDiffById(value,
          onLibraryView: onLibraryView);

  // Future<bool> existThreadFromStrorage(
  //         final String threadId, final String boardId) async =>
  //     await selectedForumState?.existThreadFromStrorage(threadId, boardId) ??
  //     false;
  Future<void> post(final PostData value) async {
    final result = await selectedForumState?.postComment(value);
    if (result != null && result) {
      await updateContent();
    }
  }

  Future<void> updateContent() async {
    if (currentContent == null) return;
    toggleContentLoading();
    await selectedForumState?.updateContent();
    toggleContentLoading();
  }

  Future<void> updatePositionToGet(final PositionToGet value) async {
    toggleEntireLoading();
    await selectedForumState?.updatePositionToGet(value);
    toggleEntireLoading();
  }

  Future<bool> getDataByUrl(final String? value,
      {final bool setContent = true}) async {
    if (value == null) return false;
    toggleContentLoading();
    final result =
        await selectedForumState?.getDataByUrl(value, setContent: setContent);
    toggleContentLoading();
    return result ?? false;
  }

  Future<void> updateMark(final ResMarkData value) async {
    toggleEntireLoading();
    await selectedForumState?.updateMark(value);
    toggleEntireLoading();
  }

  Future<void> deleteMark(final ContentData value) async {
    toggleEntireLoading();
    await selectedForumState?.deleteMark(value);
    toggleEntireLoading();
  }

  Future<void> updateImportance(final ImportanceData value) async {
    toggleEntireLoading();
    await selectedForumState?.updateImportance(value);
    toggleEntireLoading();
  }

  Future<void> deleteImportance(final ImportanceData value) async {
    toggleEntireLoading();
    await selectedForumState?.deleteImportance(value);
    toggleEntireLoading();
  }

  ImportanceData? getImportanceByContent(final ContentData value) {
    final byPostId = _getImportanceByPostId(value.getPostId);
    final byUserId = _getImportanceByUserId(value.getUserId);
    final byUserName = _getImportanceByUserName(value.getUserName);
    final byBody = _getImportanceByBody(value.body);
    return byPostId ?? byUserId ?? byUserName ?? byBody;
  }

  ImportanceData? _getImportanceByPostId(final String? postId) {
    if (postId == null) return null;
    return selectedForumState?.getImportanceByPostId(postId);
  }

  ImportanceData? _getImportanceByUserId(final String? userId) {
    if (userId == null) return null;
    return selectedForumState?.getImportanceByUserId(userId);
  }

  ImportanceData? _getImportanceByUserName(final String? userName) {
    if (userName == null) return null;
    return selectedForumState?.getImportanceByUserName(userName);
  }

  ImportanceData? _getImportanceByBody(final String? body) {
    if (body == null) return null;
    return selectedForumState?.getImportanceByBody(body);
  }

  bool byNotCaseSensitive(final String value, final String? value2) {
    return value.toLowerCase().contains(value.toLowerCase());
  }

  ImportanceData? getImportanceByTitle(final String? title) {
    if (title == null) return null;
    final exist = boardImportance.firstWhere(
        (element) =>
            element != null &&
            element.target == ImportanceTarget.title &&
            title.toLowerCase().contains(element.strValue.toLowerCase()),
        orElse: () => null);
    return exist;
  }

  // @action
  // void toggleContentLoading() => contentLoading = !contentLoading;
  @action
  void toggleEntireLoading() => entireLoading = !entireLoading;
  // @action
  // void togglePrimaryViewLoading() => primaryViewLoading = !primaryViewLoading;
  // @action
  // void toggleSecondaryViewLoading() =>
  //     secondaryViewLoading = !secondaryViewLoading;

  void toggleContentLoading() {
    selectedForumState?.toggleContentLoading();
  }

  void toggleMainThreadsLoading() {
    selectedForumState?.forumMain.toggleThreadsLoading();
  }

  void toggleSearchThreadsLoading() {
    selectedForumState?.search.toggleThreadsLoading();
  }

  void toggleSecondaryThreadsLoading() {
    switch (currentScreen) {
      case BottomMenu.history:
        selectedForumState?.history.toggleThreadsLoading();
        break;
      case BottomMenu.search:
        selectedForumState?.search.toggleThreadsLoading();
      default:
    }
  }

  @action
  Future<void> init() async {
    // toggleLoading();
    setLaunchStatus(LaunchStatus.loading);
    await repository.init();
    // await repository.loadInitialData();
    initialLocaleLoad();

    setLaunchStatus(LaunchStatus.start);

    // logger.d('initStore: 2');
    // toggleLoading();
  }

  Future<void> loadInitialData() async {
    await repository.loadInitialData();
    _setInitialForum();
    initWhenLargeScreen();
  }

  Future<void> sendAgree(final ContentData value,
      {final bool good = true}) async {
    await selectedForumState?.sendAgree(value, good: good);
  }

  void initWhenLargeScreen() {
    if (largeScreen && selectedForumList != null) {
      for (final i in selectedForumList!) {
        switch (i) {
          case Communities.fiveCh:
            // if (fiveCh.currentLibrary.isNotEmpty) {
            //   // fiveCh.history
            //   //     .setContentIdByData(fiveCh.currentLibrary.firstOrNull);
            // }
            break;
          case Communities.girlsCh:
            // if (girlsCh.currentLibrary.isNotEmpty) {
            //   // girlsCh.history
            //   //     .setContentIdByData(girlsCh.currentLibrary.firstOrNull);
            // }
            break;
          case Communities.futabaCh:
            // if (futabaCh.currentLibrary.isNotEmpty) {
            //   // futabaCh.history
            //   //     .setContentIdByData(futabaCh.currentLibrary.firstOrNull);
            // }
            break;
          default:
        }
      }
    }
  }

  void _setInitialForum() {
    if (userData?.lastOpenedForum != null && selectedForumList != null) {
      final index = selectedForumList!.indexOf(userData!.lastOpenedForum);
      if (index == -1) {
        setSelectedForum(0);
      } else {
        setSelectedForum(index);
      }
    }
  }

  Future<void> updateForumSettings() async =>
      await repository.updateForumSettings();

  @action
  void setSelectedForum(final int value) {
    if (selectedForumList == null) return;
    final selected = selectedForumList?[value];
    if (selected == null) return;
    final newIndex = selectedForumList!.indexOf(selected);
    if (newIndex == -1) return;
    _updateLastOpenedIndexWhenScreenTransition();

    reverseForumSwitchAnimation = newIndex < (selectedForumIndex ?? 0);
    selectedForum = selected;
  }

  // @action
  // void setForumIndex(final int value) {
  //   _updateLastOpenedIndexWhenScreenTransition();

  //   reverseForumSwitchAnimation = value < (selectedForumIndex ?? 0);
  //   selectedForumIndex = value;
  // }

  // @action
  void setBottomIndex(final int value) {
    if (value == bottomBarIndex) return;
    selectedForumState?.clearHoverdItem();
    if (largeScreen) {
      _setBottomIndex(value);
    } else {
      _updateLastOpenedIndexWhenScreenTransition();
      _setBottomIndex(value);
    }
  }

  @action
  void _setBottomIndex(final int value) {
    reverseAnimationForPrymaryScreen = bottomBarIndex > value;
    bottomBarIndex = value;
  }

  Future<void> _updateLastOpenedIndexWhenScreenTransition() async {
    final contentState = currentContentState;
    final content = contentState?.content;
    final currentIndex = contentState?.currentContentIndex;
    if (content != null) {
      await setLastOpenedContentIndexById(currentIndex,
          type: currentContentState!.content.type,
          threadId: currentContentState!.content.id,
          boardId: currentContentState!.content.boardId);
    }
  }

  Future<void> updateLastOpenedIndexWhenDetached() async {
    await _updateLastOpenedIndexWhenScreenTransition();
  }

  // void setLibraryItemIndex(
  //   final int index,
  // ) {
  //   switch (currentScreen) {
  //     case BottomMenu.history:
  //       selectedForumState?.history.setViewIndex(index);
  //       break;
  //     case BottomMenu.search:
  //       selectedForumState?.search.setViewIndex(index);
  //       break;
  //     default:
  //   }
  // }

  // @action

  @action
  void setScreenSize(final bool value) {
    largeScreen = value;
    if (largeScreen) {
      fiveCh.disposeNonLargeContent();
      girlsCh.disposeNonLargeContent();
      futabaCh.disposeNonLargeContent();
      pinkCh.disposeNonLargeContent();
      if (bottomBarIndex == 0) {
        setBottomIndex(1);
      }
    }
  }

  Future<void> deleteThreadMarkData(final ThreadMarkData value) async {
    // selectedForumState?.history.deleteData(value);
    if (selectedForumState?.type == value.type) {
      await repository.deleteThread(value);
      if (!largeScreen &&
          selectedForumPrimaryBody == PrimaryViewState.content) {
        if (currentScreen != BottomMenu.forums) {
          setPrimaryView(PrimaryViewState.threads);
        } else {
          if (selectedForumState?.forumMain.board != null) {
            setPrimaryView(PrimaryViewState.threads);
          } else {
            setPrimaryView(PrimaryViewState.boards);
          }
        }
      }
    }
  }

  Future<void> updateRetentionPeriod(
      final ThreadMarkData thread, final RetentionPeriodList value) async {
    final current = thread.retentionPeriodSeconds;
    final add = Duration(days: value.days);
    final newValue = current + add.inMilliseconds;
    final newData = thread.copyWith(retentionPeriodSeconds: newValue);
    await repository.updateThreadMark(newData);
  }

  Future<DateTime?> getExpiryTime(final String id) async {
    // final expiryTime = await selectedForumState?.storage.getExpiryTime(id);
    // return expiryTime;
    return null;
  }

  // void setIsWeb(final bool value) => isWeb = value;
  // void setIsDebug(final bool value) => isDebugMode = value;

  Future<void> clearAllCache() async {
    // await userStorage.clearAll();
    // await fiveCh.storage.clearAll();
    // await girlsCh.storage.clearAll();
    // await futabaCh.storage.clearAll();
  }

  // Future<void> deleteCacheByDataId(final String id) async {
  //   await selectedForumState?.deleteCache(id);
  // }

  // @action
  // void deleteDataById(final String id) {
  //   logList.removeWhere((element) => element?.id == id);
  // }

  Future<(String?, String?, String?)?> fetch(final String url) async {
    return await FetchData.fetch(url);
  }

  Future<void> updateAddedFont(final String value) async {
    final settings = selectedForumState?.settings;
    if (settings == null) return;
    final current = [...settings.addedFonts];
    current.removeWhere((element) => element == value);
    current.insert(0, value);
    final newData = settings.copyWith(addedFonts: current);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  Future<void> removeAddedFont(final String value) async {
    final settings = selectedForumState?.settings;
    if (settings == null) return;
    final current = [...settings.addedFonts];
    current.removeWhere((element) => element == value);
    final newData = settings.copyWith(addedFonts: current);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  Future<void> removeAddedFontAndSetDefaultFont(final String value) async {
    await setSelectedFont(null);
    await removeAddedFont(value);
  }

  Future<void> updateForumImportance(
      final ImportanceData value, final bool isBoard) async {
    final settings = selectedForumState?.settings;
    if (settings == null) return;
    final current = isBoard
        ? [...settings.boardImportanceList]
        : [...settings.threadsImportanceList];
    current.removeWhere((element) => element?.id == value.id);
    current.insert(0, value);
    final strList = current.map((e) => jsonEncode(e?.toJson())).toList();
    final newData = isBoard
        ? settings.copyWith(boardImportance: strList)
        : settings.copyWith(threadsImportance: strList);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  Future<void> deleteForumImportance(
      final ImportanceData value, final bool isBoard) async {
    final settings = selectedForumState?.settings;
    if (settings == null) return;
    final current = isBoard
        ? [...settings.boardImportanceList]
        : [...settings.threadsImportanceList];
    current.removeWhere((element) => element?.id == value.id);
    // current.insert(0, value);
    final strList = current.map((e) => jsonEncode(e?.toJson())).toList();
    final newData = isBoard
        ? settings.copyWith(boardImportance: strList)
        : settings.copyWith(threadsImportance: strList);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }
  // Future<void> deleteSelectedData()

  Future<void> setLastOpenedContentIndexById(final int? index,
      {required final Communities type,
      required final String threadId,
      required final String boardId}) async {
    if (index == null) return;
    ThreadMarkData? mark;
    switch (type) {
      case Communities.fiveCh:
        mark = fiveCh.history.markList.firstWhere(
          (element) => element?.id == threadId && element?.boardId == boardId,
          orElse: () => null,
        );
        break;
      case Communities.girlsCh:
        mark = girlsCh.history.markList.firstWhere(
            (element) => element?.id == threadId && element?.boardId == boardId,
            orElse: () => null);
        break;
      case Communities.futabaCh:
        mark = futabaCh.history.markList.firstWhere(
            (element) => element?.id == threadId && element?.boardId == boardId,
            orElse: () => null);
        break;
      case Communities.pinkCh:
        mark = pinkCh.history.markList.firstWhere(
            (element) => element?.id == threadId && element?.boardId == boardId,
            orElse: () => null);
        break;
      default:
    }
    if (mark == null) return;
    if (mark.lastOpendIndex == index) return;
    final newData = mark.copyWith(
        lastOpendIndex: index,
        lastReadAt: DateTime.now().millisecondsSinceEpoch);
    await repository.updateThreadMark(newData);
  }

  Future<void> setSelectedFont(final String? value) async {
    final settings = selectedForumState?.settings;
    if (settings == null) return;
    if (settings.googleFonts == value) return;
    final newData = settings.copyWith(googleFonts: value);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  Future<void> setLastOpenedForum() async {
    final selected = selectedForum;
    if (selected == null) {
      throw 'setLastOpenedForum selected == null';
    }
    if (userData == null) {
      throw 'setLastOpenedForum userData == null';
    }
    final newData = userData!.copyWith(lastOpenedForum: selected);
    await repository.updateUserData(newData);
    // await userStorage.setLastOpenedForum(selected);
  }

  Future<void> setLang(final LangList value) async {
    // final selected = selectedForum;
    // if (selected == null) {
    //   throw 'setLastOpenedForum selected == null';
    // }
    if (userData == null) {
      throw 'setLastOpenedForum userData == null';
    }
    if (userData!.language == value) return;
    final newData = userData!.copyWith(language: value);
    await repository.updateUserData(newData);
    // await userStorage.setLastOpenedForum(selected);
  }

  void setNewTheme(final ThemeList value) {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.theme == value) return;
    final newData = settnigs.copyWith(theme: value);
    selectedForumState?.setSettings(newData);
  }

  void setPositionToGet(final PositionToGet value) {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.positionToGet == value) return;
    final newData = settnigs.copyWith(positionToGet: value);
    selectedForumState?.setSettings(newData);
    // await repository.server.forumState.setPositionToGet(value);

    // await userStorage.setPositionToGet(selected, value);
  }

  void setBlurThumbnail(final bool value) {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.blurThumbnail == value) return;
    final newData = settnigs.copyWith(blurThumbnail: value);
    selectedForumState?.setSettings(newData);
    // await repository.server.forumState.setPositionToGet(value);

    // await userStorage.setPositionToGet(selected, value);
  }

  Future<void> setThreadsOrder(final ThreadsOrder value) async {
    final current = selectedForumState?.settings;
    if (current == null) return;
    final newData = current.copyWith(threadsOrder: value);
    selectedForumState?.setSettings(newData);
  }

  Future<void> setRetantionPeriod(final RetentionPeriodList value) async {
    // await userStorage.setRetantionPeriod(value);
    final current = selectedForumState?.settings;
    if (current == null) return;
    final newData = current.copyWith(retentionPeriod: value);
    selectedForumState?.setSettings(newData);
  }

  // Future<bool> postComment(final CommentData value) async {
  //   return await selectedForumState?.postComment(value) ?? false;
  // }

  Future<Uint8List?> getFavicon(final String uri) async {
    return await FetchData.getFavicon(uri);
  }

  Future<Uint8List?> getMediaData(final String url) async {
    final cache = await _getMediaFromCache(url);
    if (cache != null) {
      logger.i('get media from cache: $url');
      return cache;
    }
    final data = await FetchData.getMediaData(url);
    if (data == null) return null;
    logger.i('get media from network: $url');
    final currentThread = currentContentThreadData;
    await repository.mediaLocal
        .putMediaData(currentThread?.documentId, url: url, data: data);
    return data;
  }

  Future<Uint8List?> _getMediaFromCache(final String url) async {
    return await repository.mediaLocal.getDataByUrl(url);
  }

  // Future<Uint8List> getFavicon(final String value) async {
  //   return await repository.server.getFavicon(value);
  // }

  Future<void> setUseFavoritesBoards(final bool value) async {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.useFavoritesBoards == value) return;
    final newData = settnigs.copyWith(useFavoritesBoards: value);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  Future<void> setSortHistoryByExpire(final bool value) async {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.sortHistoryByRetention == value) return;
    final newData = settnigs.copyWith(sortHistoryByRetention: value);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  Future<void> setSortHistory(final SortHistory value) async {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.sortHistory == value) return;
    final newData = settnigs.copyWith(sortHistory: value);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  // await userStorage.setSortHistoryByExpire(value);
  // Future<void> setViewByBoardInHistory(final bool value) async {
  //   final settnigs = selectedForumState?.settings;
  //   if (settnigs == null) return;
  //   if (settnigs.viewByBoardInHistory == value) return;
  //   final newData = settnigs.copyWith(viewByBoardInHistory: value);
  //   selectedForumState?.setSettings(newData);
  //   await repository.server.forumState.update();
  // }

  // Future<void> setViewByBoardInSearch(final bool value) async {
  //   final settnigs = selectedForumState?.settings;
  //   if (settnigs == null) return;
  //   if (settnigs.viewByBoardInSearch == value) return;
  //   final newData = settnigs.copyWith(viewByBoardInSearch: value);
  //   selectedForumState?.setSettings(newData);
  //   await repository.server.forumState.update();
  // }

  // await userStorage.setViewByBoardInHistory(value);
  Future<void> setOpenLink(final bool value) async {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.openLink == value) return;
    final newData = settnigs.copyWith(openLink: value);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  Future<void> setDeleteKeyFotFutaba() async {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    final newPass = randomInt(count: 9999);
    final newData = settnigs.copyWith(deleteKeyForFutaba: newPass.toString());
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }
  // await userStorage.setOpenLink(value);

  Future<void> setFavoritesBoards(final List<String?> value) async {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    final newData = settnigs.copyWith(favoritesBoardList: value);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  Future<void> removeSearchWord(final String value) async {
    final settings = selectedForumState?.settings;
    if (settings == null) return;
    final list = [...settings.searchWordList];
    list.removeWhere((element) => element == value);
    final newData = settings.copyWith(searchWordList: list);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  void toggleHistoryThreadsLoading() =>
      selectedForumState?.history.toggleThreadsLoading();

  Future<void> updateLibrary() async {
    toggleHistoryThreadsLoading();
    await selectedForumState?.history.updateAllList();
    toggleHistoryThreadsLoading();
  }

  // Future<void> updateLibraryByBoard() async {
  //   await selectedForumState?.history.updateLibraryList();
  //   // switch (library) {
  //   //   case LibraryType.history:
  //   //     await selectedForumState?.history.updateLibraryList();
  //   //     break;
  //   //   case LibraryType.favorite:
  //   //     await selectedForumState?.favorite.updateLibraryList();
  //   //     break;
  //   //   default:
  //   // }
  // }

  // @computed
  // double get onChangedIndex{

  // }

  Future<void> searchThreadsFromServer(final String keyword) async {
    await selectedForumState?.search.searchServerThreads(keyword);
    // switch (current) {
    //   case Communities.fiveCh:
    //     await fiveCh.search.searchServerThreads<FiveChThreadTitleData>(keyword);
    //     break;
    //   case Communities.girlsCh:
    //     await girlsCh.search.searchServerThreads(keyword);
    //     break;
    //   default:
    // }
    if (selectedForumState != null) {
      await updateForumSettings();
      // await repository.server.forumState.update();
    }
  }

  Future<void> setSearchBoardId(final String id) async {
    final current = selectedForumState?.settings;
    if (current == null) return;
    switch (selectedForumState?.type) {
      case Communities.futabaCh:
        final newData = current.copyWith(searchBoardIdForFutaba: id);
        futabaCh.setSettings(newData);
        break;
      default:
    }
    await updateForumSettings();
    // await repository.server.forumState.update();
  }

  @action
  void setDeletedThreadTitle(final String value) => deletedThreadTitle = value;

  @action
  void removeDeletedThreadTitle() => deletedThreadTitle = null;

  @action
  void setAddForumName(final Communities value) => addForumName = value.label;

  @action
  void removeAddForumName() => addForumName = null;

  Future<void> clearThreads() async {
    await selectedForumState?.history.clearAllThreads();
  }

  Future<void> clearThreadsByBoard(final String boardId) async {
    selectedForumState?.history.toggleThreadsLoading();
    await selectedForumState?.history.clearThreadsByBoard(boardId);
    selectedForumState?.history.toggleThreadsLoading();
  }

  Future<void> removeUserData() async {
    await repository.removeUserData();
  }

  Future<void> addForum(final Communities value) async {
    await repository.addForum(value);
  }

  Future<void> removeForum(final Communities value) async {
    await repository.removeForum(value);
  }

  Future<void> getThreadsByJson() async {
    // FutabaChHandler.getThreadsByJson();
  }

  String? parsedUrl(final String url) {
    switch (selectedForum) {
      case Communities.fiveCh:
        return FiveChParser.toDatUrl(url);
      case Communities.pinkCh:
        return FiveChParser.toDatUrl(url);
      default:
        return url;
    }
  }

  Future<bool> postThread({
    required final PostData data,
  }) async {
    return await selectedForumState?.forumMain.postThread(data: data) ?? false;
  }

  Future<bool> deleteRes(final ContentData value) async {
    toggleContentLoading();
    final result = await selectedForumState?.deleteRes(value) ?? false;
    if (result) {
      await selectedForumState?.updateContent();
    }

    toggleContentLoading();
    return result;
  }
}
