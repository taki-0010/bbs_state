import 'importer.dart';

part 'library.g.dart';

class UpdateFieldData {
  const UpdateFieldData(
      {required this.id,
      this.boardId,
      required this.newResCount,
      this.archived = false,
      this.deleted = false});
  final String id;
  final String? boardId;
  final int newResCount;
  final bool archived;
  final bool deleted;
}

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

  // @computed
  // Map<String, int> get currentMarksResCount {
  //   Map<String, int> result = {};
  //   for (final m in markList) {
  //     if (m != null) {
  //       result[m.id] = m.resCount;
  //     }
  //   }
  //   return result;
  // }

  @observable
  ObservableMap<String, int> markListDiff = ObservableMap();

  // @computed
  // bool get sortHistoryByRetention => settings?.sortHistoryByRetention ?? false;
  @computed
  SortHistoryList get sortHistory =>
      settings?.sortHistoryList ?? SortHistoryList.boards;
  // @computed
  // bool get viewByBoard => settings?.viewByBoardInHistory ?? false;

  // @computed
  // Map<String, List<ThreadMarkData?>?> get displayList => switch (sortHistory) {
  //       SortHistoryList.boards => markListByBoardId,
  //       // SortHistoryList.deletionDate => markListByBoardId,
  //       // SortHistoryList.hot => markListByBoardId,
  //       SortHistoryList.history => markListByLastReadAt
  //     };

  @computed
  Set<String?> get boardIdSetOfContentList {
    final boardIdSet = markList.map((element) => element?.boardId).toList();

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
        (element) =>
            element?.id == id &&
            (parent.type == Communities.girlsCh ||
                    parent.type == Communities.hatena ||
                    parent.type == Communities.mal
                ? true
                : element?.boardId == boardId),
        orElse: () => null);
  }

  ThreadMarkData? getSelectedMarkDataByUri(final Uri uri) {
    final threadOrBoard = parent.parent.uriIsThreadOrBoard(uri, parent.type);
    if (threadOrBoard == null || !threadOrBoard) {
      return null;
    }
    final threadId = parent.parent.getThreadIdFromUri(uri, parent.type);
    final boardId = parent.parent.getBoardIdFromUri(uri, parent.type);

    if (threadId != null) {
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

  // Future<void> updateThreadsByBoard(final String boardId) async {
  //   final data = markList.firstWhere(
  //     (element) => element?.boardId == boardId,
  //     orElse: () => null,
  //   );
  //   await _updateThreadsByBoard([data]);
  // }

  // Future<void> updateThreadsByLastReadAt(final String keyName) async {
  //   final list = [...?markListByLastReadAt[keyName]];
  //   List<ThreadMarkData?> byBoard = [];
  //   for (final i in list) {
  //     if (i != null) {
  //       final exist = byBoard.firstWhere(
  //         (element) => element?.boardId == i.boardId,
  //         orElse: () => null,
  //       );
  //       if (exist == null) {
  //         byBoard.add(i);
  //       }
  //     }
  //   }
  //   await _updateThreadsByBoard(byBoard, willUpdateList: list);
  // }

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
  Future<void> updateAll() async {
    final list = [...markList];
    final updateList = await _getUpdateDataFromThreads(list);
    if (updateList.isNotEmpty) {
      await _update(updateList);
    }
  }

  Future<void> updateByBoard(final String boardId) async {
    final list = markList
        .where(
          (element) => element?.boardId == boardId,
        )
        .toList();
    final updateList = await _getUpdateDataFromThreads(list);
    if (updateList.isNotEmpty) {
      await _update(updateList);
    }
  }

  Future<void> updateByHistory(final String keyName) async {
    final list = [...?markListByLastReadAt[keyName]];
    final updateList = await _getUpdateDataFromThreads(list);
    if (updateList.isNotEmpty) {
      await _update(updateList);
    }
  }

  Future<void> _update(final List<UpdateFieldData?> value) async {
    final list = [...markList];
    for (final i in value) {
      if (i != null) {
        final exist = list.firstWhere(
          (element) =>
              element != null && element.id == i.id && !element.archived,
          orElse: () => null,
        );

        ThreadMarkData? newData;
        if (exist != null) {
          if (!i.archived) {
            final diff = i.newResCount - exist.resCount;
            setDiffValue(i.id, diff);
            if (diff != 0) {
              final retention =
                  parent.getRetentionSinceEpoch(i.newResCount, exist);
              newData = exist.copyWith(
                  resCount: i.newResCount, retentionPeriodSeconds: retention);
              // setLog(newData);
            }
          } else {
            newData = exist.copyWith(archived: true);
          }
        }
        // logger.d(
        //     'history update: ${i.id}, ${i.newResCount}, ${i.archived}, ${i.boardId}, exist: ${exist?.id}, newData: ${newData?.id}');
        if (newData != null) {
          await parent.parent.repository.updateThreadMark(newData);
        }
      }
    }
  }

  // Future<void> updateAllList() async {
  //   final markListByBoardIdFirstItemList =
  //       markListByBoardId.values.map((e) => e?.firstOrNull).toList();
  //   logger.d(
  //       'history: updateAll:  map:${markListByBoardId.values.length}, markListByBoardIdFirstItemList:${markListByBoardIdFirstItemList.length}');
  //   await _updateThreadsByBoard(markListByBoardIdFirstItemList);
  // }

  // Future<void> _updateThreadsByBoard(final List<ThreadMarkData?> list,
  //     {final List<ThreadMarkData?>? willUpdateList}) async {
  //   final currentRes = {...currentMarksResCount};
  //   for (final b in list) {
  //     if (b != null) {
  //       FetchThreadsResultData? result;
  //       switch (parent.type) {
  //         case Communities.fiveCh:
  //           result = await FiveChHandler.getThreads(
  //               domain: b.uri.host,
  //               directoryName: b.boardId,
  //               boardName: b.boardName ?? '',
  //               forum: Communities.fiveCh);
  //           if (result.result == FetchResult.success) {
  //             await setArchived<ThreadData>(result.threads!, b.boardId);
  //           }

  //           break;
  //         case Communities.girlsCh:
  //           result = await GirlsChHandler.getTitleList(
  //               'topics/category/${b.boardId}',
  //               categoryId: b.boardId);

  //           break;
  //         case Communities.futabaCh:
  //           final selectedBoardThreads =
  //               markList.where((e) => e?.boardId == b.boardId).toList();
  //           List<FutabaChThread?> threadsData = [];
  //           for (final i in selectedBoardThreads) {
  //             if (i != null) {
  //               //   final boardThreads = markList
  //               //       .where((element) => element?.boardId == i.boardId)
  //               //       .toList();
  //               // for (final thread in boardThreads) {
  //               // if (i != null) {
  //               final directory = FutabaData.getDirectoryFromUri(i.uri);
  //               if (directory != null) {
  //                 final data = await FutabaChHandler.getContentByJson(
  //                     directory, b.boardId, i.id);
  //                 if (data == null || data.old == 1) {
  //                   await parent.parent.deleteThreadMarkData(i);
  //                 } else {
  //                   final rescount = data.resCount;
  //                   if (rescount < 1000) {
  //                     final newData = FutabaData.parseFromJson(rescount, i);
  //                     threadsData
  //                         .removeWhere((element) => element?.id == newData?.id);
  //                     threadsData.add(newData);
  //                   }
  //                   // }
  //                   // }
  //                 }
  //               }

  //               // final data = await FutabaChHandler.getContent(
  //               //     b.boardId, b.getSubdomain, b.id);
  //               // if (data.result == FetchResult.error ||
  //               //     data.statusCode == 404) {
  //               //   await parent.parent.deleteThreadMarkData(i);
  //               // } else {
  //               //   final rescount = data.contentList?.lastOrNull?.index;
  //               //   if (rescount != null && i.resCount != 1001) {
  //               //     final newData = FutabaData.parseFromJson(rescount, i);
  //               //     threadsData
  //               //         .removeWhere((element) => element?.id == newData?.id);
  //               //     threadsData.add(newData);
  //               //   }
  //               // }
  //             }
  //           }
  //           result = FetchThreadsResultData(threads: [...threadsData]);
  //           break;
  //         case Communities.pinkCh:
  //           result = await PinkChHandler.getThreads(
  //               domain: b.uri.host,
  //               directoryName: b.boardId,
  //               boardName: b.boardName ?? '');
  //           if (result.result == FetchResult.success) {
  //             await setArchived<ThreadData>(result.threads!, b.boardId);
  //           }

  //           break;
  //         case Communities.machi:
  //           result = await MachiHandler.getThreads(b.boardId);
  //           break;
  //         case Communities.shitaraba:
  //           final boardId = b.boardId;
  //           final category = b.shitarabaCategory;
  //           final boardName =
  //               b.boardName ?? parent.parent.boardNameById(boardId);
  //           result = await ShitarabaHandler.getThreads(
  //               category, boardId, boardName ?? '');
  //         case Communities.open2Ch:
  //           if (b.getSubdomain != null) {
  //             result = await Open2ChHandler.getThreads(
  //                 b.getSubdomain!, b.boardId, b.boardName ?? '');
  //             if (result.result == FetchResult.success) {
  //               await setArchived<ThreadData>(result.threads!, b.boardId);
  //             }
  //           }

  //         case Communities.chan4:
  //           result = await Chan4Handler.getThreads(b.boardId);
  //           if (result.result == FetchResult.success) {
  //             await setArchived<ThreadData>(result.threads!, b.boardId);
  //           }
  //         case Communities.hatena:
  //           // result = await HatenaHandler.getThreads(b.boardId);
  //           List<HatenaThreadData?> resultList = [];
  //           final selectedBoardThreads =
  //               markList.where((e) => e?.boardId == b.boardId).toList();
  //           for (final i in selectedBoardThreads) {
  //             if (i != null) {
  //               final newData = await HatenaHandler.getCount(i.id);
  //               if (newData != null) {
  //                 // final resCount = newData.content!.threadLength;
  //                 logger.d('hatena update: id: ${i.id}, ${newData.$2}');
  //                 final data = HatenaThreadData(
  //                   id: i.id,
  //                   title: i.title,
  //                   dec: '',
  //                   resCount: newData.$2,
  //                   boardId: i.boardId,
  //                   dateUtc:
  //                       DateTime.fromMillisecondsSinceEpoch(i.createdAt ?? 0),
  //                   type: Communities.hatena,
  //                   url: HatenaData.parseThreadPath(i.id),
  //                   // originalUrl: url,
  //                   thumbnailFullUrl: i.thumbnailFullUrl,
  //                   // thumbnailStr: img != null
  //                   //     ? jsonEncode(SrcData(thumbnailUri: img).toJson())
  //                   //     : null,
  //                   // url: '${HatenaData.domain}/${HatenaData.hotentry}/$boardId.rss'
  //                 );
  //                 resultList.add(data);
  //               }
  //             }
  //           }
  //           result = FetchThreadsResultData(threads: [...resultList]);
  //         default:
  //       }
  //       List<ThreadData?> threads = [];
  //       if (willUpdateList != null) {
  //         for (final i in willUpdateList) {
  //           final exist = result?.threads?.firstWhere(
  //               (element) =>
  //                   element?.id == i?.id && element?.boardId == i?.boardId,
  //               orElse: () => null);
  //           if (exist != null) {
  //             threads.add(exist);
  //           }
  //         }
  //       } else {
  //         threads.addAll([...?result?.threads]);
  //       }
  //       _setDiff(
  //         threads,
  //         currentRes,
  //       );
  //     }
  //   }
  // }

  Future<List<UpdateFieldData?>> _getUpdateDataFromThreads(
      final List<ThreadMarkData?> value) async {
    List<UpdateFieldData?> result = [];
    switch (parent.type) {
      case Communities.fiveCh ||
            Communities.pinkCh ||
            Communities.machi ||
            Communities.chan4 ||
            Communities.shitaraba ||
            Communities.open2Ch:
        Set<String?> boardIdSet = {};
        for (final i in value) {
          if (i != null) {
            boardIdSet.add(i.boardId);
          }
        }
        if (boardIdSet.isNotEmpty) {
          List<ThreadMarkData?> byBoardId = [];
          for (final b in boardIdSet) {
            final exist = value.firstWhere(
              (element) =>
                  element != null && element.boardId == b && !element.archived,
              orElse: () => null,
            );
            if (exist != null) {
              byBoardId.add(exist);
            }
          }
          // logger.d('history update: byBoardId: ${byBoardId.length}');
          if (byBoardId.isNotEmpty) {
            for (final k in byBoardId) {
              if (k != null) {
                switch (k.type) {
                  case Communities.fiveCh:
                    final data = await _getFiveChUpdate(k);
                    result.addAll(data);
                  case Communities.pinkCh:
                    final data = await _getPinkChUpdate(k);
                    result.addAll(data);
                  case Communities.open2Ch:
                    final data = await _getOpen2chUpdate(k);
                    result.addAll(data);
                  case Communities.machi:
                    final data = await _getMachiUpdate(k);
                    result.addAll(data);
                  case Communities.shitaraba:
                    final data = await _getShitarabaUpdate(k);
                    result.addAll(data);
                  case Communities.chan4:
                    final data = await _getChan4Update(k);
                    result.addAll(data);
                  default:
                }
              }
            }
          }
        }
        break;
      case Communities.futabaCh:
        for (final i in value) {
          if (i != null) {
            final directory = FutabaData.getDirectoryFromUri(i.uri);
            if (directory != null) {
              final data = await FutabaChHandler.getContentByJson(
                  directory, i.boardId, i.id);
              if (data == null || data.old == 1) {
                await parent.parent.deleteThreadMarkData(i);
              } else {
                final rescount = data.resCount;
                if (rescount < 1000) {
                  final update =
                      UpdateFieldData(id: i.id, newResCount: rescount);
                  result.add(update);
                }
                // }
                // }
              }
            }
          }
        }
      case Communities.hatena:
        for (final i in value) {
          if (i != null) {
            final newData = await HatenaHandler.getCount(i.id);
            if (newData != null) {
              // final resCount = newData.content!.threadLength;
              logger.d('hatena update: id: ${i.id}, ${newData.$2}');
              final update = UpdateFieldData(
                id: i.id,
                newResCount: newData.$2,
              );
              result.add(update);
            }
          }
        }
      case Communities.girlsCh:
        for (final i in value) {
          if (i != null) {
            final data = await GirlsChHandler.getContent(i.id, 1);
            if (data.result == FetchResult.success) {
              final resCount = data.content?.threadLength;
              if (resCount != null && resCount != 0) {
                final update = UpdateFieldData(id: i.id, newResCount: resCount);
                result.add(update);
              } else {
                // await parent.parent.deleteThreadMarkData(i);
              }
            }
          }
        }
      case Communities.mal:
        for (final i in value) {
          if (i != null) {
            final data = await MalHandler.getFieldsFromHtml(i.id);
            final resCount = data?.$2;
            if (resCount != null) {
              final update = UpdateFieldData(id: i.id, newResCount: resCount);
              result.add(update);
            }
          }
        }
      default:
    }
    return result;
  }

  Future<List<UpdateFieldData?>> _getFiveChUpdate(
      final ThreadMarkData value) async {
    final data = await parent.getFiveChThreads(
        value.uri.host, value.boardId, value.boardName ?? '');
    if (data.result != FetchResult.success) {
      return [];
    }
    final threads = data.threads!;
    return _getUpdateListFromFiveChType(threads, value.boardId);
  }

  Future<List<UpdateFieldData?>> _getMachiUpdate(
    final ThreadMarkData value,
  ) async {
    final data = await parent.getMachiThreads(value.boardId);
    if (data.result != FetchResult.success) {
      return [];
    }
    final threads = data.threads!;
    return _getUpdateListFromFiveChType(threads, value.boardId);
  }

  Future<List<UpdateFieldData?>> _getChan4Update(
    final ThreadMarkData value,
  ) async {
    final data = await parent.getChan4Threads(value.boardId);
    if (data.result != FetchResult.success) {
      return [];
    }
    final threads = data.threads!;
    return _getUpdateListFromFiveChType(threads, value.boardId);
  }

  Future<List<UpdateFieldData?>> _getPinkChUpdate(
    final ThreadMarkData value,
  ) async {
    final data = await parent.getPinkChThreads(
        value.uri.host, value.boardId, value.boardName ?? '');
    if (data.result != FetchResult.success) {
      return [];
    }
    final threads = data.threads!;
    return _getUpdateListFromFiveChType(threads, value.boardId);
  }

  Future<List<UpdateFieldData?>> _getOpen2chUpdate(
    final ThreadMarkData value,
  ) async {
    final directory = Open2ChData.getDirectoryFromUri(value.uri);
    if (directory == null) {
      return [];
    }
    final data = await parent.getOpen2chThreads(
        directory, value.boardId, value.boardName ?? '');
    if (data.result != FetchResult.success) {
      return [];
    }
    final threads = data.threads!;
    return _getUpdateListFromFiveChType(threads, value.boardId);
  }

  Future<List<UpdateFieldData?>> _getShitarabaUpdate(
    final ThreadMarkData value,
  ) async {
    final directory = ShitarabaData.getCategoryFromUri(value.uri);
    if (directory == null) {
      return [];
    }
    final data = await parent.getShitarabaThreads(
        directory, value.boardId, value.boardName ?? '');
    if (data.result != FetchResult.success) {
      return [];
    }
    final threads = data.threads!;
    return _getUpdateListFromFiveChType(threads, value.boardId);
  }

  List<UpdateFieldData?> _getUpdateListFromFiveChType(
      final List<ThreadData?> threads, final String boardId) {
    List<UpdateFieldData?> list = [];
    final base =
        markList.where((element) => element?.boardId == boardId).toList();
    for (final i in base) {
      if (i != null) {
        final exist = threads.firstWhere(
            (element) => element?.id == i.id && element?.boardId == i.boardId,
            orElse: () => null);

        if (exist != null) {
          final update = UpdateFieldData(
              id: i.id, newResCount: exist.resCount, boardId: i.boardId);
          // logger.d(
          //     'history update: updated: ${i.id}, ${exist.resCount}, ${i.boardId}');
          list.add(update);
        } else {
          final archived = UpdateFieldData(
              id: i.id,
              newResCount: i.resCount,
              boardId: i.boardId,
              archived: true);
          list.add(archived);
        }
      }
    }
    return list;
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
        parent.type == Communities.open2Ch ||
        parent.type == Communities.mal ||
        parent.type == Communities.hatena ||
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
  // Future<void> _setDiff<T extends ThreadData>(
  //   final List<T?>? result,
  //   final Map<String, int> currentRes,
  // ) async {
  //   if (result == null) return;
  //   // Set<ThreadMarkData?> willDeleteSet = {};
  //   // final list =
  //   //     [...markList.where((element) => element?.boardId == boardId).toList()];
  //   for (final m in markList) {
  //     if (m != null) {
  //       final exist = result.firstWhere(
  //         (element) =>
  //             element?.id == m.id &&
  //             element?.boardId == m.boardId &&
  //             !m.archived,
  //         orElse: () => null,
  //       );
  //       if (exist != null) {
  //         final current = currentRes[m.id];
  //         final diff = exist.resCount - (current ?? exist.resCount);
  //         setDiffValue(m.id, diff);

  //         if (diff != 0) {
  //           final retention = parent.getRetentionSinceEpoch(exist.resCount, m);
  //           final newData = m.copyWith(
  //               resCount: exist.resCount, retentionPeriodSeconds: retention);
  //           // setLog(newData);
  //           await parent.parent.repository.updateThreadMark(newData);
  //         }
  //       } else {
  //         logger.d('_setDiff: ${m.title}');
  //         // willDeleteSet.add(m);
  //       }
  //     }
  //   }
  // }

  @action
  void deleteContentState() => content = null;

  @action
  void clear() {
    markList.clear();
    markListDiff.clear();
    deleteContentState();
  }
}
