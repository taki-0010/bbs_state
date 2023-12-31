// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LibraryState on LibraryStateBase, Store {
  Computed<ForumSettingsData?>? _$settingsComputed;

  @override
  ForumSettingsData? get settings =>
      (_$settingsComputed ??= Computed<ForumSettingsData?>(() => super.settings,
              name: 'LibraryStateBase.settings'))
          .value;
  Computed<SortHistoryList>? _$sortHistoryComputed;

  @override
  SortHistoryList get sortHistory => (_$sortHistoryComputed ??=
          Computed<SortHistoryList>(() => super.sortHistory,
              name: 'LibraryStateBase.sortHistory'))
      .value;
  Computed<Set<String?>>? _$boardIdSetOfContentListComputed;

  @override
  Set<String?> get boardIdSetOfContentList =>
      (_$boardIdSetOfContentListComputed ??= Computed<Set<String?>>(
              () => super.boardIdSetOfContentList,
              name: 'LibraryStateBase.boardIdSetOfContentList'))
          .value;
  Computed<Map<String, List<ThreadMarkData?>?>>? _$markListByBoardIdComputed;

  @override
  Map<String, List<ThreadMarkData?>?> get markListByBoardId =>
      (_$markListByBoardIdComputed ??=
              Computed<Map<String, List<ThreadMarkData?>?>>(
                  () => super.markListByBoardId,
                  name: 'LibraryStateBase.markListByBoardId'))
          .value;
  Computed<Map<String, List<ThreadMarkData?>?>>? _$markListByLastReadAtComputed;

  @override
  Map<String, List<ThreadMarkData?>?> get markListByLastReadAt =>
      (_$markListByLastReadAtComputed ??=
              Computed<Map<String, List<ThreadMarkData?>?>>(
                  () => super.markListByLastReadAt,
                  name: 'LibraryStateBase.markListByLastReadAt'))
          .value;
  Computed<Map<String, List<ThreadMarkData?>?>>? _$currentHistoryListComputed;

  @override
  Map<String, List<ThreadMarkData?>?> get currentHistoryList =>
      (_$currentHistoryListComputed ??=
              Computed<Map<String, List<ThreadMarkData?>?>>(
                  () => super.currentHistoryList,
                  name: 'LibraryStateBase.currentHistoryList'))
          .value;
  Computed<String>? _$appBarTitleComputed;

  @override
  String get appBarTitle =>
      (_$appBarTitleComputed ??= Computed<String>(() => super.appBarTitle,
              name: 'LibraryStateBase.appBarTitle'))
          .value;

  late final _$contentAtom =
      Atom(name: 'LibraryStateBase.content', context: context);

  @override
  ContentState? get content {
    _$contentAtom.reportRead();
    return super.content;
  }

  @override
  set content(ContentState? value) {
    _$contentAtom.reportWrite(value, super.content, () {
      super.content = value;
    });
  }

  late final _$contentLoadingAtom =
      Atom(name: 'LibraryStateBase.contentLoading', context: context);

  @override
  bool get contentLoading {
    _$contentLoadingAtom.reportRead();
    return super.contentLoading;
  }

  @override
  set contentLoading(bool value) {
    _$contentLoadingAtom.reportWrite(value, super.contentLoading, () {
      super.contentLoading = value;
    });
  }

  late final _$threadsLoadingAtom =
      Atom(name: 'LibraryStateBase.threadsLoading', context: context);

  @override
  bool get threadsLoading {
    _$threadsLoadingAtom.reportRead();
    return super.threadsLoading;
  }

  @override
  set threadsLoading(bool value) {
    _$threadsLoadingAtom.reportWrite(value, super.threadsLoading, () {
      super.threadsLoading = value;
    });
  }

  late final _$selectedPrimaryViewAtom =
      Atom(name: 'LibraryStateBase.selectedPrimaryView', context: context);

  @override
  PrimaryViewState get selectedPrimaryView {
    _$selectedPrimaryViewAtom.reportRead();
    return super.selectedPrimaryView;
  }

  @override
  set selectedPrimaryView(PrimaryViewState value) {
    _$selectedPrimaryViewAtom.reportWrite(value, super.selectedPrimaryView, () {
      super.selectedPrimaryView = value;
    });
  }

  late final _$markListAtom =
      Atom(name: 'LibraryStateBase.markList', context: context);

  @override
  ObservableList<ThreadMarkData?> get markList {
    _$markListAtom.reportRead();
    return super.markList;
  }

  @override
  set markList(ObservableList<ThreadMarkData?> value) {
    _$markListAtom.reportWrite(value, super.markList, () {
      super.markList = value;
    });
  }

  late final _$markListDiffAtom =
      Atom(name: 'LibraryStateBase.markListDiff', context: context);

  @override
  ObservableMap<String, int> get markListDiff {
    _$markListDiffAtom.reportRead();
    return super.markListDiff;
  }

  @override
  set markListDiff(ObservableMap<String, int> value) {
    _$markListDiffAtom.reportWrite(value, super.markListDiff, () {
      super.markListDiff = value;
    });
  }

  late final _$setPrimaryViewAsyncAction =
      AsyncAction('LibraryStateBase.setPrimaryView', context: context);

  @override
  Future<void> setPrimaryView(PrimaryViewState value) {
    return _$setPrimaryViewAsyncAction.run(() => super.setPrimaryView(value));
  }

  late final _$LibraryStateBaseActionController =
      ActionController(name: 'LibraryStateBase', context: context);

  @override
  void toggleContentLoading() {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.toggleContentLoading');
    try {
      return super.toggleContentLoading();
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleThreadsLoading() {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.toggleThreadsLoading');
    try {
      return super.toggleThreadsLoading();
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLog(ThreadMarkData? value) {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.setLog');
    try {
      return super.setLog(value);
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteDiffField(String? id) {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.deleteDiffField');
    try {
      return super.deleteDiffField(id);
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void replaceContent(ContentState value) {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.replaceContent');
    try {
      return super.replaceContent(value);
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContent(ContentState? value) {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.setContent');
    try {
      return super.setContent(value);
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteData(ThreadMarkData value) {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.deleteData');
    try {
      return super.deleteData(value);
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDiffValue(String id, int value) {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.setDiffValue');
    try {
      return super.setDiffValue(id, value);
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteContentState() {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.deleteContentState');
    try {
      return super.deleteContentState();
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$LibraryStateBaseActionController.startAction(
        name: 'LibraryStateBase.clear');
    try {
      return super.clear();
    } finally {
      _$LibraryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
content: ${content},
contentLoading: ${contentLoading},
threadsLoading: ${threadsLoading},
selectedPrimaryView: ${selectedPrimaryView},
markList: ${markList},
markListDiff: ${markListDiff},
settings: ${settings},
sortHistory: ${sortHistory},
boardIdSetOfContentList: ${boardIdSetOfContentList},
markListByBoardId: ${markListByBoardId},
markListByLastReadAt: ${markListByLastReadAt},
currentHistoryList: ${currentHistoryList},
appBarTitle: ${appBarTitle}
    ''';
  }
}
