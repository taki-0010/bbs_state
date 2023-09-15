// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ForumState on ForumStateBase, Store {
  Computed<int>? _$currentTotalComputed;

  @override
  int get currentTotal =>
      (_$currentTotalComputed ??= Computed<int>(() => super.currentTotal,
              name: 'ForumStateBase.currentTotal'))
          .value;
  Computed<ThreadMarkData?>? _$currentContentThreadDataComputed;

  @override
  ThreadMarkData? get currentContentThreadData =>
      (_$currentContentThreadDataComputed ??= Computed<ThreadMarkData?>(
              () => super.currentContentThreadData,
              name: 'ForumStateBase.currentContentThreadData'))
          .value;
  Computed<int?>? _$currentContentDiffComputed;

  @override
  int? get currentContentDiff => (_$currentContentDiffComputed ??=
          Computed<int?>(() => super.currentContentDiff,
              name: 'ForumStateBase.currentContentDiff'))
      .value;
  Computed<BottomMenu>? _$currentScreenComputed;

  @override
  BottomMenu get currentScreen => (_$currentScreenComputed ??=
          Computed<BottomMenu>(() => super.currentScreen,
              name: 'ForumStateBase.currentScreen'))
      .value;
  Computed<String?>? _$selectedFontsComputed;

  @override
  String? get selectedFonts =>
      (_$selectedFontsComputed ??= Computed<String?>(() => super.selectedFonts,
              name: 'ForumStateBase.selectedFonts'))
          .value;
  Computed<ThemeList>? _$selectedThemeComputed;

  @override
  ThemeList get selectedTheme => (_$selectedThemeComputed ??=
          Computed<ThemeList>(() => super.selectedTheme,
              name: 'ForumStateBase.selectedTheme'))
      .value;
  Computed<RetentionPeriodList>? _$retentionPeriodComputed;

  @override
  RetentionPeriodList get retentionPeriod => (_$retentionPeriodComputed ??=
          Computed<RetentionPeriodList>(() => super.retentionPeriod,
              name: 'ForumStateBase.retentionPeriod'))
      .value;
  Computed<double>? _$getBoardsScrollTotalComputed;

  @override
  double get getBoardsScrollTotal => (_$getBoardsScrollTotalComputed ??=
          Computed<double>(() => super.getBoardsScrollTotal,
              name: 'ForumStateBase.getBoardsScrollTotal'))
      .value;
  Computed<ContentState?>? _$currentContentStateComputed;

  @override
  ContentState? get currentContentState => (_$currentContentStateComputed ??=
          Computed<ContentState?>(() => super.currentContentState,
              name: 'ForumStateBase.currentContentState'))
      .value;
  Computed<bool>? _$contentLoadingComputed;

  @override
  bool get contentLoading =>
      (_$contentLoadingComputed ??= Computed<bool>(() => super.contentLoading,
              name: 'ForumStateBase.contentLoading'))
          .value;
  Computed<ThreadContentData?>? _$currentContentComputed;

  @override
  ThreadContentData? get currentContent => (_$currentContentComputed ??=
          Computed<ThreadContentData?>(() => super.currentContent,
              name: 'ForumStateBase.currentContent'))
      .value;
  Computed<List<ImportanceData?>>? _$getCurrentImportanceListComputed;

  @override
  List<ImportanceData?> get getCurrentImportanceList =>
      (_$getCurrentImportanceListComputed ??= Computed<List<ImportanceData?>>(
              () => super.getCurrentImportanceList,
              name: 'ForumStateBase.getCurrentImportanceList'))
          .value;
  Computed<List<ThreadBase?>>? _$historyListComputed;

  @override
  List<ThreadBase?> get historyList => (_$historyListComputed ??=
          Computed<List<ThreadBase?>>(() => super.historyList,
              name: 'ForumStateBase.historyList'))
      .value;
  Computed<List<ThreadBase?>>? _$searchListComputed;

  @override
  List<ThreadBase?> get searchList => (_$searchListComputed ??=
          Computed<List<ThreadBase?>>(() => super.searchList,
              name: 'ForumStateBase.searchList'))
      .value;
  Computed<String>? _$appBarTitleComputed;

  @override
  String get appBarTitle =>
      (_$appBarTitleComputed ??= Computed<String>(() => super.appBarTitle,
              name: 'ForumStateBase.appBarTitle'))
          .value;
  Computed<PrimaryViewState>? _$_primaryViewStateComputed;

  @override
  PrimaryViewState get _primaryViewState => (_$_primaryViewStateComputed ??=
          Computed<PrimaryViewState>(() => super._primaryViewState,
              name: 'ForumStateBase._primaryViewState'))
      .value;

  late final _$settingsAtom =
      Atom(name: 'ForumStateBase.settings', context: context);

  @override
  ForumSettingsData? get settings {
    _$settingsAtom.reportRead();
    return super.settings;
  }

  @override
  set settings(ForumSettingsData? value) {
    _$settingsAtom.reportWrite(value, super.settings, () {
      super.settings = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: 'ForumStateBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$boardsScrollAtom =
      Atom(name: 'ForumStateBase.boardsScroll', context: context);

  @override
  double get boardsScroll {
    _$boardsScrollAtom.reportRead();
    return super.boardsScroll;
  }

  @override
  set boardsScroll(double value) {
    _$boardsScrollAtom.reportWrite(value, super.boardsScroll, () {
      super.boardsScroll = value;
    });
  }

  late final _$setContentAsyncAction =
      AsyncAction('ForumStateBase.setContent', context: context);

  @override
  Future<bool> setContent(String id, {required ThreadBase thread}) {
    return _$setContentAsyncAction
        .run(() => super.setContent(id, thread: thread));
  }

  late final _$_getDataAsyncAction =
      AsyncAction('ForumStateBase._getData', context: context);

  @override
  Future<ThreadContentData?> _getData<T extends ThreadBase>(String dataId,
      {required T thread, PositionToGet? positionToGet}) {
    return _$_getDataAsyncAction.run(() => super
        ._getData<T>(dataId, thread: thread, positionToGet: positionToGet));
  }

  late final _$_getContentForFiveChAsyncAction =
      AsyncAction('ForumStateBase._getContentForFiveCh', context: context);

  @override
  Future<(List<FiveChThreadContentData>?, bool)> _getContentForFiveCh(String id,
      {required String domain, required String directoryName}) {
    return _$_getContentForFiveChAsyncAction.run(() => super
        ._getContentForFiveCh(id,
            domain: domain, directoryName: directoryName));
  }

  late final _$_getContentForGirlsChAsyncAction =
      AsyncAction('ForumStateBase._getContentForGirlsCh', context: context);

  @override
  Future<(List<GirlsChContent?>?, int)?> _getContentForGirlsCh(String id,
      {required PositionToGet positionToGet}) {
    return _$_getContentForGirlsChAsyncAction.run(
        () => super._getContentForGirlsCh(id, positionToGet: positionToGet));
  }

  late final _$_getContentForFutabaChAsyncAction =
      AsyncAction('ForumStateBase._getContentForFutabaCh', context: context);

  @override
  Future<List<FutabaChContent?>?> _getContentForFutabaCh(
      {required String url, required String directory}) {
    return _$_getContentForFutabaChAsyncAction.run(
        () => super._getContentForFutabaCh(url: url, directory: directory));
  }

  late final _$ForumStateBaseActionController =
      ActionController(name: 'ForumStateBase', context: context);

  @override
  void computeBoardScrol(double? value) {
    final _$actionInfo = _$ForumStateBaseActionController.startAction(
        name: 'ForumStateBase.computeBoardScrol');
    try {
      return super.computeBoardScrol(value);
    } finally {
      _$ForumStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSettings(ForumSettingsData value) {
    final _$actionInfo = _$ForumStateBaseActionController.startAction(
        name: 'ForumStateBase.setSettings');
    try {
      return super.setSettings(value);
    } finally {
      _$ForumStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setContent(ThreadContentData value) {
    final _$actionInfo = _$ForumStateBaseActionController.startAction(
        name: 'ForumStateBase._setContent');
    try {
      return super._setContent(value);
    } finally {
      _$ForumStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _updateContent(ThreadContentData value) {
    final _$actionInfo = _$ForumStateBaseActionController.startAction(
        name: 'ForumStateBase._updateContent');
    try {
      return super._updateContent(value);
    } finally {
      _$ForumStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void disposeNonLargeContent() {
    final _$actionInfo = _$ForumStateBaseActionController.startAction(
        name: 'ForumStateBase.disposeNonLargeContent');
    try {
      return super.disposeNonLargeContent();
    } finally {
      _$ForumStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
settings: ${settings},
loading: ${loading},
boardsScroll: ${boardsScroll},
currentTotal: ${currentTotal},
currentContentThreadData: ${currentContentThreadData},
currentContentDiff: ${currentContentDiff},
currentScreen: ${currentScreen},
selectedFonts: ${selectedFonts},
selectedTheme: ${selectedTheme},
retentionPeriod: ${retentionPeriod},
getBoardsScrollTotal: ${getBoardsScrollTotal},
currentContentState: ${currentContentState},
contentLoading: ${contentLoading},
currentContent: ${currentContent},
getCurrentImportanceList: ${getCurrentImportanceList},
historyList: ${historyList},
searchList: ${searchList},
appBarTitle: ${appBarTitle}
    ''';
  }
}
