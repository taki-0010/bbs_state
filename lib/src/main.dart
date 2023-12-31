// import 'dart:typed_data';

// import 'dart:math';
// import 'dart:convert';
// import 'dart:html';
import 'dart:typed_data';

import 'importer.dart';

part 'main.g.dart';

class MainStore = MainStoreBase with _$MainStore;

abstract class MainStoreBase with Store, WithDateTime {
  // late final userStorage = UserStorageState(parent: this);
  late final repository = RepositoryState(parent: this);
  // late final server = AppwriteState(parent: this);

  @observable
  ObservableList<ForumState?> forums = ObservableList<ForumState?>();

  // late final fiveCh = ForumState(parent: this, type: Communities.fiveCh);
  // late final girlsCh = ForumState(parent: this, type: Communities.girlsCh);
  // late final futabaCh = ForumState(parent: this, type: Communities.futabaCh);
  // late final pinkCh = ForumState(parent: this, type: Communities.pinkCh);
  // late final machi = ForumState(parent: this, type: Communities.machi);
  // late final shitaraba = ForumState(parent: this, type: Communities.shitaraba);
  // late final open2ch = ForumState(parent: this, type: Communities.open2Ch);
  // late final chan4 = ForumState(parent: this, type: Communities.chan4);
  // late final hatena = ForumState(parent: this, type: Communities.hatena);
  // late final mal = ForumState(parent: this, type: Communities.mal);
  // late final youtube = ForumState(parent: this, type: Communities.youtube);

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

  @observable
  PlayerState? player;

  @action
  void setPlayer(final LinkData? value) {
    if (value != null) {
      player = PlayerState(data: value);
    } else {
      player = null;
    }
  }

  @observable
  bool enableAd = true;

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

  @observable
  bool onOpenedPopup = false;

  @observable
  bool openedDrawer = false;
  @observable
  bool openedDialog = false;

  @computed
  bool? get getYtChannelOrPlayList =>
      selectedForumState?.forumMain.getYtChannelOrPlayList;

  @computed
  bool get openedMenu => onOpenedPopup || openedDrawer || openedDialog;

  @computed
  bool get disableSearch => selectedForum == Communities.shitaraba;

  @computed
  String? get snackMessage =>
      deletedThreadTitle ?? addForumName ?? selectedForumState?.errorMessage;

  @computed
  AutoDownloadableSizeLimit get autoDownloadableSizeLimit =>
      selectedForumState?.settings?.autoDownloadableSizeLimit ??
      AutoDownloadableSizeLimit.noLimit;

  // @observable
  // bool cancelInitialScroll = false;

  @computed
  bool get showHistoryUpdateButton {
    return selectedForumState?.showUpdateHistoryButton ?? true;
  }

  @computed
  bool get insertAd => (Platform.isIOS || Platform.isAndroid) && enableAd;

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
      selectedForum == Communities.machi ||
      selectedForum == Communities.shitaraba ||
      selectedForum == Communities.open2Ch ||
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
  Map<String, List<String?>> get favoritesBoards {
    Map<String, List<String?>> result = {};
    if (selectedForumList == null) return result;
    for (final i in selectedForumList!) {
      final favBoards = _selectedForum(i)?.settings?.favoritesBoardList;
      result[i.name] = favBoards ?? [];
    }
    return result;
  }

  @computed
  UserData? get userData => repository.user;

  @computed
  List<Communities>? get selectedForumList => userData?.forums;

  @computed
  List<String>? get selectedForumHostList =>
      userData?.forums.map((e) => e.host).toList();

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

  @computed
  ForumState? get selectedForumState {
    return _selectedForum(selectedForum);
    // switch (selectedForum) {
    //   case Communities.fiveCh:
    //     return fiveCh;
    //   case Communities.girlsCh:
    //     return girlsCh;
    //   case Communities.futabaCh:
    //     return futabaCh;
    //   case Communities.pinkCh:
    //     return pinkCh;
    //   case Communities.machi:
    //     return machi;
    //   case Communities.shitaraba:
    //     return shitaraba;
    //   case Communities.open2Ch:
    //     return open2ch;
    //   default:
    //     return null;
    // }
  }

  @computed
  ThemeList get selectedTheme =>
      selectedForumState?.selectedTheme ?? ThemeList.m3Purple;

  @computed
  ThreadsOrderType get currentThreadsOrder =>
      selectedForumState?.settings?.threadsOrderType ??
      ThreadsOrderType.importance;

  @computed
  TimeagoList get currentTimeago =>
      selectedForumState?.settings?.timeago ?? TimeagoList.enable;

  @computed
  ListViewStyle get currentViewStyle =>
      selectedForumState?.selectedListViewStyle ?? ListViewStyle.list;

  @computed
  AutoDownloadableSizeLimit get currentAutoDLSizeLimit =>
      selectedForumState?.settings?.autoDownloadableSizeLimit ??
      AutoDownloadableSizeLimit.noLimit;

  @computed
  MovedToLastThreads get currentMovedToLastThread =>
      selectedForumState?.settings?.movedToLastThreads ??
      MovedToLastThreads.none;

  // @computed
  // PositionToGet get currentPositionToGet =>
  //     selectedForumState?.settings?.positionToGet ?? PositionToGet.first;

  @computed
  bool get blurThumbnail =>
      selectedForumState?.settings?.blurThumbnail ?? false;

  @computed
  bool get enableNsfw => selectedForumState?.settings?.nsfw ?? false;

  @computed
  bool get saveLastUsedName =>
      selectedForumState?.settings?.saveLastUsedName ?? false;

  @computed
  bool get saveLastUsedEmail =>
      selectedForumState?.settings?.saveLastUsedEmail ?? false;

  @computed
  bool get saveLastUsedSubject =>
      selectedForumState?.settings?.saveLastUsedSubject ?? false;

  @computed
  String? get lastUsedName => selectedForumState?.settings?.lastUsedName;
  @computed
  String? get lastUsedEmail => selectedForumState?.settings?.lastUsedEmail;
  @computed
  String? get lastUsedSubject => selectedForumState?.settings?.lastUsedSubject;

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
  // @computed
  // List<ImportanceData?> get boardImportance =>
  //     selectedForumState?.settings?.boardImportanceList ?? [];

  // @computed
  // List<ImportanceData?> get threadsImportance =>
  //     selectedForumState?.settings?.threadsImportanceList ?? [];

  @computed
  List<ImportanceData?> get currentForumVeryImpList =>
      selectedForumState?.forumVeryImList ?? [];
  @computed
  List<ImportanceData?> get currentForumImpList =>
      selectedForumState?.forumImList ?? [];
  @computed
  List<ImportanceData?> get currentForumUnimpList =>
      selectedForumState?.forumUnimList ?? [];
  @computed
  List<ImportanceData?> get currentForumVeryUnimpList =>
      selectedForumState?.forumVeryUnimList ?? [];

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
  // @computed
  // bool get sortHistoryByRetention =>
  //     selectedForumState?.history.sortHistoryByRetention ?? false;
  @computed
  SortHistoryList get sortHistory =>
      selectedForumState?.history.sortHistory ?? SortHistoryList.boards;

