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
  Computed<bool?>? _$getYtChannelOrPlayListComputed;

  @override
  bool? get getYtChannelOrPlayList => (_$getYtChannelOrPlayListComputed ??=
          Computed<bool?>(() => super.getYtChannelOrPlayList,
              name: 'ForumMainStateBase.getYtChannelOrPlayList'))
      .value;
  Computed<bool>? _$hideUpdateThreadsButtonComputed;

  @override
  bool get hideUpdateThreadsButton => (_$hideUpdateThreadsButtonComputed ??=
          Computed<bool>(() => super.hideUpdateThreadsButton,
              name: 'ForumMainStateBase.hideUpdateThreadsButton'))
      .value;
  Computed<bool>? _$hasYtThreadsClientComputed;

  @override
  bool get hasYtThreadsClient => (_$hasYtThreadsClientComputed ??=
          Computed<bool>(() => super.hasYtThreadsClient,
              name: 'ForumMainStateBase.hasYtThreadsClient'))
      .value;
  Computed<List<ThreadDataForDiff?>?>? _$currentBoardDiffComputed;

  @override
  List<ThreadDataForDiff?>? get currentBoardDiff =>
      (_$currentBoardDiffComputed ??= Computed<List<ThreadDataForDiff?>?>(
              () => super.currentBoardDiff,
              name: 'ForumMainStateBase.currentBoardDiff'))
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
  Computed<List<BoardData?>>? _$favoritesBoardsDataComputed;

  @override
  List<BoardData?> get favoritesBoardsData => (_$favoritesBoardsDataComputed ??=
          Computed<List<BoardData?>>(() => super.favoritesBoardsData,
              name: 'ForumMainStateBase.favoritesBoardsData'))
      .value;
  Computed<List<ThreadData?>>? _$sortedThreadsComputed;

  @override
  List<ThreadData?> get sortedThreads => (_$sortedThreadsComputed ??=
          Computed<List<ThreadData?>>(() => super.sortedThreads,
              name: 'ForumMainStateBase.sortedThreads'))
      .value;
  Computed<bool>? _$currentBoardIsFavoriteComputed;

  @override
  bool get currentBoardIsFavorite => (_$currentBoardIsFavoriteComputed ??=
          Computed<bool>(() => super.currentBoardIsFavorite,
              name: 'ForumMainStateBase.currentBoardIsFavorite'))
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
  Computed<ThreadsOrderType>? _$threadsOrderComputed;

  @override
  ThreadsOrderType get threadsOrder => (_$threadsOrderComputed ??=
          Computed<ThreadsOrderType>(() => super.threadsOrder,
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

  late final _$boardLoadingAtom =
      Atom(name: 'ForumMainStateBase.boardLoading', context: context);

  @override
  bool get boardLoading {
    _$boardLoadingAtom.reportRead();
    return super.boardLoading;
  }

  @override
  set boardLoading(bool value) {
    _$boardLoadingAtom.reportWrite(value, super.boardLoading, () {
      super.boardLoading = value;
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

  late final _$favoriteBoardsDataAtom =
      Atom(name: 'ForumMainStateBase.favoriteBoardsData', context: context);

  @override
  ObservableList<BoardData?> get favoriteBoardsData {
    _$favoriteBoardsDataAtom.reportRead();
    return super.favoriteBoardsData;
  }

  @override
  set favoriteBoardsData(ObservableList<BoardData?> value) {
    _$favoriteBoardsDataAtom.reportWrite(value, super.favoriteBoardsData, () {
      super.favoriteBoardsData = value;
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

  late final _$ytThreadsResultAtom =
      Atom(name: 'ForumMainStateBase.ytThreadsResult', context: context);

  @override
  YoutubeThreadsResult? get ytThreadsResult {
    _$ytThreadsResultAtom.reportRead();
    return super.ytThreadsResult;
  }

  @override
  set ytThreadsResult(YoutubeThreadsResult? value) {
    _$ytThreadsResultAtom.reportWrite(value, super.ytThreadsResult, () {
      super.ytThreadsResult = value;
    });
  }

  late final _$ytSortAtom =
      Atom(name: 'ForumMainStateBase.ytSort', context: context);

  @override
  YoutubeSortData get ytSort {
    _$ytSortAtom.reportRead();
    return super.ytSort;
  }

  @override
  set ytSort(YoutubeSortData value) {
    _$ytSortAtom.reportWrite(value, super.ytSort, () {
      super.ytSort = value;
    });
  }

  late final _$ytChannelOrPlaylistAtom =
      Atom(name: 'ForumMainStateBase.ytChannelOrPlaylist', context: context);

  @override
  bool get ytChannelOrPlaylist {
    _$ytChannelOrPlaylistAtom.reportRead();
    return super.ytChannelOrPlaylist;
  }

  @override
  set ytChannelOrPlaylist(bool value) {
    _$ytChannelOrPlaylistAtom.reportWrite(value, super.ytChannelOrPlaylist, () {
      super.ytChannelOrPlaylist = value;
    });
  }

  late final _$setPrimaryViewAsyncAction =
      AsyncAction('ForumMainStateBase.setPrimaryView', context: context);

  @override
  Future<void> setPrimaryView(PrimaryViewState value) {
    return _$setPrimaryViewAsyncAction.run(() => super.setPrimaryView(value));
  }

  late final _$reloadBoardsAsyncAction =
      AsyncAction('ForumMainStateBase.reloadBoards', context: context);

  @override
  Future<void> reloadBoards() {
    return _$reloadBoardsAsyncAction.run(() => super.reloadBoards());
  }

  late final _$getBoardsAsyncAction =
      AsyncAction('ForumMainStateBase.getBoards', context: context);

  @override
  Future<void> getBoards() {
    return _$getBoardsAsyncAction.run(() => super.getBoards());
  }

  late final _$_setThreadsMetadataAsyncAction =
      AsyncAction('ForumMainStateBase._setThreadsMetadata', context: context);

  @override
  Future<void> _setThreadsMetadata<T extends ThreadData>(List<T?> result) {
    return _$_setThreadsMetadataAsyncAction
        .run(() => super._setThreadsMetadata<T>(result));
  }

  late final _$getNextThreadsForYoutubeAsyncAction = AsyncAction(
      'ForumMainStateBase.getNextThreadsForYoutube',
      context: context);

  @override
  Future<void> getNextThreadsForYoutube() {
    return _$getNextThreadsForYoutubeAsyncAction
        .run(() => super.getNextThreadsForYoutube());
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
  void toggleBoardLoading() {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.toggleBoardLoading');
    try {
      return super.toggleBoardLoading();
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setThreadScrollOffset(double? value) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.setThreadScrollOffset');
    try {
      return super.setThreadScrollOffset(value);
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
  void _setYtThreadsResult(YoutubeThreadsResult? value) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase._setYtThreadsResult');
    try {
      return super._setYtThreadsResult(value);
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteDiffField(String? id) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.deleteDiffField');
    try {
      return super.deleteDiffField(id);
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
  void _setThreadsDiff<T extends ThreadData>(
      {required List<T?> newList, required BoardData boardData}) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase._setThreadsDiff<T extends ThreadData>');
    try {
      return super._setThreadsDiff<T>(newList: newList, boardData: boardData);
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _setYtSort(YoutubeSortData value) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase._setYtSort');
    try {
      return super._setYtSort(value);
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setYtChannelOrPlaylist(bool value) {
    final _$actionInfo = _$ForumMainStateBaseActionController.startAction(
        name: 'ForumMainStateBase.setYtChannelOrPlaylist');
    try {
      return super.setYtChannelOrPlaylist(value);
    } finally {
      _$ForumMainStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContent(ContentState? value) {
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
boardLoading: ${boardLoading},
selectedPrimaryView: ${selectedPrimaryView},
boards: ${boards},
favoriteBoardsData: ${favoriteBoardsData},
board: ${board},
threadList: ${threadList},
threadsDiff: ${threadsDiff},
searchThreadWord: ${searchThreadWord},
ytThreadsResult: ${ytThreadsResult},
ytSort: ${ytSort},
ytChannelOrPlaylist: ${ytChannelOrPlaylist},
settings: ${settings},
getYtChannelOrPlayList: ${getYtChannelOrPlayList},
hideUpdateThreadsButton: ${hideUpdateThreadsButton},
hasYtThreadsClient: ${hasYtThreadsClient},
currentBoardDiff: ${currentBoardDiff},
threadsLastReadAt: ${threadsLastReadAt},
boardsData: ${boardsData},
favoritesBoardsData: ${favoritesBoardsData},
sortedThreads: ${sortedThreads},
currentBoardIsFavorite: ${currentBoardIsFavorite},
displayThreads: ${displayThreads},
primaryViewDiff: ${primaryViewDiff},
userFavoritesBoards: ${userFavoritesBoards},
favoritesBoards: ${favoritesBoards},
threadsOrder: ${threadsOrder}
    ''';
  }
}
