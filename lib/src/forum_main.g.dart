// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_main.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ForumMainState on ForumMainStateBase, Store {
  Computed<ForumSettingsData?>? _$settingsComputed;

  @override
  ForumSettingsData? get settings =>
      (_$settingsComputed ??= Computed<ForumSettingsData?>(() => super.settings,
              name: 'ForumMainStateBase.settings'))
          .value;
  Computed<Map<String, int?>>? _$threadsLastReadAtComputed;

  @override
  Map<String, int?> get threadsLastReadAt => (_$threadsLastReadAtComputed ??=
          Computed<Map<String, int?>>(() => super.threadsLastReadAt,
              name: 'ForumMainStateBase.threadsLastReadAt'))
      .value;
  Computed<List<BoardData?>>? _$boardsDataComputed;

  @override
  List<BoardData?> get boardsData => (_$boardsDataComputed ??=
          Computed<List<BoardData?>>(() => super.boardsData,
              name: 'ForumMainStateBase.boardsData'))
      .value;
  Computed<List<ThreadData?>>? _$sortedThreadsComputed;

  @override
  List<ThreadData?> get sortedThreads => (_$sortedThreadsComputed ??=
          Computed<List<ThreadData?>>(() => super.sortedThreads,
              name: 'ForumMainStateBase.sortedThreads'))
      .value;
  Computed<List<ThreadData?>>? _$displayThreadsComputed;

  @override
  List<ThreadData?> get displayThreads => (_$displayThreadsComputed ??=
          Computed<List<ThreadData?>>(() => super.displayThreads,
              name: 'ForumMainStateBase.displayThreads'))
      .value;
  Computed<List<ThreadDataForDiff?>>? _$primaryViewDiffComputed;

  @override
  List<ThreadDataForDiff?> get primaryViewDiff => (_$primaryViewDiffComputed ??=
          Computed<List<ThreadDataForDiff?>>(() => super.primaryViewDiff,
              name: 'ForumMainStateBase.primaryViewDiff'))
      .value;
  Computed<bool>? _$userFavoritesBoardsComputed;

  @override
  bool get userFavoritesBoards => (_$userFavoritesBoardsComputed ??=
          Computed<bool>(() => super.userFavoritesBoards,
              name: 'ForumMainStateBase.userFavoritesBoards'))
      .value;
  Computed<List<String?>>? _$favoritesBoardsComputed;

  @override
  List<String?> get favoritesBoards => (_$favoritesBoardsComputed ??=
          Computed<List<String?>>(() => super.favoritesBoards,
              name: 'ForumMainStateBase.favoritesBoards'))
      .value;
  Computed<ThreadsOrder>? _$threadsOrderComputed;

  @override
  ThreadsOrder get threadsOrder => (_$threadsOrderComputed ??=
          Computed<ThreadsOrder>(() => super.threadsOrder,
              name: 'ForumMainStateBase.threadsOrder'))
      .value;

  late final _$contentAtom =
      Atom(name: 'ForumMainStateBase.content', context: context);

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
      Atom(name: 'ForumMainStateBase.contentLoading', context: context);

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
      Atom(name: 'ForumMainStateBase.threadsLoading', context: context);

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
      Atom(name: 'ForumMainStateBase.selectedPrimaryView', context: context);

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

  late final _$boardsAtom =
      Atom(name: 'ForumMainStateBase.boards', context: context);

  @override
  ObservableList<BoardData?> get boards {
    _$boardsAtom.reportRead();
    return super.boards;
  }

  @override
  set boards(ObservableList<BoardData?> value) {
    _$boardsAtom.reportWrite(value, super.boards, () {
      super.boards = value;
    });
  }

  late final _$boardAtom =
      Atom(name: 'ForumMainStateBase.board', context: context);

  @override
  BoardData? get board {
    _$boardAtom.reportRead();
    return super.board;
  }

  @override
  set board(BoardData? value) {
    _$boardAtom.reportWrite(value, super.board, () {
      super.board = value;
    });
  }

  late final _$threadListAtom =
      Atom(name: 'ForumMainStateBase.threadList', context: context);

  @override
  ObservableList<ThreadData?> get threadList {
    _$threadListAtom.reportRead();
    return super.threadList;
  }

  @override
  set threadList(ObservableList<ThreadData?> value) {
    _$threadListAtom.reportWrite(value, super.threadList, () {
      super.threadList = value;
    });
  }

  late final _$threadsDiffAtom =
      Atom(name: 'ForumMainStateBase.threadsDiff', context: context);

  @override
  ObservableMap<String, List<ThreadDataForDiff?>> get threadsDiff {
    _$threadsDiffAtom.reportRead();
    return super.threadsDiff;
  }

  @override
  set threadsDiff(ObservableMap<String, List<ThreadDataForDiff?>> value) {
    _$threadsDiffAtom.reportWrite(value, super.threadsDiff, () {
      super.threadsDiff = value;
    });
  }

  late final _$searchThreadWordAtom =
      Atom(name: 'ForumMainStateBase.searchThreadWord', context: context);

  @override
  String? get searchThreadWord {
    _$searchThreadWordAtom.reportRead();
    return super.searchThreadWord;
  }

  @override
  set searchThreadWord(String? value) {
    _$searchThreadWordAtom.reportWrite(value, super.searchThreadWord, () {
      super.searchThreadWord = value;
    });
  }

  late final _$setPrimaryViewAsyncAction =
      AsyncAction('ForumMainStateBase.setPrimaryView', context: context);

  @override
  Future<void> setPrimaryView(PrimaryViewState value) {
    return _$setPrimaryViewAsyncAction.run(() => super.setPrimaryView(value));
  }

  late final _$getBoardsAsyncAction =
      AsyncAction('ForumMainStateBase.getBoards', context: context);

  @override
  Future<void> getBoards() {
    return _$getBoardsAsyncAction.run(() => super.getBoards());
  }

  late final _$_getBoardsForFiveChAsyncAction =
      AsyncAction('ForumMainStateBase._getBoardsForFiveCh', context: context);

  @override
  Future<void> _getBoardsForFiveCh() {
    return _$_getBoardsForFiveChAsyncAction
        .run(() => super._getBoardsForFiveCh());
  }

  late final _$_getBoardsForPinkChAsyncAction =
      AsyncAction('ForumMainStateBase._getBoardsForPinkCh', context: context);

  @override
  Future<void> _getBoardsForPinkCh() {
    return _$_getBoardsForPinkChAsyncAction
        .run(() => super._getBoardsForPinkCh());
  }

  late final _$_getBoardsForGirlsChAsyncAction =
      AsyncAction('ForumMainStateBase._getBoardsForGirlsCh', context: context);

  @override
  Future<void> _getBoardsForGirlsCh() {
    return _$_getBoardsForGirlsChAsyncAction
        .run(() => super._getBoardsForGirlsCh());
  }

  late final _$_getBoardsForFutabaAsyncAction =
      AsyncAction('ForumMainStateBase._getBoardsForFutaba', context: context);

  @override
  Future<void> _getBoardsForFutaba() {
    return _$_getBoardsForFutabaAsyncAction
        .run(() => super._getBoardsForFutaba());
  }

  late final _$_getBoardsForMachiAsyncAction =
      AsyncAction('ForumMainStateBase._getBoardsForMachi', context: context);

  @override
  Future<void> _getBoardsForMachi() {
    return _$_getBoardsForMachiAsyncAction
        .run(() => super._getBoardsForMachi());
  }

  late final _$_setThreadsMetadataAsyncAction =
      AsyncAction('ForumMainStateBase._setThreadsMetadata', context: context);

  @override
  Future<void> _setThreadsMetadata<T extends ThreadData>(List<T?> result) {
    return _$_setThreadsMetadataAsyncAction
        .run(() => super._setThreadsMetadata<T>(result));
  }

  late final _$ForumMainStateBaseActionController =
      ActionController(name: 'ForumMainStateBase', context: context);

  @override
  void toggleContentLoading() {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.toggleContentLoading');
    try {
      return super.toggleContentLoading();
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleThreadsLoading() {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.toggleThreadsLoading');
    try {
      return super.toggleThreadsLoading();
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setBoard(BoardData value) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.setBoard');
    try {
      return super.setBoard(value);
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _clearThreads() {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase._clearThreads');
    try {
      return super._clearThreads();
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setThreads<T extends ThreadData>(
      {required List<T?> newList, required BoardData boardData}) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase._setThreads<T extends ThreadData>');
    try {
      return super._setThreads<T>(newList: newList, boardData: boardData);
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContent(ThreadContentData? value) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.setContent');
    try {
      return super.setContent(value);
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchWord(String value) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.setSearchWord');
    try {
      return super.setSearchWord(value);
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clearSearchWord() {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.clearSearchWord');
    try {
      return super.clearSearchWord();
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteContentState() {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.deleteContentState');
    try {
      return super.deleteContentState();
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.clear');
    try {
      return super.clear();
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
content: ${content},
contentLoading: ${contentLoading},
threadsLoading: ${threadsLoading},
selectedPrimaryView: ${selectedPrimaryView},
boards: ${boards},
board: ${board},
threadList: ${threadList},
threadsDiff: ${threadsDiff},
searchThreadWord: ${searchThreadWord},
settings: ${settings},
threadsLastReadAt: ${threadsLastReadAt},
boardsData: ${boardsData},
sortedThreads: ${sortedThreads},
displayThreads: ${displayThreads},
primaryViewDiff: ${primaryViewDiff},
userFavoritesBoards: ${userFavoritesBoards},
favoritesBoards: ${favoritesBoards},
threadsOrder: ${threadsOrder}
    ''';
  }
}