  @computed
  TemplateData? get templateData => selectedForumState?.template;
  // @computed
  // bool get viewByBoard => switch (currentScreen) {
  //       BottomMenu.history => selectedForumState?.history.viewByBoard ?? false,
  //       BottomMenu.search => selectedForumState?.search.viewByBoard ?? false,
  //       BottomMenu.forums => false
  //     };

  // @computed
  // bool get viewByBoardInFavorites =>
  //     selectedForumState?.favorite.viewByBoard ?? false;
  // @computed
  // bool get openLinkByWebView => selectedForumState?.settings?.openLink ?? false;

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
      case Communities.youtube:
        if (board is YoutubeBoardData) {
          return board.boardUri.toString();
        }
      case Communities.mal:
        if (board is MalBoardData) {
          return board.boardUri.toString();
        }
      case Communities.hatena:
        if (board is HatenaBoardData) {
          return HatenaData.boardUri(board.id).toString();
        }
      case Communities.chan4:
        if (board is Chan4BoardData) {
          return board.currentBoardUri.toString();
        }
      case Communities.fiveCh || Communities.pinkCh:
        return board is FiveChBoardData ? board.url : null;
      case Communities.girlsCh:
        final data = board is GirlsChCategory ? board.url : null;
        if (data != null) {
          return Uri.https(GirlsChData.host, data).toString();
        }
      case Communities.futabaCh:
        final data = board is FutabaChBoard ? board.path : null;
        if (data != null) {
          return 'https://$data/';
        }

      // case Communities.pinkCh:
      //   return board?.fiveCh?.url;
      case Communities.machi:
        return Uri.https('${selectedForum?.host}', '${board?.id}').toString();
      case Communities.shitaraba:
        final category = board is ShitarabaBoardData ? board.category : null;
        if (category != null) {
          return Uri.https('${ShitarabaData.sub}.${ShitarabaData.host}',
                  '$category/${board?.id}')
              .toString();
        }

      case Communities.open2Ch:
        final directoryName =
            board is FiveChBoardData ? board.directoryName : null;
        if (directoryName != null) {
          return Uri.https(
                  '$directoryName.${Communities.open2Ch.host}', '${board?.id}')
              .toString();
        }

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

  // @computed
  // Map<ImportanceList, List<ImportanceData?>>
  //     get importanceMapDataForCurrentBoard {
  //   Map<ImportanceList, List<ImportanceData?>> mapData = {};

  //   final data = selectedForumState?.titleImportanceList ?? [];
  //   for (final element in data) {
  //     if (element != null) {
  //       mapData[element.level] = [...?mapData[element.level], element];
  //     }
  //   }
  //   return mapData;
  // }

  // @computed
  // Map<ImportanceList, List<ImportanceData?>>
  //     get importanceMapDataForCurrentThreads {
  //   Map<ImportanceList, List<ImportanceData?>> mapData = {};
  //   final postId = selectedForumState?.postIdImportanceList;
  //   final userId = selectedForumState?.userIdImportanceList;
  //   final userName = selectedForumState?.nameImportanceList;
  //   final body = selectedForumState?.bodyImportanceList;
  //   final data = [...?postId, ...?userId, ...?userName, ...?body];

  //   for (final element in data) {
  //     if (element != null) {
  //       mapData[element.level] = [...?mapData[element.level], element];
  //     }
  //   }
  //   return mapData;
  // }

  @computed
  List<ThreadsOrderType> get enabledOrder {
    final list = ThreadsOrderType.values;
    switch (selectedForum) {
      case Communities.hatena:
        return list
            .where((element) =>
                element == ThreadsOrderType.hot ||
                element == ThreadsOrderType.resCountDesc ||
                element == ThreadsOrderType.importance)
            .toList();
      case Communities.futabaCh:
        return list
            .where((element) =>
                element == ThreadsOrderType.catalog ||
                element == ThreadsOrderType.newerThread ||
                element == ThreadsOrderType.importance ||
                element == ThreadsOrderType.resCountDesc)
            .toList();
      case Communities.girlsCh:
        return list
            .where((element) =>
                // element == ThreadsOrderType.hot ||
                element == ThreadsOrderType.newerResponce ||
                element == ThreadsOrderType.importance ||
                element == ThreadsOrderType.resCountDesc)
            .toList();
      case Communities.chan4:
        return list
            .where((element) =>
                element == ThreadsOrderType.hot ||
                element == ThreadsOrderType.newerResponce ||
                element == ThreadsOrderType.importance ||
                element == ThreadsOrderType.newerThread ||
                element == ThreadsOrderType.resCountDesc)
            .toList();
      case Communities.mal:
        return list
            .where((element) =>
                element == ThreadsOrderType.newerResponce ||
                element == ThreadsOrderType.importance ||
                element == ThreadsOrderType.newerThread ||
                element == ThreadsOrderType.resCountDesc)
            .toList();
      default:
        return list
            .where((element) =>
                element == ThreadsOrderType.hot ||
                element == ThreadsOrderType.newerThread ||
                element == ThreadsOrderType.importance ||
                // element == ThreadsOrderType.oldOrder ||
                element == ThreadsOrderType.resCountDesc)
            .toList();
    }
  }

  @computed
  List<TimeagoList> get selectableTimeago {
    switch (selectedForum) {
      case Communities.fiveCh || Communities.pinkCh || Communities.shitaraba:
        return TimeagoList.values;
      default:
        return TimeagoList.values
            .where((element) => element != TimeagoList.disableWhenHotIsOver2000)
            .toList();
    }
  }

  @computed
  List<RetentionPeriodList> get selectableRetentionPeriod {
    switch (selectedForum) {
      case Communities.fiveCh || Communities.pinkCh || Communities.shitaraba:
        return RetentionPeriodList.values;
      // case Communities.pinkCh:
      //   return RetentionPeriodList.values;
      // case Communities.shitaraba:
      //   return RetentionPeriodList.values;
      default:
        return RetentionPeriodList.values
            .where((element) => element != RetentionPeriodList.byPostPace)
            .toList();
    }
  }

  ForumState? selectForum(final Communities value) => _selectedForum(value);

  @computed
  String? get boardIdForSearch {
    return _selectedForum(selectedForum)?.settings?.searchBoardId;

    // switch (selectedForum) {
    //   case Communities.futabaCh:
    //     return futabaCh.settings?.searchBoardId;
    //   case Communities.machi:
    //     return machi.settings?.searchBoardId;
    //   case Communities.machi:
    //     return machi.settings?.searchBoardId;
    //   default:
    // }
    // return null;
  }

