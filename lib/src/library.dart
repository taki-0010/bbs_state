import 'importer.dart';

part 'library.g.dart';

class LibraryState = LibraryStateBase with _$LibraryState;

abstract class LibraryStateBase with Store, WithDateTime {
  LibraryStateBase({
    required this.parent,
  });
  late ForumStateBase parent;
  // late LibraryType type;

  @observable
  ContentState? content;

  @observable
  bool contentLoading = false;
  @observable
  bool threadsLoading = false;

  double? lastThreadsScrollOffset;

  @computed
  ForumSettingsData? get settings => parent.settings;

  @observable
  PrimaryViewState selectedPrimaryView = PrimaryViewState.threads;

  @observable
  ObservableList<ThreadMarkData?> markList = ObservableList<ThreadMarkData?>();

  // @observable
  // String? nameOnAppBar;

  // @observable
  // int viewIndex = 0;

  // @observable
  // String? selectedContentId;

  // @observable
  // ThreadContentData? libraryContent;

  @computed
  Map<String, int> get currentMarksResCount {
    Map<String, int> result = {};
    for (final m in markList) {
      if (m != null) {
        result[m.id] = m.resCount;
      }
    }
    return result;
  }

  @observable
  ObservableMap<String, int> markListDiff = ObservableMap();

  @computed
  bool get sortHistoryByRetention => settings?.sortHistoryByRetention ?? false;
  @computed
  SortHistory get sortHistory => settings?.sortHistory ?? SortHistory.history;
  // @computed
  // bool get viewByBoard => settings?.viewByBoardInHistory ?? false;

  @computed
  Set<String?> get boardIdSetOfContentList {
    final boardIdSet = markList.map((element) => element?.boardId).toSet();
    // final boardsData = boardIdSet
    //     .map((e) => boards.firstWhere((element) => element?.id == e,
    //         orElse: () => null))
    //     .toList();
    logger.d('historyListByBoard: ${boardIdSet.map((e) => e)},');
    return boardIdSet;
  }

  @computed
  Map<String, List<ThreadMarkData?>?> get markListByBoardId {
    Map<String, List<ThreadMarkData?>?> result = {};
    for (final b in boardIdSetOfContentList) {
      if (b != null) {
        final list =
            markList.where((element) => element?.boardId == b).toList();
        result[b] = [];
        final sorted = _sort(list);
        result[b]?.addAll(sorted);
      }
    }
    return result;
  }

  List<ThreadMarkData?> _sort(final List<ThreadMarkData?> list) {
    switch (sortHistory) {
      case SortHistory.hot:
         list.sort((a, b) => (getIkioi(b?.createdAtBySeconds ?? 0, b?.resCount ?? 0))
            .compareTo(getIkioi(a?.createdAtBySeconds ?? 0, a?.resCount ?? 0)));
        break;
      case SortHistory.deletionDate:
         list.sort((a, b) => (a?.retentionPeriodSeconds ?? 0)
            .compareTo((b?.retentionPeriodSeconds ?? 0)));
      case SortHistory.history:
          list.sort((a, b) => (b?.lastReadAt ?? 0)
            .compareTo((a?.lastReadAt ?? 0)));
      default:
    }
    // if (sortHistory) {
    //   list.sort((a, b) => (a?.retentionPeriodSeconds ?? 0)
    //       .compareTo((b?.retentionPeriodSeconds ?? 0)));
    // } else {
    //   list.sort((a, b) =>
    //       (b?.createdAtBySeconds ?? 0).compareTo((a?.createdAtBySeconds ?? 0)));
    // }
    return list;
  }

  @action
  void toggleContentLoading() => contentLoading = !contentLoading;

  @action
  void toggleThreadsLoading() => threadsLoading = !threadsLoading;

  @computed
  String get appBarTitle => switch (selectedPrimaryView) {
        PrimaryViewState.content => '${parent.currentContentThreadData?.title}',
        PrimaryViewState.threads => parent.type.label,
        PrimaryViewState.boards => '',
      };

  @action
  void setLog(final ThreadMarkData? value) {
    if (value?.type == parent.type) {
      markList.removeWhere((element) =>
          element?.id == value?.id && element?.boardId == value?.boardId);
      markList.insert(0, value);
    }
  }

  @action
  void replaceContent(ContentState value) {
    content = value;
  }

  @action
  void setContent(
    final ThreadContentData? value,
  ) {
    if (value != null && parent.parent.userData != null) {
      final data = ContentState(
          content: value, locale: parent.parent.userData!.language.name);
      // data.setLastOpenedIndex(lastOpenedIndex);
      content = data;
    } else {
      content = null;
    }
  }

  String? boardNameById(final String id) {
    if (boardIdSetOfContentList.isEmpty) return null;
    final boardId = boardIdSetOfContentList
        .firstWhere((element) => element == id, orElse: () => null);
    if (boardId == null) return null;
    final mark = markList.firstWhere(
      (element) => element?.boardId == boardId,
      orElse: () => null,
    );
    logger.d('selectedBoardName:  boardId: $boardId, name: ${mark?.boardName}');
    // final data = await parent.boardStorage.getBoardData(boardId);
    // if (data != null) {
    //   return data.board.name;
    // }
    return mark?.boardName;
  }

