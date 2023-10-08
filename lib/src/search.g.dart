// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchState on SearchStateBase, Store {
  Computed<ForumSettingsData?>? _$settingsComputed;

  @override
  ForumSettingsData? get settings =>
      (_$settingsComputed ??= Computed<ForumSettingsData?>(() => super.settings,
              name: 'SearchStateBase.settings'))
          .value;
  Computed<Set<String?>>? _$boardIdSetOfContentListComputed;

  @override
  Set<String?> get boardIdSetOfContentList =>
      (_$boardIdSetOfContentListComputed ??= Computed<Set<String?>>(
              () => super.boardIdSetOfContentList,
              name: 'SearchStateBase.boardIdSetOfContentList'))
          .value;
  Computed<Map<String, List<ThreadData?>?>>? _$searchListByBoardIdComputed;

  @override
  Map<String, List<ThreadData?>?> get searchListByBoardId =>
      (_$searchListByBoardIdComputed ??=
              Computed<Map<String, List<ThreadData?>?>>(
                  () => super.searchListByBoardId,
                  name: 'SearchStateBase.searchListByBoardId'))
          .value;
  Computed<String>? _$appBarTitleComputed;

  @override
  String get appBarTitle =>
      (_$appBarTitleComputed ??= Computed<String>(() => super.appBarTitle,
              name: 'SearchStateBase.appBarTitle'))
          .value;
  Computed<List<String?>>? _$searchWordsComputed;

  @override
  List<String?> get searchWords => (_$searchWordsComputed ??=
          Computed<List<String?>>(() => super.searchWords,
              name: 'SearchStateBase.searchWords'))
      .value;

  late final _$contentAtom =
      Atom(name: 'SearchStateBase.content', context: context);

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
      Atom(name: 'SearchStateBase.contentLoading', context: context);

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
      Atom(name: 'SearchStateBase.threadsLoading', context: context);

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

  late final _$primaryViewAtom =
      Atom(name: 'SearchStateBase.primaryView', context: context);

  @override
  PrimaryViewState get primaryView {
    _$primaryViewAtom.reportRead();
    return super.primaryView;
  }

  @override
  set primaryView(PrimaryViewState value) {
    _$primaryViewAtom.reportWrite(value, super.primaryView, () {
      super.primaryView = value;
    });
  }

  late final _$searchThreadListAtom =
      Atom(name: 'SearchStateBase.searchThreadList', context: context);

  @override
  ObservableList<ThreadData?> get searchThreadList {
    _$searchThreadListAtom.reportRead();
    return super.searchThreadList;
  }

  @override
  set searchThreadList(ObservableList<ThreadData?> value) {
    _$searchThreadListAtom.reportWrite(value, super.searchThreadList, () {
      super.searchThreadList = value;
    });
  }

  late final _$setPrimaryViewAsyncAction =
      AsyncAction('SearchStateBase.setPrimaryView', context: context);

  @override
  Future<void> setPrimaryView(PrimaryViewState value) {
    return _$setPrimaryViewAsyncAction.run(() => super.setPrimaryView(value));
  }

  late final _$SearchStateBaseActionController =
      ActionController(name: 'SearchStateBase', context: context);

  @override
  void toggleContentLoading() {
    final _$actionInfo = _$SearchStateBaseActionController.startAction(
        name: 'SearchStateBase.toggleContentLoading');
    try {
      return super.toggleContentLoading();
    } finally {
      _$SearchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleThreadsLoading() {
    final _$actionInfo = _$SearchStateBaseActionController.startAction(
        name: 'SearchStateBase.toggleThreadsLoading');
    try {
      return super.toggleThreadsLoading();
    } finally {
      _$SearchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContent(ContentState? value) {
    final _$actionInfo = _$SearchStateBaseActionController.startAction(
        name: 'SearchStateBase.setContent');
    try {
      return super.setContent(value);
    } finally {
      _$SearchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setSearchThreads(List<ThreadData?>? value) {
    final _$actionInfo = _$SearchStateBaseActionController.startAction(
        name: 'SearchStateBase._setSearchThreads');
    try {
      return super._setSearchThreads(value);
    } finally {
      _$SearchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteContentState() {
    final _$actionInfo = _$SearchStateBaseActionController.startAction(
        name: 'SearchStateBase.deleteContentState');
    try {
      return super.deleteContentState();
    } finally {
      _$SearchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$SearchStateBaseActionController.startAction(
        name: 'SearchStateBase.clear');
    try {
      return super.clear();
    } finally {
      _$SearchStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
content: ${content},
contentLoading: ${contentLoading},
threadsLoading: ${threadsLoading},
primaryView: ${primaryView},
searchThreadList: ${searchThreadList},
settings: ${settings},
boardIdSetOfContentList: ${boardIdSetOfContentList},
searchListByBoardId: ${searchListByBoardId},
appBarTitle: ${appBarTitle},
searchWords: ${searchWords}
    ''';
  }
}