  @computed
  Future<List<BoardData?>?> get boardListForSearch async {
    return selectedForumState?.forumMain.boardListForSearch;

    // switch (selectedForum) {
    //   case Communities.futabaCh:
    //     final boards = futabaCh.forumMain.boards;
    //     if (boards.isNotEmpty) {
    //       return boards;
    //     } else {
    //       final boards = await FutabaChHandler.getBoards();
    //       return boards.boards;
    //     }
    //   case Communities.machi:
    //     final boards = machi.forumMain.boards;
    //     if (boards.isNotEmpty) {
    //       return boards;
    //     } else {
    //       final boards = await MachiHandler.getBoards();
    //       return boards.boards;
    //     }
    //   case Communities.chan4:
    //     final boards = chan4.forumMain.boards;
    //     if (boards.isNotEmpty) {
    //       return boards;
    //     } else {
    //       final boards = await Chan4Handler.getBoards(chan4.selectedNsfw);
    //       return boards.boards;
    //     }
    //   case Communities.mal:
    //     return MalData.searchBoardList;
    //   default:
    // }
    // return null;
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
      selectedForumState?.history.currentHistoryList ?? {};

  @computed
  Map<String, List<ThreadBase?>?> get currentSearchList =>
      selectedForumState?.search.searchListByBoardId ?? {};

  @computed
  List<ThreadBase?> get searchList => selectedForumState?.searchList ?? [];

  @computed
  bool get showSearchWordChipOnPrimary {
    final main = selectedForumState?.forumMain.searchThreadWord;
    final search = selectedForumState?.search.searchWord;
    if (largeScreen) {
      return main != null && main.isNotEmpty;
    } else {
      // logger.d(
      //     'showSearchWordChipOnPrimary: $search, $currentScreen, $selectedForumPrimaryBody');
      if (currentScreen == BottomMenu.forums &&
          selectedForumPrimaryBody == PrimaryViewState.threads) {
        return main != null && main.isNotEmpty;
      }
      if (currentScreen == BottomMenu.search &&
          primarySearchView == PrimaryViewState.threads) {
        return search != null && search.isNotEmpty;
      }
    }
    return false;
  }

  @computed
  bool get showNextButtonForForum {
    final show = selectedForumPrimaryBody == PrimaryViewState.threads &&
        (selectedForumState?.forumMain.hasYtThreadsClient ?? false);
    if (largeScreen) {
      return show;
    } else {
      return currentScreen == BottomMenu.forums && show;
    }
  }

  @computed
  bool get hideUpdateThreadsButton {
    return selectedForumState?.forumMain.hideUpdateThreadsButton ?? false;
  }

  @computed
  bool get showNextButtonForSearch =>
      currentScreen == BottomMenu.search &&
      (selectedForumState?.search.showNextButton ?? false);

  @computed
  String? get mainSearchWord {
    if (largeScreen) {
      return selectedForumState?.forumMain.searchThreadWord;
    } else {
      if (currentScreen == BottomMenu.forums &&
          selectedForumPrimaryBody == PrimaryViewState.threads) {
        return selectedForumState?.forumMain.searchThreadWord;
      }
    }
    return null;
  }

  @computed
  String? get searchScreenWord {
    if (!largeScreen &&
        currentScreen == BottomMenu.search &&
        primarySearchView == PrimaryViewState.threads) {
      return selectedForumState?.search.searchWord;
    }
    return null;
  }

  @computed
  String? get postOnSiteUrl {
    switch (selectedForum) {
      case Communities.girlsCh:
        return GirlsChParser.createThreadUrl;
      default:
        return currentBoardUrl;
    }
  }

  void clearSearchWord() {
    if (searchScreenWord != null) {
      selectedForumState?.search.clear();
    }
    if (mainSearchWord != null) {
      selectedForumState?.forumMain.clearSearchWord();
    }
  }

  Future<void> searchNextThreads() async {
    await selectedForumState?.search.searchNextThreads();
  }

  void setCurrentContentIndex(final int index) {
    currentContentState?.setCurrentContentIndex(index);
  }

  @action
  void setOnOpenedPopup() {
    onOpenedPopup = true;
  }

  @action
  void setOnClosedPopup() {
    onOpenedPopup = false;
  }

  @action
  void setChangedDrawer(final bool v) {
    openedDrawer = v;
  }

  @action
  void setOpenedDialog() {
    openedDialog = !openedDialog;
  }

  // @computed
  // String? get selectedBoardName => switch (currentScreen) {
  //       BottomMenu.history => selectedForumState?.history.selectedBoardName,
  //       BottomMenu.search => selectedForumState?.search.selectedBoardName,
  //       BottomMenu.forums => null,
  //     };

  @computed
  String? get getDefaultName {
    final content = currentContent;
    final first = content?.content.firstOrNull;
    String? name;
    switch (selectedForum) {
      case Communities.fiveCh || Communities.pinkCh:
        if (first is FiveChThreadContentData) {
          final sub = first.domain.split('.').first;
          final BoardMetaData? meta = selectedForumState?.boardMetadataSet
              .firstWhere(
                  (value) =>
                      value?.directory == sub &&
                      value?.boardId == content?.boardId,
                  orElse: () => null);
          if (meta != null) {
            name = FiveChData.defaultName(meta.data);
          }
        }
        break;
      case Communities.shitaraba:
        if (first is ShitarabaContentData) {
          final category = first.category;
          final boardId = first.boardId;
          final meta = selectedForumState?.boardMetadataSet.firstWhere(
              (value) =>
                  value?.directory == category && value?.boardId == boardId,
              orElse: () => null);
          if (meta != null) {
            name = ShitarabaData.defaultName(meta.data);
          }
        }
      default:
    }
    logger.d('defaultName: $name');
    return name ?? currentContentState?.getDefaultName;
  }

  String? boardNameById(final String id, {final Communities? forum}) {
    final f = forum ?? selectedForum;
    return switch (f) {
      Communities.mal => MalData.boardNameById(id),
      // Communities.fiveCh => fiveCh.boardNameByIdFromMetadataSet(id),
      Communities.fiveCh => FiveChBoardNames.getById(id),
      Communities.girlsCh => GirlsChData.getBoardNameById(id),
      Communities.futabaCh => FutabaChBoardNames.getById(id),
      // Communities.pinkCh => pinkCh.boardNameByIdFromMetadataSet(id),
      Communities.pinkCh => FiveChBoardNames.getById(id) ?? id,
      Communities.machi => MachiData.getBoardNameById(id),
      Communities.hatena => HatenaData.boardNameById(id) ?? id,
      Communities.open2Ch => FiveChBoardNames.getById(id) ?? id,
      Communities.shitaraba => _selectedForum(f)
              ?.history
              .markList
              .firstWhere(
                (element) =>
                    element?.boardId == id && element?.boardName != null,
                orElse: () => null,
              )
              ?.boardName ??
          id,
      Communities.youtube => _youtubeBoardNameById(id),
      Communities.chan4 => _selectedForum(f)
              ?.forumMain
              .boards
              .firstWhere(
                (element) => element?.id == id,
                orElse: () => null,
              )
              ?.name ??
          id,
      null => null
    };
  }

  String? _youtubeBoardNameById(
    final String id,
  ) {
    if (currentScreen == BottomMenu.search) {
      return _selectedForum(Communities.youtube)
              ?.searchList
              .firstWhere(
                (element) =>
                    element?.boardId == id && element?.boardName != null,
                orElse: () => null,
              )
              ?.boardName ??
          id;
    } else {
      return _selectedForum(Communities.youtube)
              ?.history
              .markList
              .firstWhere(
                (element) =>
                    element?.boardId == id && element?.boardName != null,
                orElse: () => null,
              )
              ?.boardName ??
          id;
    }
  }

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

  void removeSnackMessage() {
    logger.d(
        'removeSnackMessage 0: addForumName:$addForumName, deletedThreadTitle: $deletedThreadTitle, error: ${selectedForumState?.errorMessage}');
    if (addForumName != null) {
      removeAddForumName();
    } else if (deletedThreadTitle != null) {
      removeDeletedThreadTitle();
    } else {
      selectedForumState?.setErrorMessage(null);
    }
    logger.d(
        'removeSnackMessage: addForumName:$addForumName, deletedThreadTitle: $deletedThreadTitle, error: ${selectedForumState?.errorMessage}');
  }

  @action
  void setLog(final String value) {
    debugLog.add(value);
  }

  Future<FetchResult> setContent(final String id,
      {required final ThreadBase thread}) async {
    // toggleContentLoading();
    if (largeScreen) {
      await _updateLastOpenedIndexWhenScreenTransition();
      selectedForumState?.history.deleteContentState();
    }
    final result = await selectedForumState?.setContent(id, thread: thread);
    // toggleContentLoading();
    return result ?? FetchResult.error;
  }

  List<int?>? setFilterWordForContent(final String value) =>
      selectedForumState?.currentContentState?.filterdIndexList(value);

  void setSelectedText(final String? value) {
    selectedForumState?.currentContentState?.setSelectedText(value);
  }

  @action
  void setLaunchStatus(final LaunchStatus value) => launchStatus = value;

  // Future<int?> getThreadDiffById(final String value,
  //         {final bool onLibraryView = false}) async =>
  //     await selectedForumState?.getThreadDiffById(value,
  //         onLibraryView: onLibraryView);

  Future<void> post(final PostData value) async {
    toggleContentLoading();
    final result = await selectedForumState?.postComment(value);
    await selectedForumState?.saveLastUsedText(value);
    toggleContentLoading();
    if (result != null && result) {
      await updateContent();
    }
  }

  Future<(FetchResult, int?)?> updateContent(
      {final RangeList? changedRange,
      final int? changedPage,
      final int? malOffset}) async {
    if (currentContent == null) return null;
    toggleContentLoading();
    final result = await selectedForumState?.updateContent(
        changedPage: changedPage,
        changedRange: changedRange,
        malOffset: malOffset);
    if (contentLoading) {
      toggleContentLoading();
    }
    return result;
  }

  Future<FetchResult> getDataByUrl(final Uri? uri,
      {final Communities? selectedForum, final bool setContent = true}) async {
    if (uri == null) return FetchResult.error;
    // toggleContentLoading();
    // toggleEntireLoading();
    final forum = selectedForum != null
        ? _selectedForum(selectedForum)
        : selectedForumState;
    final result = await forum?.getDataByUrl(uri, setContent: setContent);
    // toggleEntireLoading();
    // toggleContentLoading();
    return result ?? FetchResult.error;
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

  // Future<void> updateImportance(final ImportanceData value) async {
  //   toggleEntireLoading();
  //   await selectedForumState?.updateImportance(value);
  //   toggleEntireLoading();
  // }

  // Future<void> deleteImportance(final ImportanceData value) async {
  //   toggleEntireLoading();
  //   await selectedForumState?.deleteImportance(value);
  //   toggleEntireLoading();
  // }

  ImportanceData? getImportanceByThread(final ThreadBase item) {
    final byUserId = _getImportanceByUserId(item.getUserId);
    final title = getImportanceByTitle(item.title);
    // logger.d('getImportanceByThread: item.getUserId: ${item.getUserId}, ${byUserId?.level}, ${title?.strValue}');
    return byUserId ?? title;
  }

  ImportanceData? getImportanceByContent(final ContentData value) {
    final byPostId = _getImportanceByPostId(value.getPostId);
    final byUserId = _getImportanceByUserId(value.getUserId);
    final byUserName = _getImportanceByUserName(value.getUserName);
    final byBody = _getImportanceByBody(value.body);
    // if (byBody != null) {
    //   logger.d('importance body: ${byBody.strValue}');
    // }
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
    final exist = selectedForumState?.settings?.getImportanceList.firstWhere(
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

  void toggleBoardsLoading() {
    selectedForumState?.forumMain.toggleBoardLoading();
  }

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
    await repository.loadUserData();
    _setForumList();
    _setInitialForum();
    await repository.loadInitialData();

    // initWhenLargeScreen();
  }

  // Future<void> agreeTerms() async {
  //   final current = userData;
  //   if (current == null) return;
  //   final newData = current.copyWith(agreedTerms: true);
  //   await repository.updateUserAgreedTerms(newData);
  // }

  Future<void> sendAgree(final ContentData value,
      {final bool good = true}) async {
    await selectedForumState?.sendAgree(value, good: good);
  }

  @action
  void _setForum(final Communities value) {
    final s = ForumState(parent: this, type: value);
    forums.add(s);
  }

  @action
  void _removeForum(final Communities value) {
    forums.removeWhere((element) => element?.type == value);
  }

  void _setForumList() {
    if (selectedForumList != null) {
      for (final i in selectedForumList!) {
        _setForum(i);
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

  Future<void> updateForumSettings({final ForumSettingsData? newData}) async =>
      await repository.updateForumSettings(settings: newData);

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
    // _setInitialPrimaryView();
  }

  // int? lastReadTimeBySelectedThread(final ThreadBase item) {
  //   final data = selectedForumState?.history.getSelectedMarkData(item);
  //   return data?.lastReadAt;
  // }

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
    // _setInitialPrimaryView();
  }

  // void _setInitialPrimaryView() {
  //   if (largeScreen) {
  //   } else {

  //     if (bottomBarIndex == 2 && selectedForumState?.search.content == null) {
  //       setPrimaryView(PrimaryViewState.threads);
  //     }
  //   }
  // }

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

  @action
  void setScreenSize(final bool value) {
    largeScreen = value;
    if (largeScreen) {
      for (final i in forums) {
        if (i != null) {
          i.disposeNonLargeContent();
        }
      }
      // fiveCh.disposeNonLargeContent();
      // girlsCh.disposeNonLargeContent();
      // futabaCh.disposeNonLargeContent();
      // pinkCh.disposeNonLargeContent();
      // shitaraba.disposeNonLargeContent();
      // machi.disposeNonLargeContent();
      // chan4.disposeNonLargeContent();
      // open2ch.disposeNonLargeContent();
      // hatena.disposeNonLargeContent();
      // mal.disposeNonLargeContent();
      if (bottomBarIndex == 0) {
        setBottomIndex(1);
      }
    }
  }

  Future<void> deleteSelectedForumThread(final ThreadMarkData value) async {
    await repository.deleteThread(value);
  }

  Future<void> deleteHistoryByThreadData(final ThreadData thread) async {
    final markData = getSelectedMarkByThreadData(thread, thread.type);
    if (markData != null) {
      await repository.deleteThread(markData);
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

  Future<void> blockThreadPostUser(final ThreadData thread) async {
    toggleMainThreadsLoading();
    await selectedForumState?.blockThreadPostUser(thread);
    toggleMainThreadsLoading();
  }

  Future<void> blockThreadResponseUser(final ContentData value) async {
    await selectedForumState?.blockResponseUser(value);
  }

  Future<void> hideResponse(final ContentData value) async {
    await selectedForumState?.hideResponse(value);
  }

  Future<void> updateForumImportance(final List<ImportanceData?> value,
      {final bool delete = false}) async {
    await selectedForumState?.updateForumImportance(value, delete: delete);
  }

  Future<void> clearForumImportance(
    final ImportanceList value,
  ) async {
    await selectedForumState?.clearForumImportance(value);
  }

  Future<void> updateThreadImportance(final ImportanceData value,
      {final bool delete = false}) async {
    await selectedForumState?.updateThreadImportance(value, delete: delete);
  }

  Future<void> clearThreadImportance(final ImportanceList value) async {
    await selectedForumState?.clearThreadImportance(value);
  }

  Future<void> allClearThreadImportance() async {
    await selectedForumState?.allClearThreadImportance();
  }

  // Future<void> updateForumImportance(
  //     final List<ImportanceData?> value, final bool isBoard) async {
  //   final settings = selectedForumState?.settings;
  //   if (settings == null) return;
  //   if (value.isEmpty) return;
  //   final current = isBoard
  //       ? [...settings.boardImportanceList]
  //       : [...settings.threadsImportanceList];
  //   for (final i in value) {
  //     current.removeWhere((element) => element?.id == i?.id);
  //     current.insert(0, i);
  //   }

  //   final strList = current.map((e) => jsonEncode(e?.toJson())).toList();
  //   final newData = isBoard
  //       ? settings.copyWith(boardImportance: strList)
  //       : settings.copyWith(threadsImportance: strList);
  //   selectedForumState?.setSettings(newData);
  //   await updateForumSettings();
  // }

  // Future<void> deleteForumImportance(
  //     final ImportanceData value, final bool isBoard) async {
  //   final settings = selectedForumState?.settings;
  //   if (settings == null) return;
  //   final current = isBoard
  //       ? [...settings.boardImportanceList]
  //       : [...settings.threadsImportanceList];
  //   current.removeWhere((element) => element?.id == value.id);
  //   // current.insert(0, value);
  //   final strList = current.map((e) => jsonEncode(e?.toJson())).toList();
  //   final newData = isBoard
  //       ? settings.copyWith(boardImportance: strList)
  //       : settings.copyWith(threadsImportance: strList);
  //   selectedForumState?.setSettings(newData);
  //   await updateForumSettings();
  // }
  // Future<void> deleteSelectedData()

  Future<void> setLastOpenedContentIndexById(final int? index,
      {required final Communities type,
      required final String threadId,
      required final String boardId}) async {
    if (index == null) return;
    final mark = _selectedForum(type)
        ?.history
        .getSelectedMarkDataById(threadId, boardId);
    // switch (type) {
    //   case Communities.fiveCh:
    //     mark = fiveCh.history.markList.firstWhere(
    //       (element) => element?.id == threadId && element?.boardId == boardId,
    //       orElse: () => null,
    //     );
    //     break;
    //   case Communities.girlsCh:
    //     mark = girlsCh.history.markList.firstWhere(
    //         (element) => element?.id == threadId && element?.boardId == boardId,
    //         orElse: () => null);
    //     break;
    //   case Communities.futabaCh:
    //     mark = futabaCh.history.markList.firstWhere(
    //         (element) => element?.id == threadId && element?.boardId == boardId,
    //         orElse: () => null);
    //     break;
    //   case Communities.pinkCh:
    //     mark = pinkCh.history.markList.firstWhere(
    //         (element) => element?.id == threadId && element?.boardId == boardId,
    //         orElse: () => null);
    //     break;
    //   case Communities.machi:
    //     mark = machi.history.markList.firstWhere(
    //         (element) => element?.id == threadId && element?.boardId == boardId,
    //         orElse: () => null);
    //     break;
    //   case Communities.shitaraba:
    //     mark = shitaraba.history.markList.firstWhere(
    //         (element) => element?.id == threadId && element?.boardId == boardId,
    //         orElse: () => null);
    //     break;
    //   case Communities.open2Ch:
    //     mark = open2ch.history.markList.firstWhere(
    //         (element) => element?.id == threadId && element?.boardId == boardId,
    //         orElse: () => null);
    //     break;
    //   default:
    // }
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

  // void setPositionToGet(final PositionToGet value) {
  //   final settnigs = selectedForumState?.settings;
  //   if (settnigs == null) return;
  //   if (settnigs.positionToGet == value) return;
  //   final newData = settnigs.copyWith(positionToGet: value);
  //   selectedForumState?.setSettings(newData);
  //   // await repository.server.forumState.setPositionToGet(value);

  //   // await userStorage.setPositionToGet(selected, value);
  // }

  void setListViewStyle(final ListViewStyle value) {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.listViewStyle == value) return;
    final newData = settnigs.copyWith(listViewStyle: value);
    selectedForumState?.setSettings(newData);
  }

  void setAutoDownloadableSizeLimit(final AutoDownloadableSizeLimit value) {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.autoDownloadableSizeLimit == value) return;
    final newData = settnigs.copyWith(autoDownloadableSizeLimit: value);
    selectedForumState?.setSettings(newData);
  }

  void setMovedToLastThreads(final MovedToLastThreads value) {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.movedToLastThreads == value) return;
    final newData = settnigs.copyWith(movedToLastThreads: value);
    selectedForumState?.setSettings(newData);
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

  void setNsfw(final bool value) {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.nsfw == value) return;
    final newData = settnigs.copyWith(nsfw: value);
    selectedForumState?.setSettings(newData);
    selectedForumState?.forumMain.reloadBoards().then((final v) {
      if (!value) {
        switch (selectedForum) {
          case Communities.chan4:
            setSearchBoardId('a');
            break;
          default:
        }
      }
    });
  }

  Future<void> setThreadsOrder(final ThreadsOrderType value) async {
    final current = selectedForumState?.settings;
    if (current == null) return;
    final newData = current.copyWith(threadsOrderType: value);
    selectedForumState?.setSettings(newData);
  }

  Future<void> setTimeago(final TimeagoList value) async {
    final current = selectedForumState?.settings;
    if (current == null) return;
    final newData = current.copyWith(timeago: value);
    selectedForumState?.setSettings(newData);
    if (currentContentState != null) {
      currentContentState!.setTimeago(value);
    }
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

  Future<(Uint8List?, String?)?> getAvatarData(final ContentData item) async {
    Uri? uri = item.avatarUri;
    if (item.forum == Communities.youtube) {
      uri = await getYoutubeChannelLogoUri((item as YoutubeContent).channelId);
    }
    if (uri == null) {
      return null;
    }
    return await getMediaData(uri.toString());
  }

  Future<(Uint8List?, String?)?> getMediaData(final String url) async {
    if (url.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }
    final cache = await _getMediaFromCache(url);
    if (cache != null) {
      logger.i('get media from cache: $url');
      return (cache, null);
    }
    if (currentAutoDLSizeLimit == AutoDownloadableSizeLimit.noLimit) {
      final data = await _getMedia(url);
      logger.i('get media from network: no limit, $url');
      return (data, null);
    }
    final bytes = await FetchData.getMediaSize(url);
    if (bytes != null) {
      if (bytes <= currentAutoDLSizeLimit.value) {
        final data = await _getMedia(url);
        // final data = await FetchData.getMediaData(url);
        // if (data == null) return null;
        logger.i('get media from network: under size $bytes, $url');
        // final currentThread = currentContentThreadData;
        // await repository.mediaLocal.putMediaData(currentThread?.documentId,
        //     url: url, forum: selectedForum, data: data);
        return (data, filesize(bytes));
      } else {
        logger.i('not get media from network: $bytes, $url');
        return (null, filesize(bytes));
      }
    }
    return (null, null);
  }

  Future<Uint8List?> getMediaManually(final String url) async => _getMedia(url);

  Future<Uint8List?> _getMedia(final String url) async {
    final data = await FetchData.getMediaData(url);
    if (data == null) return null;
    logger.i('get media $url');
    final currentThread = currentContentThreadData;
    await repository.mediaLocal.putMediaData(currentThread?.documentId,
        url: url, forum: selectedForum, data: data);
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

  // Future<void> setSortHistoryByExpire(final bool value) async {
  //   final settnigs = selectedForumState?.settings;
  //   if (settnigs == null) return;
  //   if (settnigs.sortHistoryByRetention == value) return;
  //   final newData = settnigs.copyWith(sortHistoryByRetention: value);
  //   selectedForumState?.setSettings(newData);
  //   await updateForumSettings();
  // }

  Future<void> setSortHistory(final SortHistoryList value) async {
    final settnigs = selectedForumState?.settings;
    if (settnigs == null) return;
    if (settnigs.sortHistoryList == value) return;
    final newData = settnigs.copyWith(sortHistoryList: value);
    selectedForumState?.setSettings(newData);
    await updateForumSettings();
  }

  ForumState? _selectedForum(final Communities? forum) {
    return forums.firstWhere((element) => element?.type == forum,
        orElse: () => null);
  }
  // ForumState? _selectedForum(final Communities? forum) => switch (forum) {
  //       Communities.fiveCh => fiveCh,
  //       Communities.pinkCh => pinkCh,
  //       Communities.shitaraba => shitaraba,
  //       Communities.futabaCh => futabaCh,
  //       Communities.girlsCh => girlsCh,
  //       Communities.open2Ch => open2ch,
  //       Communities.machi => machi,
  //       Communities.chan4 => chan4,
  //       Communities.hatena => hatena,
  //       Communities.mal => mal,
  //       Communities.youtube => youtube,
  //       null => null
  //     };

  Future<void> setSaveLastUsedText(
      final InputCommentFields target, final bool value) async {
    await selectedForumState?.setSaveLastUsedText(target, value);
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

  bool isFavoritesBoard(final String value) {
    return currentFavoritesBoards.firstWhere(
          (element) => element != null && element.contains(value),
          orElse: () => null,
        ) !=
        null;
  }

  Future<void> setFavBoardById(final String value,
      {final bool remove = false, final bool? chOrPl}) async {
    await selectedForumState?.setFavBoardById(value,
        remove: remove, chOrPl: chOrPl);
  }

  // Future<void> setFavoritesBoards(final List<String?> value) async {
  //   final settnigs = selectedForumState?.settings;
  //   if (settnigs == null) return;
  //   final newData = settnigs.copyWith(favoritesBoardList: value);
  //   selectedForumState?.setSettings(newData);
  //   await updateForumSettings();
  //   await selectedForumState?.forumMain.getFavBoards();
  // }

  Future<void> setFavBoardList(final List<String?> value) async {
    await selectedForumState?.saveFavBoardList(value);
  }

  Future<void> toggleFavoriteBoardByCurrent() async {
    final list = selectedForumState?.forumMain.toggleFavoriteBoard();
    if (list != null) {
      await selectedForumState?.saveFavBoardList(list);
      // await setFavoritesBoards(list);
    }
  }

  // Future<bool> addBoard(final String url) async {
  //   final str = selectedForumState?.forumMain.getFavBoardStrFromUri(url);
  //   if (str != null) {
  //     await selectedForumState?.setFavBoardById(str);
  //     // await setFavoritesBoards(list);
  //     return true;
  //   }
  //   return false;
  // }

  Future<bool> addFavBoardBySelectedForum(final Uri uri,
      {final Communities? forumData}) async {
    List<String?>? favs;
    final forum = forumData ?? selectedForum;

    final selected = _selectedForum(forum);
    if (selected == null) {
      return false;
    }
    favs = await selected.forumMain.getNewFavoritesBoardListByUri(uri);
    // switch (forum) {
    //   case Communities.shitaraba:
    //     favs = shitaraba.forumMain.addBoard(uri.toString());
    //     logger.d('favs: $favs');
    //     break;
    //   default:
    //     favs = selected.forumMain.setFavoriteBoardByUri(uri);
    // }
    if (favs == null) return false;
    final settnigs = selected.settings;
    if (settnigs == null) return false;
    await selected.saveFavBoardList(favs);
    // final newData = settnigs.copyWith(favoritesBoardList: favs);
    // selected.setSettings(newData);
    // await updateForumSettings(newData: newData);
    // await selected.forumMain.getFavBoards();
    return true;
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
    await selectedForumState?.history.updateAll();
    // await selectedForumState?.history.updateAllList();
    toggleHistoryThreadsLoading();
  }

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
    final newData = current.copyWith(searchBoardId: id);
    selectedForumState?.setSettings(newData);
    // switch (selectedForumState?.type) {
    //   case Communities.futabaCh:
    //     // final newData = current.copyWith(searchBoardIdForFutaba: id);
    //     futabaCh.setSettings(newData);
    //     break;
    //   case Communities.machi:
    //     // final newData = current.copyWith(searchBoardIdForMachi: id);
    //     machi.setSettings(newData);
    //     break;
    //   case Communities.chan4:
    //     chan4.setSettings(newData);
    //     break;
    //   case Communities.mal:
    //     mal.setSettings(newData);
    //     break;
    //   default:
    // }
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

  Future<void> updateThreadsByBoard(final String boardId) async {
    selectedForumState?.history.toggleThreadsLoading();
    await selectedForumState?.history.updateByBoard(boardId);
    selectedForumState?.history.toggleThreadsLoading();
  }

  Future<void> updateThreadsByHistory(final String history) async {
    selectedForumState?.history.toggleThreadsLoading();
    await selectedForumState?.history.updateByHistory(history);
    selectedForumState?.history.toggleThreadsLoading();
  }

  Future<void> clearThreadsByBoard(final String boardId) async {
    selectedForumState?.history.toggleThreadsLoading();
    await selectedForumState?.history.clearThreadsByBoard(boardId);
    selectedForumState?.history.toggleThreadsLoading();
  }

  Future<void> clearThreadsByLastReadAt(final String history) async {
    selectedForumState?.history.toggleThreadsLoading();
    await selectedForumState?.history.clearThreadsByHistory(history);
    selectedForumState?.history.toggleThreadsLoading();
  }

  Future<void> removeUserData() async {
    await repository.removeUserData();
  }

  Future<void> addForum(final Communities value) async {
    final data = await repository.addForum(value);
    if (data != null &&
        selectedForumList != null &&
        selectedForumList!.contains(value)) {
      _setForum(value);
      setForumSettings(data);
      logger.d('addForum: $value');
    }
  }

  Future<void> removeForum(final Communities value) async {
    await repository.removeForum(value);
    if (selectedForumList != null && !selectedForumList!.contains(value)) {
      _removeForum(value);
      logger.d('removeForum: $value');
    }
  }

  // Future<void> getThreadsByJson() async {
  //   // FutabaChHandler.getThreadsByJson();
  // }

  // String? parsedUrl(final String url) {
  //   switch (selectedForum) {
  //     case Communities.fiveCh:
  //       return FiveChData.toDatUrl(url);
  //     case Communities.pinkCh:
  //       return FiveChData.toDatUrl(url);
  //     default:
  //       return url;
  //   }
  // }

  Communities? forumLink(final Uri uri) {
    if (selectedForumList == null) return null;
    final host = uri.host;
    for (final i in selectedForumList!) {
      if (host.contains(i.host)) {
        return i;
      }
      if (i == Communities.youtube && host == YoutubeData.sHost) {
        return i;
      }
    }
    return null;
  }

  Future<void> openBoardByUri(final Uri uri) async {
    if (!largeScreen) return;
    await selectedForumState?.forumMain.openBoardByUri(uri);
  }

  Future<ContentData?> getSelectedRes(
      final Uri uri, final Communities forum, final int resNum) async {
    return _selectedForum(forum)?.getSelectedRes(uri, resNum);
  }

  ThemeList getForumTheme(final Communities forum) {
    final currentTheme = selectedTheme;
    return _selectedForum(forum)?.selectedTheme ?? currentTheme;
  }

  String? getBoardIdFromUri(final Uri uri, final Communities forum) {
    switch (forum) {
      case Communities.fiveCh || Communities.pinkCh:
        return FiveChData.getBoardIdFromUri(uri, forum);
      case Communities.shitaraba:
        return ShitarabaData.getBoardIdFromUri(uri);
      case Communities.machi:
        return MachiData.getBoardIdFromUri(uri);
      case Communities.girlsCh:
        final fromUri = GirlsChData.getBoardIdFromUri(uri);
        final content = currentContent?.content.lastOrNull;
        final id = content is GirlsChContent? ? content?.categoryId : null;
        return id ?? fromUri;
      case Communities.open2Ch:
        return Open2ChData.getBoardIdFromUri(uri);
      case Communities.futabaCh:
        return FutabaData.getBoardIdFromUri(uri);
      case Communities.chan4:
        return Chan4Data.getBoardIdFromUri(uri);
      case Communities.hatena:
        return HatenaData.boardIdFromUri(uri);
      case Communities.youtube:
        return YoutubeData.getBoardIdFromUri(uri);
      default:
    }
    return null;
  }

  String? getThreadIdFromUri(final Uri uri, final Communities forum) {
    logger.d('threadId: $uri');
    switch (forum) {
      case Communities.fiveCh || Communities.pinkCh:
        return FiveChData.getThreadIdFromUri(uri, forum);
      case Communities.shitaraba:
        return ShitarabaData.getThreadIdFromUri(uri);
      case Communities.machi:
        return MachiData.getThreadIdFromUri(uri);
      case Communities.girlsCh:
        return GirlsChData.getThreadIdFromUri(uri);
      case Communities.open2Ch:
        return Open2ChData.getThreadIdFromUri(uri);
      case Communities.futabaCh:
        return FutabaData.getThreadIdFromUri(uri);
      case Communities.chan4:
        return Chan4Data.getThreadIdFromUri(uri);
      case Communities.hatena:
        return HatenaData.getThreadIdFromUri(uri);
      case Communities.mal:
        return MalData.getThreadIdFromUri(uri);
      case Communities.youtube:
        return YoutubeData.getThreadIdFromUri(uri);
      default:
    }
    return null;
  }

  bool? uriIsThreadOrBoard(final Uri uri, final Communities forum) {
    switch (forum) {
      case Communities.shitaraba:
        return ShitarabaData.uriIsThreadOrBoard(uri);
      case Communities.fiveCh || Communities.pinkCh:
        return FiveChData.uriIsThreadOrBoard(uri, forum);
      case Communities.girlsCh:
        return GirlsChData.uriIsThreadOrBoard(uri);
      case Communities.machi:
        return MachiData.uriIsThreadOrBoard(uri);
      case Communities.open2Ch:
        return Open2ChData.uriIsThreadOrBoard(uri);
      case Communities.futabaCh:
        return FutabaData.uriIsThreadOrBoard(uri);
      case Communities.chan4:
        return Chan4Data.uriIsThreadOrBoard(uri);
      case Communities.hatena:
        return HatenaData.uriIsThreadOrBoard(uri);
      case Communities.youtube:
        return YoutubeData.uriIsThreadOrBoard(uri);
      default:
    }
    return null;
  }

  String? getResNumFromUri(final Uri uri, final Communities forum) {
    int? resNum;
    switch (forum) {
      case Communities.fiveCh || Communities.pinkCh:
        resNum = FiveChData.getResNumFromUri(uri, forum);
      case Communities.girlsCh:
        resNum = GirlsChData.getResNumFromUri(uri);
      case Communities.shitaraba:
        resNum = ShitarabaData.getResNumFromUri(uri);
      case Communities.machi:
        resNum = MachiData.getResNumFromUri(uri);
      case Communities.open2Ch:
        resNum = Open2ChData.getResNumFromUri(uri);
      case Communities.hatena:
        return HatenaData.getCommentNameFromUri(uri);
      default:
        return null;
    }
    if (resNum != null) {
      return resNum.toString();
    }
    return null;
  }

  ThreadMarkData? getSelectedMarkByThreadData(
      final ThreadData thread, final Communities forum) {
    return _selectedForum(forum)?.history.getSelectedMarkData(thread);
  }

  ThreadMarkData? getThreadMarkByUri(final Uri uri, final Communities forum) {
    return _selectedForum(forum)?.history.getSelectedMarkDataByUri(uri);
    // switch (forum) {
    //   case Communities.fiveCh:
    //     return fiveCh.history.getSelectedMarkDataByUri(uri);
    //   case Communities.pinkCh:
    //     return pinkCh.history.getSelectedMarkDataByUri(uri);
    //   default:
    // }
    // return null;
  }

  Future<void> updateTemplate(final TemplateData value) async {
    await repository.updateTemplateData(value);
  }

  TemplateData? getInitialTemplate() {
    final current = selectedForumState?.settings;
    if (current == null) {
      return null;
    }
    return repository.postDraftLocal.initialTemplate(current);
  }

  Future<bool> postThread({
    required final dynamic data,
  }) async {
    if (data is! PostData) return false;
    toggleMainThreadsLoading();
    final result =
        await selectedForumState?.forumMain.postThread(data: data) ?? false;
    toggleMainThreadsLoading();
    return result;
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

  // Future<Directory?> downloadDirectory() async {
  //   return await getDownloadsDirectory();
  // }

  String getMediaFilePath(final String url) {
    return repository.mediaLocal.getFullPath(url).path;
  }

  Future<Uri?> getYoutubeChannelLogoUri(final String? id) async {
    if (id == null) {
      return null;
    }
    final content = currentContentState?.youtubeChannelLogoSrc;
    if (content == null) {
      return null;
    }
    if (content[id] == null) {
      final uri = await YoutubeHandler.getChannelLogoUri(id);
      currentContentState?.setYoutubeChannnelLogoSrc(id, uri.toString());
      return uri;
    } else {
      final url = content[id]!;
      return Uri.parse(url);
    }
  }

  Future<bool> report(final ContentData content) async {
    switch (content.forum) {
      case Communities.girlsCh:
        if (content is GirlsChContent) {
          return await GirlsChHandler.report(content.reportHash ?? '');
        }

      default:
    }
    return false;
  }

  Future<void> getYoutubeReplies(final ContentData item) async {
    if (item is! YoutubeContent) {
      return;
    }
    toggleContentLoading();
    final result = await YoutubeHandler.getRepies(item);
    if (result != null) {
      currentContentState?.setYtReplies(result, item.replyCount);
    }
    toggleContentLoading();
    // return result;
  }

  Future<List<ContentData?>?> getRes(
      final int index, final ThreadMarkData thread) async {
    FetchContentResultData? result;
    switch (selectedForum) {
      case Communities.girlsCh:
        result = await GirlsChHandler.getRes(thread.id, index);
        break;
      case Communities.shitaraba:
        result = await ShitarabaHandler.getRes(
            ShitarabaData.getThreadUrlPath(
                category: thread.shitarabaCategory,
                boardId: thread.boardId,
                threadId: thread.id),
            index);
        break;
      default:
    }
    // final result = await GirlsChHandler.getRes(threadId, index);
    switch (result?.result) {
      case FetchResult.success:
        return result?.content?.content;
      default:
    }
    return null;
  }

  String getFilesize(final int value) => filesize(value);

  Future<List<BoardData?>> shitarabaBoards(final String category) async {
    return await ShitarabaHandler.getBoards(category);
  }

  void clearForumThreads(final Communities forum) {
    _selectedForum(forum)?.clear();
  }

  void setForumSettings(final ForumSettingsData value) {
    _selectedForum(value.forum)?.setSettings(value);
  }

  void setThreadData(final ThreadMarkData value) {
    _selectedForum(value.type)?.history.setLog(value);
  }

  void setTemplateData(final TemplateData? value) {
    logger.d('setTemplate: ${value?.forum}, ${value?.bodys}, ');
    _selectedForum(value?.forum)?.setTemplateData(value);
  }

  Future<void> deleteTemplate(
      final InputCommentFields field, final String value) async {
    await selectedForumState?.deleteTemplate(field, value);
  }

  Future<void> clearTemplate(final InputCommentFields field) async {
    await selectedForumState?.clearTemplate(field);
  }

  void deleteThreadData(final ThreadMarkData value) =>
      _selectedForum(value.type)?.deleteContent(value);

  // String shitarabaFavoriteBoardStr(
  //   final String category,
  //   final String boardId,
  // ) =>
  //     ShitarabaData.favoriteBoardStr(category: category, boardId: boardId);

  // String shitarabaEmoji(final String categoryId) =>
  //     ShitarabaData.categoryEmoji(categoryId);

  // void setInstanceData(
  //     {required final bool isIos,
  //     required final bool isAndroid,
  //     required final bool isWindows,
  //     required final bool isMacOs,
  //     required final bool isLinux,
  //     required final bool isWeb,
  //     required final bool debugmode,
  //     required final String malId}) {
  //   PlatformData.instance.setData(
  //       iOS: isIos,
  //       android: isAndroid,
  //       windows: isWindows,
  //       mac: isMacOs,
  //       linux: isLinux,
  //       web: isWeb,
  //       debug: debugmode);
  //   MalData.instance.set(malId);
  // }

  Future<void> openget() async {
    logger.i('open2ch');
    if (PlatformData.instance.isDebugMode) {
      // await YoutubeHandler.getTrends();
    }
  }
}