  // void updateMarkData(final ThreadMarkData value) =>
  //   content?.updateMarkData(value);

  // @action
  void updateContent(final ThreadContentData value) =>
      content?.updateContent(value);

  // @action
  // void setContent(final ThreadContentData? value) {
  //   libraryContent = value;
  // }

  Future<void> clearAllThreads() async {
    await _clearThreads([...markList]);
  }

  // @action
  Future<void> clearThreadsByBoard(final String boardId) async {
    final list = [...?markListByBoardId[boardId]];
    if (list.isNotEmpty) {
      await _clearThreads(list);
    }
  }

  // @action
  Future<void> _clearThreads(final List<ThreadMarkData?> list) async {
    await parent.parent.repository.clearThreads(list);
  }

  @action
  Future<void> setPrimaryView(final PrimaryViewState value) async {
    selectedPrimaryView = value;
    if (value == PrimaryViewState.threads) {
      if (content != null) {
        await parent.parent.setLastOpenedContentIndexById(
            content!.currentContentIndex,
            type: content!.content.type,
            threadId: content!.content.id,
            boardId: content!.content.boardId);
      }

      deleteContentState();
    }
  }

  @action
  void deleteData(final ThreadMarkData value) {
    if (value.type == parent.type) {
      markList.removeWhere((element) => element?.id == value.id);
      if (content?.content.id == value.id) {
        deleteContentState();
        if (selectedPrimaryView == PrimaryViewState.content) {
          setPrimaryView(PrimaryViewState.threads);
        }
      }
    }
  }

  // @action
  // void setContentId(final String? value) => selectedContentId = value;

  // void setContentIdByData(final ThreadData? value) {
  //   setContentId(value?.id);
  // }

  // @action
  // void setViewIndex(final int index) => viewIndex = index;


  Future<void> updateAllList() async {
    // for (final i in markList) {
    //   if (i != null) {
    //     // await parent.updateContent(i);
    //   }
    // }
    final currentRes = {...currentMarksResCount};
    final markListByBoardIdFirstItemList =
        markListByBoardId.values.map((e) => e?.firstOrNull).toList();
    logger.d(
        'history: updateAll: currentRes:$currentRes, map:${markListByBoardId.values.length}, markListByBoardIdFirstItemList:${markListByBoardIdFirstItemList.length}');
    for (final b in markListByBoardIdFirstItemList) {
      if (b != null) {
        switch (parent.type) {
          case Communities.fiveCh:
            final result = await FiveChHandler.getThreads(
                domain: b.uri.host,
                directoryName: b.boardId,
                boardName: b.boardName ?? '');
            _setDiff(result, currentRes);
            break;
          case Communities.girlsCh:
            final result = await GirlsChHandler.getTitleList(
                'topics/category/${b.boardId}',
                categoryId: b.boardId);
            _setDiff(result, currentRes);
            break;
          case Communities.futabaCh:
            final result = await FutabaChHandler.getAllThreads(
                catalog: FutabaParser.getBoardPath(
                    directory: b.futabaDirectory,
                    boardId: b.boardId,
                    order: ThreadsOrder.catalog),
                newer: FutabaParser.getBoardPath(
                    directory: b.futabaDirectory,
                    boardId: b.boardId,
                    order: ThreadsOrder.newerThread),
                hug: FutabaParser.getBoardPath(
                    directory: b.futabaDirectory,
                    boardId: b.boardId,
                    order: ThreadsOrder.resCountDesc),
                boardId: b.boardId,
                directory: b.futabaDirectory);
            _setDiff(result, currentRes);
            break;
          case Communities.pinkCh:
            final result = await PinkChHandler.getThreads(
                domain: b.uri.host,
                directoryName: b.boardId,
                boardName: b.boardName ?? '');
            _setDiff(result, currentRes);
            break;
          default:
        }
      }
    }
  }

  void _setDiff<T extends ThreadData>(
      final List<T?>? result, final Map<String, int> currentRes) {
    if (result == null) return;
    for (final m in markList) {
      if (m != null) {
        final exist = result.firstWhere(
          (element) => element?.id == m.id && element?.boardId == m.boardId,
          orElse: () => null,
        );
        if (exist != null) {
          final current = currentRes[m.id];
          final diff = exist.resCount - (current ?? exist.resCount);
          markListDiff[m.id] = diff;

          if (diff != 0) {
            final retention = parent.getRetentionSinceEpoch(exist.resCount, m);
            final newData = m.copyWith(
                resCount: exist.resCount, retentionPeriodSeconds: retention);
            // setLog(newData);
            parent.parent.repository.updateThreadMark(newData);
          }
        } else {}
      }
    }
  }

  @action
  void deleteContentState() => content = null;

  @action
  void clear() {
    markList.clear();
    markListDiff.clear();
    deleteContentState();
  }
}
