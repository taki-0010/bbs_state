// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MainStore on MainStoreBase, Store {
  Computed<bool?>? _$getYtChannelOrPlayListComputed;

  @override
  bool? get getYtChannelOrPlayList => (_$getYtChannelOrPlayListComputed ??=
          Computed<bool?>(() => super.getYtChannelOrPlayList,
              name: 'MainStoreBase.getYtChannelOrPlayList'))
      .value;
  Computed<bool>? _$openedMenuComputed;

  @override
  bool get openedMenu =>
      (_$openedMenuComputed ??= Computed<bool>(() => super.openedMenu,
              name: 'MainStoreBase.openedMenu'))
          .value;
  Computed<bool>? _$disableSearchComputed;

  @override
  bool get disableSearch =>
      (_$disableSearchComputed ??= Computed<bool>(() => super.disableSearch,
              name: 'MainStoreBase.disableSearch'))
          .value;
  Computed<String?>? _$snackMessageComputed;

  @override
  String? get snackMessage =>
      (_$snackMessageComputed ??= Computed<String?>(() => super.snackMessage,
              name: 'MainStoreBase.snackMessage'))
          .value;
  Computed<AutoDownloadableSizeLimit>? _$autoDownloadableSizeLimitComputed;

  @override
  AutoDownloadableSizeLimit get autoDownloadableSizeLimit =>
      (_$autoDownloadableSizeLimitComputed ??=
              Computed<AutoDownloadableSizeLimit>(
                  () => super.autoDownloadableSizeLimit,
                  name: 'MainStoreBase.autoDownloadableSizeLimit'))
          .value;
  Computed<bool>? _$showHistoryUpdateButtonComputed;

  @override
  bool get showHistoryUpdateButton => (_$showHistoryUpdateButtonComputed ??=
          Computed<bool>(() => super.showHistoryUpdateButton,
              name: 'MainStoreBase.showHistoryUpdateButton'))
      .value;
  Computed<bool>? _$insertAdComputed;

  @override
  bool get insertAd => (_$insertAdComputed ??=
          Computed<bool>(() => super.insertAd, name: 'MainStoreBase.insertAd'))
      .value;
  Computed<bool>? _$contentLoadingComputed;

  @override
  bool get contentLoading =>
      (_$contentLoadingComputed ??= Computed<bool>(() => super.contentLoading,
              name: 'MainStoreBase.contentLoading'))
          .value;
  Computed<int?>? _$selectedForumIndexComputed;

  @override
  int? get selectedForumIndex => (_$selectedForumIndexComputed ??=
          Computed<int?>(() => super.selectedForumIndex,
              name: 'MainStoreBase.selectedForumIndex'))
      .value;
  Computed<ThreadMarkData?>? _$currentContentThreadDataComputed;

  @override
  ThreadMarkData? get currentContentThreadData =>
      (_$currentContentThreadDataComputed ??= Computed<ThreadMarkData?>(
              () => super.currentContentThreadData,
              name: 'MainStoreBase.currentContentThreadData'))
          .value;
  Computed<int?>? _$currentContentLastReadAtComputed;

  @override
  int? get currentContentLastReadAt => (_$currentContentLastReadAtComputed ??=
          Computed<int?>(() => super.currentContentLastReadAt,
              name: 'MainStoreBase.currentContentLastReadAt'))
      .value;
  Computed<ContentState?>? _$currentContentStateComputed;

  @override
  ContentState? get currentContentState => (_$currentContentStateComputed ??=
          Computed<ContentState?>(() => super.currentContentState,
              name: 'MainStoreBase.currentContentState'))
      .value;
  Computed<List<ThreadData?>>? _$searchServerThreadsComputed;

  @override
  List<ThreadData?> get searchServerThreads =>
      (_$searchServerThreadsComputed ??= Computed<List<ThreadData?>>(
              () => super.searchServerThreads,
              name: 'MainStoreBase.searchServerThreads'))
          .value;
  Computed<bool>? _$showHotComputed;

  @override
  bool get showHot => (_$showHotComputed ??=
          Computed<bool>(() => super.showHot, name: 'MainStoreBase.showHot'))
      .value;
  Computed<int?>? _$lastOpenedIndexForVisibleContentComputed;

  @override
  int? get lastOpenedIndexForVisibleContent =>
      (_$lastOpenedIndexForVisibleContentComputed ??= Computed<int?>(
              () => super.lastOpenedIndexForVisibleContent,
              name: 'MainStoreBase.lastOpenedIndexForVisibleContent'))
          .value;
  Computed<Map<String, List<String?>>>? _$favoritesBoardsComputed;

  @override
  Map<String, List<String?>> get favoritesBoards =>
      (_$favoritesBoardsComputed ??= Computed<Map<String, List<String?>>>(
              () => super.favoritesBoards,
              name: 'MainStoreBase.favoritesBoards'))
          .value;
  Computed<UserData?>? _$userDataComputed;

  @override
  UserData? get userData =>
      (_$userDataComputed ??= Computed<UserData?>(() => super.userData,
              name: 'MainStoreBase.userData'))
          .value;
  Computed<List<Communities>?>? _$selectedForumListComputed;

  @override
  List<Communities>? get selectedForumList => (_$selectedForumListComputed ??=
          Computed<List<Communities>?>(() => super.selectedForumList,
              name: 'MainStoreBase.selectedForumList'))
      .value;
  Computed<List<String>?>? _$selectedForumHostListComputed;

  @override
  List<String>? get selectedForumHostList =>
      (_$selectedForumHostListComputed ??= Computed<List<String>?>(
              () => super.selectedForumHostList,
              name: 'MainStoreBase.selectedForumHostList'))
          .value;
  Computed<LangList>? _$getLocaleComputed;

  @override
  LangList get getLocale =>
      (_$getLocaleComputed ??= Computed<LangList>(() => super.getLocale,
              name: 'MainStoreBase.getLocale'))
          .value;
  Computed<List<String?>>? _$fontsListComputed;

  @override
  List<String?> get fontsList =>
      (_$fontsListComputed ??= Computed<List<String?>>(() => super.fontsList,
              name: 'MainStoreBase.fontsList'))
          .value;
  Computed<ForumState?>? _$selectedForumStateComputed;

  @override
  ForumState? get selectedForumState => (_$selectedForumStateComputed ??=
          Computed<ForumState?>(() => super.selectedForumState,
              name: 'MainStoreBase.selectedForumState'))
      .value;
  Computed<ThemeList>? _$selectedThemeComputed;

  @override
  ThemeList get selectedTheme => (_$selectedThemeComputed ??=
          Computed<ThemeList>(() => super.selectedTheme,
              name: 'MainStoreBase.selectedTheme'))
      .value;
  Computed<ThreadsOrderType>? _$currentThreadsOrderComputed;

  @override
  ThreadsOrderType get currentThreadsOrder => (_$currentThreadsOrderComputed ??=
          Computed<ThreadsOrderType>(() => super.currentThreadsOrder,
              name: 'MainStoreBase.currentThreadsOrder'))
      .value;
  Computed<TimeagoList>? _$currentTimeagoComputed;

  @override
  TimeagoList get currentTimeago => (_$currentTimeagoComputed ??=
          Computed<TimeagoList>(() => super.currentTimeago,
              name: 'MainStoreBase.currentTimeago'))
      .value;
  Computed<ListViewStyle>? _$currentViewStyleComputed;

  @override
  ListViewStyle get currentViewStyle => (_$currentViewStyleComputed ??=
          Computed<ListViewStyle>(() => super.currentViewStyle,
              name: 'MainStoreBase.currentViewStyle'))
      .value;
  Computed<AutoDownloadableSizeLimit>? _$currentAutoDLSizeLimitComputed;

  @override
  AutoDownloadableSizeLimit get currentAutoDLSizeLimit =>
      (_$currentAutoDLSizeLimitComputed ??= Computed<AutoDownloadableSizeLimit>(
              () => super.currentAutoDLSizeLimit,
              name: 'MainStoreBase.currentAutoDLSizeLimit'))
          .value;
  Computed<MovedToLastThreads>? _$currentMovedToLastThreadComputed;

  @override
  MovedToLastThreads get currentMovedToLastThread =>
      (_$currentMovedToLastThreadComputed ??= Computed<MovedToLastThreads>(
              () => super.currentMovedToLastThread,
              name: 'MainStoreBase.currentMovedToLastThread'))
          .value;
  Computed<bool>? _$blurThumbnailComputed;

  @override
  bool get blurThumbnail =>
      (_$blurThumbnailComputed ??= Computed<bool>(() => super.blurThumbnail,
              name: 'MainStoreBase.blurThumbnail'))
          .value;
  Computed<bool>? _$enableNsfwComputed;

  @override
  bool get enableNsfw =>
      (_$enableNsfwComputed ??= Computed<bool>(() => super.enableNsfw,
              name: 'MainStoreBase.enableNsfw'))
          .value;
  Computed<bool>? _$saveLastUsedNameComputed;

  @override
  bool get saveLastUsedName => (_$saveLastUsedNameComputed ??= Computed<bool>(
          () => super.saveLastUsedName,
          name: 'MainStoreBase.saveLastUsedName'))
      .value;
  Computed<bool>? _$saveLastUsedEmailComputed;

  @override
  bool get saveLastUsedEmail => (_$saveLastUsedEmailComputed ??= Computed<bool>(
          () => super.saveLastUsedEmail,
          name: 'MainStoreBase.saveLastUsedEmail'))
      .value;
  Computed<bool>? _$saveLastUsedSubjectComputed;

  @override
  bool get saveLastUsedSubject => (_$saveLastUsedSubjectComputed ??=
          Computed<bool>(() => super.saveLastUsedSubject,
              name: 'MainStoreBase.saveLastUsedSubject'))
      .value;
  Computed<String?>? _$lastUsedNameComputed;

  @override
  String? get lastUsedName =>
      (_$lastUsedNameComputed ??= Computed<String?>(() => super.lastUsedName,
              name: 'MainStoreBase.lastUsedName'))
          .value;
  Computed<String?>? _$lastUsedEmailComputed;

  @override
  String? get lastUsedEmail =>
      (_$lastUsedEmailComputed ??= Computed<String?>(() => super.lastUsedEmail,
              name: 'MainStoreBase.lastUsedEmail'))
          .value;
  Computed<String?>? _$lastUsedSubjectComputed;

  @override
  String? get lastUsedSubject => (_$lastUsedSubjectComputed ??=
          Computed<String?>(() => super.lastUsedSubject,
              name: 'MainStoreBase.lastUsedSubject'))
      .value;
  Computed<ThreadContentData?>? _$currentContentComputed;

  @override
  ThreadContentData? get currentContent => (_$currentContentComputed ??=
          Computed<ThreadContentData?>(() => super.currentContent,
              name: 'MainStoreBase.currentContent'))
      .value;
  Computed<bool>? _$currentMainThreadsLoadingComputed;

  @override
  bool get currentMainThreadsLoading => (_$currentMainThreadsLoadingComputed ??=
          Computed<bool>(() => super.currentMainThreadsLoading,
              name: 'MainStoreBase.currentMainThreadsLoading'))
      .value;
  Computed<bool>? _$currentHistoryThreadsLoadingComputed;

  @override
  bool get currentHistoryThreadsLoading =>
      (_$currentHistoryThreadsLoadingComputed ??= Computed<bool>(
              () => super.currentHistoryThreadsLoading,
              name: 'MainStoreBase.currentHistoryThreadsLoading'))
          .value;
  Computed<bool>? _$currentSearchThreadsLoadingComputed;

  @override
  bool get currentSearchThreadsLoading =>
      (_$currentSearchThreadsLoadingComputed ??= Computed<bool>(
              () => super.currentSearchThreadsLoading,
              name: 'MainStoreBase.currentSearchThreadsLoading'))
          .value;
  Computed<bool>? _$currentSecondaryThreadsLoadingComputed;

  @override
  bool get currentSecondaryThreadsLoading =>
      (_$currentSecondaryThreadsLoadingComputed ??= Computed<bool>(
              () => super.currentSecondaryThreadsLoading,
              name: 'MainStoreBase.currentSecondaryThreadsLoading'))
          .value;
  Computed<String?>? _$selectedFontsComputed;

  @override
  String? get selectedFonts =>
      (_$selectedFontsComputed ??= Computed<String?>(() => super.selectedFonts,
              name: 'MainStoreBase.selectedFonts'))
          .value;
  Computed<List<ImportanceData?>>? _$currentForumVeryImpListComputed;

  @override
  List<ImportanceData?> get currentForumVeryImpList =>
      (_$currentForumVeryImpListComputed ??= Computed<List<ImportanceData?>>(
              () => super.currentForumVeryImpList,
              name: 'MainStoreBase.currentForumVeryImpList'))
          .value;
  Computed<List<ImportanceData?>>? _$currentForumImpListComputed;

  @override
  List<ImportanceData?> get currentForumImpList =>
      (_$currentForumImpListComputed ??= Computed<List<ImportanceData?>>(
              () => super.currentForumImpList,
              name: 'MainStoreBase.currentForumImpList'))
          .value;
  Computed<List<ImportanceData?>>? _$currentForumUnimpListComputed;

  @override
  List<ImportanceData?> get currentForumUnimpList =>
      (_$currentForumUnimpListComputed ??= Computed<List<ImportanceData?>>(
              () => super.currentForumUnimpList,
              name: 'MainStoreBase.currentForumUnimpList'))
          .value;
  Computed<List<ImportanceData?>>? _$currentForumVeryUnimpListComputed;

  @override
  List<ImportanceData?> get currentForumVeryUnimpList =>
      (_$currentForumVeryUnimpListComputed ??= Computed<List<ImportanceData?>>(
              () => super.currentForumVeryUnimpList,
              name: 'MainStoreBase.currentForumVeryUnimpList'))
          .value;
  Computed<List<GroupData?>>? _$currentGroupListComputed;

  @override
  List<GroupData?> get currentGroupList => (_$currentGroupListComputed ??=
          Computed<List<GroupData?>>(() => super.currentGroupList,
              name: 'MainStoreBase.currentGroupList'))
      .value;
  Computed<List<String?>>? _$currentFavoritesBoardsComputed;

  @override
  List<String?> get currentFavoritesBoards =>
      (_$currentFavoritesBoardsComputed ??= Computed<List<String?>>(
              () => super.currentFavoritesBoards,
              name: 'MainStoreBase.currentFavoritesBoards'))
          .value;
  Computed<RetentionPeriodList>? _$retentionPeriodComputed;

  @override
  RetentionPeriodList get retentionPeriod => (_$retentionPeriodComputed ??=
          Computed<RetentionPeriodList>(() => super.retentionPeriod,
              name: 'MainStoreBase.retentionPeriod'))
      .value;
  Computed<bool>? _$userFavoritesBoardsComputed;

  @override
  bool get userFavoritesBoards => (_$userFavoritesBoardsComputed ??=
          Computed<bool>(() => super.userFavoritesBoards,
              name: 'MainStoreBase.userFavoritesBoards'))
      .value;
  Computed<SortHistoryList>? _$sortHistoryComputed;

  @override
  SortHistoryList get sortHistory => (_$sortHistoryComputed ??=
          Computed<SortHistoryList>(() => super.sortHistory,
              name: 'MainStoreBase.sortHistory'))
      .value;
  Computed<TemplateData?>? _$templateDataComputed;

  @override
  TemplateData? get templateData => (_$templateDataComputed ??=
          Computed<TemplateData?>(() => super.templateData,
              name: 'MainStoreBase.templateData'))
      .value;
  Computed<Map<String, int>>? _$historyDiffComputed;

  @override
  Map<String, int> get historyDiff => (_$historyDiffComputed ??=
          Computed<Map<String, int>>(() => super.historyDiff,
              name: 'MainStoreBase.historyDiff'))
      .value;
  Computed<String?>? _$currentBoardUrlComputed;

  @override
  String? get currentBoardUrl => (_$currentBoardUrlComputed ??=
          Computed<String?>(() => super.currentBoardUrl,
              name: 'MainStoreBase.currentBoardUrl'))
      .value;
  Computed<String?>? _$currentBoardIdComputed;

  @override
  String? get currentBoardId => (_$currentBoardIdComputed ??= Computed<String?>(
          () => super.currentBoardId,
          name: 'MainStoreBase.currentBoardId'))
      .value;
  Computed<Set<String?>>? _$boardIdSetOfForLibraryComputed;

  @override
  Set<String?> get boardIdSetOfForLibrary =>
      (_$boardIdSetOfForLibraryComputed ??= Computed<Set<String?>>(
              () => super.boardIdSetOfForLibrary,
              name: 'MainStoreBase.boardIdSetOfForLibrary'))
          .value;
  Computed<Map<ImportanceList, List<ImportanceData?>>>?
      _$importanceMapDataForCurrentContentComputed;

  @override
  Map<ImportanceList, List<ImportanceData?>>
      get importanceMapDataForCurrentContent =>
          (_$importanceMapDataForCurrentContentComputed ??=
                  Computed<Map<ImportanceList, List<ImportanceData?>>>(
                      () => super.importanceMapDataForCurrentContent,
                      name: 'MainStoreBase.importanceMapDataForCurrentContent'))
              .value;
  Computed<List<ThreadsOrderType>>? _$enabledOrderComputed;

  @override
  List<ThreadsOrderType> get enabledOrder => (_$enabledOrderComputed ??=
          Computed<List<ThreadsOrderType>>(() => super.enabledOrder,
              name: 'MainStoreBase.enabledOrder'))
      .value;
  Computed<List<TimeagoList>>? _$selectableTimeagoComputed;

  @override
  List<TimeagoList> get selectableTimeago => (_$selectableTimeagoComputed ??=
          Computed<List<TimeagoList>>(() => super.selectableTimeago,
              name: 'MainStoreBase.selectableTimeago'))
      .value;
  Computed<List<RetentionPeriodList>>? _$selectableRetentionPeriodComputed;

  @override
  List<RetentionPeriodList> get selectableRetentionPeriod =>
      (_$selectableRetentionPeriodComputed ??=
              Computed<List<RetentionPeriodList>>(
                  () => super.selectableRetentionPeriod,
                  name: 'MainStoreBase.selectableRetentionPeriod'))
          .value;
  Computed<String?>? _$boardIdForSearchComputed;

  @override
  String? get boardIdForSearch => (_$boardIdForSearchComputed ??=
          Computed<String?>(() => super.boardIdForSearch,
              name: 'MainStoreBase.boardIdForSearch'))
      .value;
  Computed<Future<List<BoardData?>?>>? _$boardListForSearchComputed;

  @override
  Future<List<BoardData?>?> get boardListForSearch =>
      (_$boardListForSearchComputed ??= Computed<Future<List<BoardData?>?>>(
              () => super.boardListForSearch,
              name: 'MainStoreBase.boardListForSearch'))
          .value;
  Computed<Future<BoardData?>>? _$boardForSearchComputed;

  @override
  Future<BoardData?> get boardForSearch => (_$boardForSearchComputed ??=
          Computed<Future<BoardData?>>(() => super.boardForSearch,
              name: 'MainStoreBase.boardForSearch'))
      .value;
  Computed<ThreadContentData?>? _$selectedHistoryDataComputed;

  @override
  ThreadContentData? get selectedHistoryData =>
      (_$selectedHistoryDataComputed ??= Computed<ThreadContentData?>(
              () => super.selectedHistoryData,
              name: 'MainStoreBase.selectedHistoryData'))
          .value;
  Computed<PrimaryViewState>? _$selectedForumPrimaryBodyComputed;

  @override
  PrimaryViewState get selectedForumPrimaryBody =>
      (_$selectedForumPrimaryBodyComputed ??= Computed<PrimaryViewState>(
              () => super.selectedForumPrimaryBody,
              name: 'MainStoreBase.selectedForumPrimaryBody'))
          .value;
  Computed<BottomMenu>? _$currentScreenComputed;

  @override
  BottomMenu get currentScreen => (_$currentScreenComputed ??=
          Computed<BottomMenu>(() => super.currentScreen,
              name: 'MainStoreBase.currentScreen'))
      .value;
  Computed<List<bool>>? _$secondaryBodyToggleValueComputed;

  @override
  List<bool> get secondaryBodyToggleValue =>
      (_$secondaryBodyToggleValueComputed ??= Computed<List<bool>>(
              () => super.secondaryBodyToggleValue,
              name: 'MainStoreBase.secondaryBodyToggleValue'))
          .value;
  Computed<String>? _$secondaryAppBarTitleComputed;

  @override
  String get secondaryAppBarTitle => (_$secondaryAppBarTitleComputed ??=
          Computed<String>(() => super.secondaryAppBarTitle,
              name: 'MainStoreBase.secondaryAppBarTitle'))
      .value;
  Computed<PrimaryViewState>? _$primaryHistoryViewComputed;

  @override
  PrimaryViewState get primaryHistoryView => (_$primaryHistoryViewComputed ??=
          Computed<PrimaryViewState>(() => super.primaryHistoryView,
              name: 'MainStoreBase.primaryHistoryView'))
      .value;
  Computed<PrimaryViewState>? _$primarySearchViewComputed;

  @override
  PrimaryViewState get primarySearchView => (_$primarySearchViewComputed ??=
          Computed<PrimaryViewState>(() => super.primarySearchView,
              name: 'MainStoreBase.primarySearchView'))
      .value;
  Computed<PrimaryViewState?>? _$prymaryViewStateComputed;

  @override
  PrimaryViewState? get prymaryViewState => (_$prymaryViewStateComputed ??=
          Computed<PrimaryViewState?>(() => super.prymaryViewState,
              name: 'MainStoreBase.prymaryViewState'))
      .value;
  Computed<int?>? _$currentContentDiffComputed;

  @override
  int? get currentContentDiff => (_$currentContentDiffComputed ??=
          Computed<int?>(() => super.currentContentDiff,
              name: 'MainStoreBase.currentContentDiff'))
      .value;
  Computed<String>? _$appBarTitleComputed;

  @override
  String get appBarTitle =>
      (_$appBarTitleComputed ??= Computed<String>(() => super.appBarTitle,
              name: 'MainStoreBase.appBarTitle'))
          .value;
  Computed<List<ThreadBase?>>? _$historyListComputed;

  @override
  List<ThreadBase?> get historyList => (_$historyListComputed ??=
          Computed<List<ThreadBase?>>(() => super.historyList,
              name: 'MainStoreBase.historyList'))
      .value;
  Computed<Map<String, List<ThreadBase?>?>>? _$listByBoardIdComputed;

  @override
  Map<String, List<ThreadBase?>?> get listByBoardId =>
      (_$listByBoardIdComputed ??= Computed<Map<String, List<ThreadBase?>?>>(
              () => super.listByBoardId,
              name: 'MainStoreBase.listByBoardId'))
          .value;
  Computed<Map<String, List<ThreadBase?>?>>? _$currentHistoryListComputed;

  @override
  Map<String, List<ThreadBase?>?> get currentHistoryList =>
      (_$currentHistoryListComputed ??=
              Computed<Map<String, List<ThreadBase?>?>>(
                  () => super.currentHistoryList,
                  name: 'MainStoreBase.currentHistoryList'))
          .value;
  Computed<Map<String, List<ThreadBase?>?>>? _$currentSearchListComputed;

  @override
  Map<String, List<ThreadBase?>?> get currentSearchList =>
      (_$currentSearchListComputed ??=
              Computed<Map<String, List<ThreadBase?>?>>(
                  () => super.currentSearchList,
                  name: 'MainStoreBase.currentSearchList'))
          .value;
  Computed<List<ThreadBase?>>? _$searchListComputed;

  @override
  List<ThreadBase?> get searchList => (_$searchListComputed ??=
          Computed<List<ThreadBase?>>(() => super.searchList,
              name: 'MainStoreBase.searchList'))
      .value;
  Computed<bool>? _$showSearchWordChipOnPrimaryComputed;

  @override
  bool get showSearchWordChipOnPrimary =>
      (_$showSearchWordChipOnPrimaryComputed ??= Computed<bool>(
              () => super.showSearchWordChipOnPrimary,
              name: 'MainStoreBase.showSearchWordChipOnPrimary'))
          .value;
  Computed<bool>? _$showNextButtonForForumComputed;

  @override
  bool get showNextButtonForForum => (_$showNextButtonForForumComputed ??=
          Computed<bool>(() => super.showNextButtonForForum,
              name: 'MainStoreBase.showNextButtonForForum'))
      .value;
  Computed<bool>? _$hideUpdateThreadsButtonComputed;

  @override
  bool get hideUpdateThreadsButton => (_$hideUpdateThreadsButtonComputed ??=
          Computed<bool>(() => super.hideUpdateThreadsButton,
              name: 'MainStoreBase.hideUpdateThreadsButton'))
      .value;
  Computed<bool>? _$showNextButtonForSearchComputed;

  @override
  bool get showNextButtonForSearch => (_$showNextButtonForSearchComputed ??=
          Computed<bool>(() => super.showNextButtonForSearch,
              name: 'MainStoreBase.showNextButtonForSearch'))
      .value;
  Computed<String?>? _$mainSearchWordComputed;

  @override
  String? get mainSearchWord => (_$mainSearchWordComputed ??= Computed<String?>(
          () => super.mainSearchWord,
          name: 'MainStoreBase.mainSearchWord'))
      .value;
  Computed<String?>? _$searchScreenWordComputed;

  @override
  String? get searchScreenWord => (_$searchScreenWordComputed ??=
          Computed<String?>(() => super.searchScreenWord,
              name: 'MainStoreBase.searchScreenWord'))
      .value;
  Computed<String?>? _$postOnSiteUrlComputed;

  @override
  String? get postOnSiteUrl =>
      (_$postOnSiteUrlComputed ??= Computed<String?>(() => super.postOnSiteUrl,
              name: 'MainStoreBase.postOnSiteUrl'))
          .value;
  Computed<String?>? _$getDefaultNameComputed;

  @override
  String? get getDefaultName => (_$getDefaultNameComputed ??= Computed<String?>(
          () => super.getDefaultName,
          name: 'MainStoreBase.getDefaultName'))
      .value;
  Computed<List<String?>>? _$searchWordsComputed;

  @override
  List<String?> get searchWords => (_$searchWordsComputed ??=
          Computed<List<String?>>(() => super.searchWords,
              name: 'MainStoreBase.searchWords'))
      .value;
  Computed<PrimaryViewState>? _$searchViewStateComputed;

  @override
  PrimaryViewState get searchViewState => (_$searchViewStateComputed ??=
          Computed<PrimaryViewState>(() => super.searchViewState,
              name: 'MainStoreBase.searchViewState'))
      .value;

  late final _$forumsAtom =
      Atom(name: 'MainStoreBase.forums', context: context);

  @override
  ObservableList<ForumState?> get forums {
    _$forumsAtom.reportRead();
    return super.forums;
  }

  @override
  set forums(ObservableList<ForumState?> value) {
    _$forumsAtom.reportWrite(value, super.forums, () {
      super.forums = value;
    });
  }

  late final _$launchStatusAtom =
      Atom(name: 'MainStoreBase.launchStatus', context: context);

  @override
  LaunchStatus get launchStatus {
    _$launchStatusAtom.reportRead();
    return super.launchStatus;
  }

  @override
  set launchStatus(LaunchStatus value) {
    _$launchStatusAtom.reportWrite(value, super.launchStatus, () {
      super.launchStatus = value;
    });
  }

  late final _$devModeAtom =
      Atom(name: 'MainStoreBase.devMode', context: context);

  @override
  bool get devMode {
    _$devModeAtom.reportRead();
    return super.devMode;
  }

  @override
  set devMode(bool value) {
    _$devModeAtom.reportWrite(value, super.devMode, () {
      super.devMode = value;
    });
  }

  late final _$devModeCountAtom =
      Atom(name: 'MainStoreBase.devModeCount', context: context);

  @override
  int get devModeCount {
    _$devModeCountAtom.reportRead();
    return super.devModeCount;
  }

  @override
  set devModeCount(int value) {
    _$devModeCountAtom.reportWrite(value, super.devModeCount, () {
      super.devModeCount = value;
    });
  }

  late final _$debugLogAtom =
      Atom(name: 'MainStoreBase.debugLog', context: context);

  @override
  ObservableList<String?> get debugLog {
    _$debugLogAtom.reportRead();
    return super.debugLog;
  }

  @override
  set debugLog(ObservableList<String?> value) {
    _$debugLogAtom.reportWrite(value, super.debugLog, () {
      super.debugLog = value;
    });
  }

  late final _$overlayIdAtom =
      Atom(name: 'MainStoreBase.overlayId', context: context);

  @override
  String? get overlayId {
    _$overlayIdAtom.reportRead();
    return super.overlayId;
  }

  @override
  set overlayId(String? value) {
    _$overlayIdAtom.reportWrite(value, super.overlayId, () {
      super.overlayId = value;
    });
  }

  late final _$playerAtom =
      Atom(name: 'MainStoreBase.player', context: context);

  @override
  PlayerState? get player {
    _$playerAtom.reportRead();
    return super.player;
  }

  @override
  set player(PlayerState? value) {
    _$playerAtom.reportWrite(value, super.player, () {
      super.player = value;
    });
  }

  late final _$enableAdAtom =
      Atom(name: 'MainStoreBase.enableAd', context: context);

  @override
  bool get enableAd {
    _$enableAdAtom.reportRead();
    return super.enableAd;
  }

  @override
  set enableAd(bool value) {
    _$enableAdAtom.reportWrite(value, super.enableAd, () {
      super.enableAd = value;
    });
  }

  late final _$largeScreenAtom =
      Atom(name: 'MainStoreBase.largeScreen', context: context);

  @override
  bool get largeScreen {
    _$largeScreenAtom.reportRead();
    return super.largeScreen;
  }

  @override
  set largeScreen(bool value) {
    _$largeScreenAtom.reportWrite(value, super.largeScreen, () {
      super.largeScreen = value;
    });
  }

  late final _$entireLoadingAtom =
      Atom(name: 'MainStoreBase.entireLoading', context: context);

  @override
  bool get entireLoading {
    _$entireLoadingAtom.reportRead();
    return super.entireLoading;
  }

  @override
  set entireLoading(bool value) {
    _$entireLoadingAtom.reportWrite(value, super.entireLoading, () {
      super.entireLoading = value;
    });
  }

  late final _$selectedForumAtom =
      Atom(name: 'MainStoreBase.selectedForum', context: context);

  @override
  Communities? get selectedForum {
    _$selectedForumAtom.reportRead();
    return super.selectedForum;
  }

  @override
  set selectedForum(Communities? value) {
    _$selectedForumAtom.reportWrite(value, super.selectedForum, () {
      super.selectedForum = value;
    });
  }

  late final _$bottomBarIndexAtom =
      Atom(name: 'MainStoreBase.bottomBarIndex', context: context);

  @override
  int get bottomBarIndex {
    _$bottomBarIndexAtom.reportRead();
    return super.bottomBarIndex;
  }

  @override
  set bottomBarIndex(int value) {
    _$bottomBarIndexAtom.reportWrite(value, super.bottomBarIndex, () {
      super.bottomBarIndex = value;
    });
  }

  late final _$currentContentIndexAtom =
      Atom(name: 'MainStoreBase.currentContentIndex', context: context);

  @override
  int get currentContentIndex {
    _$currentContentIndexAtom.reportRead();
    return super.currentContentIndex;
  }

  @override
  set currentContentIndex(int value) {
    _$currentContentIndexAtom.reportWrite(value, super.currentContentIndex, () {
      super.currentContentIndex = value;
    });
  }

  late final _$currentContentItemIndexAtom =
      Atom(name: 'MainStoreBase.currentContentItemIndex', context: context);

  @override
  int get currentContentItemIndex {
    _$currentContentItemIndexAtom.reportRead();
    return super.currentContentItemIndex;
  }

  @override
  set currentContentItemIndex(int value) {
    _$currentContentItemIndexAtom
        .reportWrite(value, super.currentContentItemIndex, () {
      super.currentContentItemIndex = value;
    });
  }

  late final _$deletedThreadTitleAtom =
      Atom(name: 'MainStoreBase.deletedThreadTitle', context: context);

  @override
  String? get deletedThreadTitle {
    _$deletedThreadTitleAtom.reportRead();
    return super.deletedThreadTitle;
  }

  @override
  set deletedThreadTitle(String? value) {
    _$deletedThreadTitleAtom.reportWrite(value, super.deletedThreadTitle, () {
      super.deletedThreadTitle = value;
    });
  }

  late final _$addForumNameAtom =
      Atom(name: 'MainStoreBase.addForumName', context: context);

  @override
  String? get addForumName {
    _$addForumNameAtom.reportRead();
    return super.addForumName;
  }

  @override
  set addForumName(String? value) {
    _$addForumNameAtom.reportWrite(value, super.addForumName, () {
      super.addForumName = value;
    });
  }

  late final _$onOpenedPopupAtom =
      Atom(name: 'MainStoreBase.onOpenedPopup', context: context);

  @override
  bool get onOpenedPopup {
    _$onOpenedPopupAtom.reportRead();
    return super.onOpenedPopup;
  }

  @override
  set onOpenedPopup(bool value) {
    _$onOpenedPopupAtom.reportWrite(value, super.onOpenedPopup, () {
      super.onOpenedPopup = value;
    });
  }

  late final _$openedDrawerAtom =
      Atom(name: 'MainStoreBase.openedDrawer', context: context);

  @override
  bool get openedDrawer {
    _$openedDrawerAtom.reportRead();
    return super.openedDrawer;
  }

  @override
  set openedDrawer(bool value) {
    _$openedDrawerAtom.reportWrite(value, super.openedDrawer, () {
      super.openedDrawer = value;
    });
  }

  late final _$openedDialogAtom =
      Atom(name: 'MainStoreBase.openedDialog', context: context);

  @override
  bool get openedDialog {
    _$openedDialogAtom.reportRead();
    return super.openedDialog;
  }

  @override
  set openedDialog(bool value) {
    _$openedDialogAtom.reportWrite(value, super.openedDialog, () {
      super.openedDialog = value;
    });
  }

  late final _$reverseForumSwitchAnimationAtom =
      Atom(name: 'MainStoreBase.reverseForumSwitchAnimation', context: context);

  @override
  bool get reverseForumSwitchAnimation {
    _$reverseForumSwitchAnimationAtom.reportRead();
    return super.reverseForumSwitchAnimation;
  }

  @override
  set reverseForumSwitchAnimation(bool value) {
    _$reverseForumSwitchAnimationAtom
        .reportWrite(value, super.reverseForumSwitchAnimation, () {
      super.reverseForumSwitchAnimation = value;
    });
  }

  late final _$reverseAnimationForPrymaryScreenAtom = Atom(
      name: 'MainStoreBase.reverseAnimationForPrymaryScreen', context: context);

  @override
  bool get reverseAnimationForPrymaryScreen {
    _$reverseAnimationForPrymaryScreenAtom.reportRead();
    return super.reverseAnimationForPrymaryScreen;
  }

  @override
  set reverseAnimationForPrymaryScreen(bool value) {
    _$reverseAnimationForPrymaryScreenAtom
        .reportWrite(value, super.reverseAnimationForPrymaryScreen, () {
      super.reverseAnimationForPrymaryScreen = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('MainStoreBase.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$MainStoreBaseActionController =
      ActionController(name: 'MainStoreBase', context: context);

  @override
  void toggleDevMode() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.toggleDevMode');
    try {
      return super.toggleDevMode();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void devCount() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.devCount');
    try {
      return super.devCount();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOverlayId(String? id) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setOverlayId');
    try {
      return super.setOverlayId(id);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPlayer(LinkData? value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setPlayer');
    try {
      return super.setPlayer(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOnOpenedPopup() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setOnOpenedPopup');
    try {
      return super.setOnOpenedPopup();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOnClosedPopup() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setOnClosedPopup');
    try {
      return super.setOnClosedPopup();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setChangedDrawer(bool v) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setChangedDrawer');
    try {
      return super.setChangedDrawer(v);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOpenedDialog() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setOpenedDialog');
    try {
      return super.setOpenedDialog();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLog(String value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setLog');
    try {
      return super.setLog(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLaunchStatus(LaunchStatus value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setLaunchStatus');
    try {
      return super.setLaunchStatus(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleEntireLoading() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.toggleEntireLoading');
    try {
      return super.toggleEntireLoading();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setForum(Communities value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase._setForum');
    try {
      return super._setForum(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _removeForum(Communities value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase._removeForum');
    try {
      return super._removeForum(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedForum(int value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setSelectedForum');
    try {
      return super.setSelectedForum(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setBottomIndex(int value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase._setBottomIndex');
    try {
      return super._setBottomIndex(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setScreenSize(bool value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setScreenSize');
    try {
      return super.setScreenSize(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDeletedThreadTitle(String value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setDeletedThreadTitle');
    try {
      return super.setDeletedThreadTitle(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeDeletedThreadTitle() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.removeDeletedThreadTitle');
    try {
      return super.removeDeletedThreadTitle();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAddForumName(Communities value) {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.setAddForumName');
    try {
      return super.setAddForumName(value);
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeAddForumName() {
    final _$actionInfo = _$MainStoreBaseActionController.startAction(
        name: 'MainStoreBase.removeAddForumName');
    try {
      return super.removeAddForumName();
    } finally {
      _$MainStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
forums: ${forums},
launchStatus: ${launchStatus},
devMode: ${devMode},
devModeCount: ${devModeCount},
debugLog: ${debugLog},
overlayId: ${overlayId},
player: ${player},
enableAd: ${enableAd},
largeScreen: ${largeScreen},
entireLoading: ${entireLoading},
selectedForum: ${selectedForum},
bottomBarIndex: ${bottomBarIndex},
currentContentIndex: ${currentContentIndex},
currentContentItemIndex: ${currentContentItemIndex},
deletedThreadTitle: ${deletedThreadTitle},
addForumName: ${addForumName},
onOpenedPopup: ${onOpenedPopup},
openedDrawer: ${openedDrawer},
openedDialog: ${openedDialog},
reverseForumSwitchAnimation: ${reverseForumSwitchAnimation},
reverseAnimationForPrymaryScreen: ${reverseAnimationForPrymaryScreen},
getYtChannelOrPlayList: ${getYtChannelOrPlayList},
openedMenu: ${openedMenu},
disableSearch: ${disableSearch},
snackMessage: ${snackMessage},
autoDownloadableSizeLimit: ${autoDownloadableSizeLimit},
showHistoryUpdateButton: ${showHistoryUpdateButton},
insertAd: ${insertAd},
contentLoading: ${contentLoading},
selectedForumIndex: ${selectedForumIndex},
currentContentThreadData: ${currentContentThreadData},
currentContentLastReadAt: ${currentContentLastReadAt},
currentContentState: ${currentContentState},
searchServerThreads: ${searchServerThreads},
showHot: ${showHot},
lastOpenedIndexForVisibleContent: ${lastOpenedIndexForVisibleContent},
favoritesBoards: ${favoritesBoards},
userData: ${userData},
selectedForumList: ${selectedForumList},
selectedForumHostList: ${selectedForumHostList},
getLocale: ${getLocale},
fontsList: ${fontsList},
selectedForumState: ${selectedForumState},
selectedTheme: ${selectedTheme},
currentThreadsOrder: ${currentThreadsOrder},
currentTimeago: ${currentTimeago},
currentViewStyle: ${currentViewStyle},
currentAutoDLSizeLimit: ${currentAutoDLSizeLimit},
currentMovedToLastThread: ${currentMovedToLastThread},
blurThumbnail: ${blurThumbnail},
enableNsfw: ${enableNsfw},
saveLastUsedName: ${saveLastUsedName},
saveLastUsedEmail: ${saveLastUsedEmail},
saveLastUsedSubject: ${saveLastUsedSubject},
lastUsedName: ${lastUsedName},
lastUsedEmail: ${lastUsedEmail},
lastUsedSubject: ${lastUsedSubject},
currentContent: ${currentContent},
currentMainThreadsLoading: ${currentMainThreadsLoading},
currentHistoryThreadsLoading: ${currentHistoryThreadsLoading},
currentSearchThreadsLoading: ${currentSearchThreadsLoading},
currentSecondaryThreadsLoading: ${currentSecondaryThreadsLoading},
selectedFonts: ${selectedFonts},
currentForumVeryImpList: ${currentForumVeryImpList},
currentForumImpList: ${currentForumImpList},
currentForumUnimpList: ${currentForumUnimpList},
currentForumVeryUnimpList: ${currentForumVeryUnimpList},
currentGroupList: ${currentGroupList},
currentFavoritesBoards: ${currentFavoritesBoards},
retentionPeriod: ${retentionPeriod},
userFavoritesBoards: ${userFavoritesBoards},
sortHistory: ${sortHistory},
templateData: ${templateData},
historyDiff: ${historyDiff},
currentBoardUrl: ${currentBoardUrl},
currentBoardId: ${currentBoardId},
boardIdSetOfForLibrary: ${boardIdSetOfForLibrary},
importanceMapDataForCurrentContent: ${importanceMapDataForCurrentContent},
enabledOrder: ${enabledOrder},
selectableTimeago: ${selectableTimeago},
selectableRetentionPeriod: ${selectableRetentionPeriod},
boardIdForSearch: ${boardIdForSearch},
boardListForSearch: ${boardListForSearch},
boardForSearch: ${boardForSearch},
selectedHistoryData: ${selectedHistoryData},
selectedForumPrimaryBody: ${selectedForumPrimaryBody},
currentScreen: ${currentScreen},
secondaryBodyToggleValue: ${secondaryBodyToggleValue},
secondaryAppBarTitle: ${secondaryAppBarTitle},
primaryHistoryView: ${primaryHistoryView},
primarySearchView: ${primarySearchView},
prymaryViewState: ${prymaryViewState},
currentContentDiff: ${currentContentDiff},
appBarTitle: ${appBarTitle},
historyList: ${historyList},
listByBoardId: ${listByBoardId},
currentHistoryList: ${currentHistoryList},
currentSearchList: ${currentSearchList},
searchList: ${searchList},
showSearchWordChipOnPrimary: ${showSearchWordChipOnPrimary},
showNextButtonForForum: ${showNextButtonForForum},
hideUpdateThreadsButton: ${hideUpdateThreadsButton},
showNextButtonForSearch: ${showNextButtonForSearch},
mainSearchWord: ${mainSearchWord},
searchScreenWord: ${searchScreenWord},
postOnSiteUrl: ${postOnSiteUrl},
getDefaultName: ${getDefaultName},
searchWords: ${searchWords},
searchViewState: ${searchViewState}
    ''';
  }
}
