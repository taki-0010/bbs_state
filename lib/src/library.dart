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

  // @computed
  // bool get sortHistoryByRetention => settings?.sortHistoryByRetention ?? false;
  @computed
  SortHistoryList get sortHistory =>
      settings?.sortHistoryList ?? SortHistoryList.boards;
  // @computed
  // bool get viewByBoard => settings?.viewByBoardInHistory ?? false;

  @computed
  Map<String, List<ThreadMarkData?>?> get displayList => switch (sortHistory) {
        SortHistoryList.boards => markListByBoardId,
        // SortHistoryList.deletionDate => markListByBoardId,
        // SortHistoryList.hot => markListByBoardId,
        SortHistoryList.history => markListByLastReadAt
      };

  @computed
  Set<String?> get boardIdSetOfContentList {
    final boardIdSet = markList.map((element) => element?.boardId).toList();
    // final boardsData = boardIdSet
    //     .map((e) => boards.firstWhere((element) => element?.id == e,
    //         orElse: () => null))
    //     .toList();
    logger.d('historyListByBoard: ${boardIdSet.map((e) => e)},');
    boardIdSet.sort((a, b) => (a ?? '').compareTo((b ?? '')));
    return boardIdSet.toSet();
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

  @computed
  Map<String, List<ThreadMarkData?>?> get markListByLastReadAt {
    Map<String, List<ThreadMarkData?>?> result = {};
    final locale = parent.parent.getLocale.name;
    final lastReadAtSet =
        markList.map((element) => element?.lastReadAt).toSet();
    final list = lastReadAtSet.toList();
    list.sort((a, b) => (b ?? 0).compareTo((a ?? 0)));
    for (final b in list) {
      if (b != null) {
        final daysago = getTimeago(
          epochToDateTime(b),
          locale,
        );
        final list = markList
            .where((element) =>
                element?.lastReadAt != null &&
                getTimeago(
                      epochToDateTime(element!.lastReadAt!),
                      locale,
                    ) ==
                    daysago)
            .toList();
        result[daysago ?? ''] = [];
        final sorted = _sort(list);
        result[daysago]?.addAll(sorted);
      }
    }
    return result;
  }

  @computed
  Map<String, List<ThreadMarkData?>?> get currentHistoryList =>
      switch (sortHistory) {
        SortHistoryList.history => markListByLastReadAt,
        SortHistoryList.boards => markListByBoardId
      };

  List<ThreadMarkData?> _sort(final List<ThreadMarkData?> list) {
    list.sort((a, b) => (b?.lastReadAt ?? 0).compareTo((a?.lastReadAt ?? 0)));

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

      // parent.forumMain.setThreadsLastReadAt(value!);
    }
  }

  @action
  void deleteDiffField(final String? id) {
    markListDiff.remove(id);
  }

  ThreadMarkData? getSelectedMarkData(final ThreadBase value) {
    return markList.firstWhere(
        (element) =>
            element?.id == value.id &&
            element?.boardId == value.boardId &&
            element?.type == value.type,
        orElse: () => null);
  }

  ThreadMarkData? getSelectedMarkDataById(
      final String id, final String? boardId) {

    return markList.firstWhere(
        (element) => element?.id == id && (parent.type == Communities.girlsCh ? true : element?.boardId == boardId),
        orElse: () => null);
  }

  ThreadMarkData? getSelectedMarkDataByUri(final Uri uri) {
    final threadOrBoard = parent.parent.uriIsThreadOrBoard(uri, parent.type);
    if (threadOrBoard == null || !threadOrBoard) {
      return null;
    }
    final threadId = parent.parent.getThreadIdFromUri(uri, parent.type);
    final boardId = parent.parent.getBoardIdFromUri(uri, parent.type);
    
    if (threadId != null ) {
      return getSelectedMarkDataById(threadId, boardId);
    }
    return null;
  }

  @action
  void replaceContent(ContentState value) {
    content = value;
  }

  @action
  void setContent(final ContentState? value) {
    content = value;
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

  Future<void> updateThreadsByBoard(final String boardId) async {
    final data = markList.firstWhere(
      (element) => element?.boardId == boardId,
      orElse: () => null,
    );
    await _updateThreadsByBoard([data]);
  }

  Future<void> updateThreadsByLastReadAt(final String keyName) async {
    final list = [...?markListByLastReadAt[keyName]];
    List<ThreadMarkData?> byBoard = [];
    for (final i in list) {
      if (i != null) {
        final exist = byBoard.firstWhere(
          (element) => element?.boardId == i.boardId,
          orElse: () => null,
        );
        if (exist == null) {
          byBoard.add(i);
        }
      }
    }
    await _updateThreadsByBoard(byBoard, willUpdateList: list);
  }

  // @action
  Future<void> clearThreadsByBoard(final String boardId) async {
    final list = [...?markListByBoardId[boardId]];
    if (list.isNotEmpty) {
      await _clearThreads(list);
    }
  }

  Future<void> clearThreadsByHistory(final String keyName) async {
    final list = [...?markListByLastReadAt[keyName]];
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
    // final currentRes = {...currentMarksResCount};
    final markListByBoardIdFirstItemList =
        markListByBoardId.values.map((e) => e?.firstOrNull).toList();
    logger.d(
        'history: updateAll:  map:${markListByBoardId.values.length}, markListByBoardIdFirstItemList:${markListByBoardIdFirstItemList.length}');
    await _updateThreadsByBoard(markListByBoardIdFirstItemList);
    // for (final b in markListByBoardIdFirstItemList) {
    //   if (b != null) {
    //     FetchThreadsResultData? result;
    //     switch (parent.type) {
    //       case Communities.fiveCh:
    //         result = await FiveChHandler.getThreads(
    //             domain: b.uri.host,
    //             directoryName: b.boardId,
    //             boardName: b.boardName ?? '');
    //         if (result.result == FetchResult.success) {
    //           setArchived<ThreadData>(result.threads!, b.boardId);
    //         }

    //         break;
    //       case Communities.girlsCh:
    //         result = await GirlsChHandler.getTitleList(
    //             'topics/category/${b.boardId}',
    //             categoryId: b.boardId);
    //         // _setDiff(
    //         //   result,
    //         //   currentRes,
    //         // );
    //         break;
    //       case Communities.futabaCh:
    //         final selectedBoardThreads =
    //             markList.where((e) => e?.boardId == b.boardId).toList();
    //         List<FutabaChThread?> threadsData = [];
    //         for (final i in selectedBoardThreads) {
    //           if (i != null) {
    //             // final data =
    //             //     await FutabaChHandler.getContentByJson(b.futabaDirectory, b.boardId, i.id);
    //             final data =
    //                 await FutabaChHandler.getContent(i.url, b.futabaDirectory);
    //             if (data.result == FetchResult.error ||
    //                 data.statusCode == 404) {
    //               await parent.parent.deleteThreadMarkData(i);
    //             } else {
    //               final rescount = data.contentList?.lastOrNull?.index;
    //               if (rescount != null && i.resCount != 1001) {
    //                 final newData = FutabaParser.parseFromJson(rescount, i);
    //                 threadsData
    //                     .removeWhere((element) => element?.id == newData?.id);
    //                 threadsData.add(newData);
    //               }
    //             }
    //           }
    //         }
    //         result = FetchThreadsResultData(threads: threadsData);
    //         break;
    //       case Communities.pinkCh:
    //         result = await PinkChHandler.getThreads(
    //             domain: b.uri.host,
    //             directoryName: b.boardId,
    //             boardName: b.boardName ?? '');
    //         if (result.result == FetchResult.success) {
    //           setArchived<ThreadData>(result.threads!, b.boardId);
    //         }

    //         break;
    //       case Communities.machi:
    //         result = await MachiHandler.getThreads(b.boardId);
    //         // result = parent.forumMain.setMachiThreads(data);

    //         break;
    //       default:
    //     }
    //     _setDiff(
    //       result?.threads,
    //       currentRes,
    //     );
    //   }
    // }
  }

  Future<void> _updateThreadsByBoard(final List<ThreadMarkData?> list,
      {final List<ThreadMarkData?>? willUpdateList}) async {
    final currentRes = {...currentMarksResCount};
    for (final b in list) {
      if (b != null) {
        FetchThreadsResultData? result;
        switch (parent.type) {
          case Communities.fiveCh:
            result = await FiveChHandler.getThreads(
                domain: b.uri.host,
                directoryName: b.boardId,
                boardName: b.boardName ?? '', forum: Communities.fiveCh);
            if (result.result == FetchResult.success) {
              await setArchived<ThreadData>(result.threads!, b.boardId);
            }

            break;
          case Communities.girlsCh:
            result = await GirlsChHandler.getTitleList(
                'topics/category/${b.boardId}',
                categoryId: b.boardId);
            // _setDiff(
            //   result,
            //   currentRes,
            // );
            break;
          case Communities.futabaCh:
            final selectedBoardThreads =
                markList.where((e) => e?.boardId == b.boardId).toList();
            List<FutabaChThread?> threadsData = [];
            for (final i in selectedBoardThreads) {
              if (i != null) {
                // final data =
                //     await FutabaChHandler.getContentByJson(b.futabaDirectory, b.boardId, i.id);
                final data = await FutabaChHandler.getContent(
                    b.boardId, b.getSubdomain, b.id);
                if (data.result == FetchResult.error ||
                    data.statusCode == 404) {
                  await parent.parent.deleteThreadMarkData(i);
                } else {
                  final rescount = data.contentList?.lastOrNull?.index;
                  if (rescount != null && i.resCount != 1001) {
                    final newData = FutabaData.parseFromJson(rescount, i);
                    threadsData
                        .removeWhere((element) => element?.id == newData?.id);
                    threadsData.add(newData);
                  }
                }
              }
            }
            result = FetchThreadsResultData(threads: threadsData);
            break;
          case Communities.pinkCh:
            result = await PinkChHandler.getThreads(
                domain: b.uri.host,
                directoryName: b.boardId,
                boardName: b.boardName ?? '');
            if (result.result == FetchResult.success) {
              await setArchived<ThreadData>(result.threads!, b.boardId);
            }

            break;
          case Communities.machi:
            result = await MachiHandler.getThreads(b.boardId);
            break;
          case Communities.shitaraba:
            final boardId = b.boardId;
            final category = b.shitarabaCategory;
            final boardName =
                b.boardName ?? parent.parent.boardNameById(boardId);
            result = await ShitarabaHandler.getThreads(
                category, boardId, boardName ?? '');
          case Communities.open2Ch:
            result = await Open2ChHandler.getThreads(
                b.getSubdomain, b.boardId, b.boardName ?? '');
            if (result.result == FetchResult.success) {
              await setArchived<ThreadData>(result.threads!, b.boardId);
            }
          default:
        }
        List<ThreadData?> threads = [];
        if (willUpdateList != null) {
          for (final i in willUpdateList) {
            final exist = result?.threads?.firstWhere(
                (element) =>
                    element?.id == i?.id && element?.boardId == i?.boardId,
                orElse: () => null);
            if (exist != null) {
              threads.add(exist);
            }
          }
        } else {
          threads.addAll([...?result?.threads]);
        }
        _setDiff(
          threads,
          currentRes,
        );
      }
    }
  }

  Future<void> updateResCountWhenUpdateBoard(
      final List<ThreadData?> list) async {
    for (final i in list) {
      if (i != null) {
        final exist = getSelectedMarkData(i);
        if (exist != null && !exist.archived && exist.resCount != i.resCount) {
          final newData = exist.copyWith(resCount: i.resCount);
          // deleteDiffField(newData.id);
          await parent.parent.repository.updateThreadMark(newData);
        }
      }
    }
  }

  Future<void> deleteMarkDataWhenNotFound<T extends ThreadData>(
      final List<T?> list, final String boardId) async {
    Set<ThreadMarkData?> willDeleteList = {};
    final filterd =
        markList.where((element) => element?.boardId == boardId).toList();
    for (final i in filterd) {
      if (i != null) {
        final exist = list.firstWhere(
          (element) => element?.id == i.id,
          orElse: () => null,
        );
        if (exist == null) {
          willDeleteList.add(i);
        }
      }
    }
    if (willDeleteList.isNotEmpty) {
      for (final d in willDeleteList) {
        if (d != null) {
          await parent.parent.deleteThreadMarkData(d);
        }
      }
    }
  }

  Future<void> setArchived<T extends ThreadData>(
      final List<T?> newList, final String boardId) async {
    if (parent.type == Communities.futabaCh ||
        parent.type == Communities.girlsCh) {
      return;
    }
    final before =
        markList.where((element) => element?.boardId == boardId).toList();
    for (final i in before) {
      if (i != null) {
        final exist = newList.firstWhere((element) => element?.id == i.id,
            orElse: () => null);
        if (exist == null) {
          // final history = parent.history.markList
          //     .firstWhere((element) => element?.id == i.id, orElse: () => null);
          if (!i.archived) {
            final newData = i.copyWith(archived: true);
            await parent.parent.repository.updateThreadMark(newData);
          }
        }
      }
    }
  }

  @action
  void setDiffValue(final String id, final int value) {
    markListDiff[id] = value;
  }

  // @action
  void _setDiff<T extends ThreadData>(
    final List<T?>? result,
    final Map<String, int> currentRes,
  ) {
    if (result == null) return;
    // Set<ThreadMarkData?> willDeleteSet = {};
    // final list =
    //     [...markList.where((element) => element?.boardId == boardId).toList()];
    for (final m in markList) {
      if (m != null) {
        final exist = result.firstWhere(
          (element) =>
              element?.id == m.id &&
              element?.boardId == m.boardId &&
              !m.archived,
          orElse: () => null,
        );
        if (exist != null) {
          final current = currentRes[m.id];
          final diff = exist.resCount - (current ?? exist.resCount);
          setDiffValue(m.id, diff);

          if (diff != 0) {
            final retention = parent.getRetentionSinceEpoch(exist.resCount, m);
            final newData = m.copyWith(
                resCount: exist.resCount, retentionPeriodSeconds: retention);
            // setLog(newData);
            parent.parent.repository.updateThreadMark(newData);
          }
        } else {
          logger.d('_setDiff: ${m.title}');
          // willDeleteSet.add(m);
        }
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
