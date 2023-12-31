import 'importer.dart';
import 'dart:math';

part 'content.g.dart';

class ContentState = ContentStateBase with _$ContentState;

abstract class ContentStateBase with Store, WithDateTime {
  ContentStateBase(
      {
      //   required this.type,
      // required this.contentId,
      // required this.contentBoardId,
      required this.content,
      required this.locale});
  // late MainStoreBase parent;
  // Communities type;
  // String contentId;
  // String contentBoardId;
  late String locale;
  @observable
  ThreadContentData content;

  @observable
  int currentContentIndex = 0;

  // @observable
  // int? lastOpenedIndex;

  @observable
  int? lastResIndex;

  @observable
  double panY = 30.0;

  @observable
  bool showSeekBar = false;

  @observable
  int seekBarHandleValue = 1;

  @observable
  int currentContentItemIndex = 1;

  @observable
  String? selectedText;

  @observable
  TimeagoList timeago = TimeagoList.enable;

  @observable
  String? hoverdOnThumbnailSrc;

  @observable
  double? hot;

  @observable
  RangeList? selectedRange;

  @observable
  int? selectedPage;
  @observable
  int? malOffset;

  @observable
  ObservableMap<String, String?> youtubeChannelLogoSrc = ObservableMap();

  @observable
  ObservableList<ContentData?> youtubeReplies = ObservableList();

  @observable
  YoutubeCommentsListData? ytCommentsListData;

  @observable
  int? ytReplyCount;

  void setYtReplies(final YoutubeCommentsListData? value, final int? rep) {
    _setYtReplyCount(rep);
    _setYtCommentsListData(value);
    _setYoutubeReplies();
  }

  @action
  void _setYtReplyCount(final int? value) => ytReplyCount = value;

  @action
  void _setYtCommentsListData(final YoutubeCommentsListData? value) =>
      ytCommentsListData = value;

  @action
  void _setYoutubeReplies() {
    if (ytCommentsListData?.data == null) {
      return;
    }
    final list = YoutubeData.getComList(ytCommentsListData!.data!);
    youtubeReplies.clear();
    youtubeReplies.addAll(list);
    logger.d('yt: ${list.length}');
  }

  @action
  Future<int?> getNextReplies() async {
    final prev = youtubeReplies.length;
    final result = await ytCommentsListData?.data?.nextPage();
    if (result == null) {
      return null;
    }
    final list = YoutubeData.getComList(result);
    //  logger.d('yt: nextLength: ${list.length}');
    _setYtCommentsListData(YoutubeCommentsListData(data: result));
    youtubeReplies.addAll(list);
    return prev;
  }

  @action
  void setSrc(final String? value) {
    hoverdOnThumbnailSrc = value;
  }

  @action
  void setSelectedText(final String? value) {
    selectedText = value;
  }

  @action
  void setSelectedRangeList(final RangeList? value) {
    selectedRange = value;
    currentContentIndex = 0;
    currentContentItemIndex = 1;
  }

  @action
  void setSelectedPage(final int? value) {
    selectedPage = value;
    currentContentIndex = 0;
    currentContentItemIndex = 1;
  }

  @action
  void setMalOffset(final int? value) {
    malOffset = value;
    currentContentIndex = 0;
    currentContentItemIndex = 1;
  }

  @action
  void setYoutubeChannnelLogoSrc(final String id, final String url) {
    youtubeChannelLogoSrc[id] = url;
  }

  // @observable
  // String? filterWord;

  // @action
  // void setLastResIndex() => lastResIndex = content.content.lastOrNull?.index;

  @action
  void setLastResIndex(final int? value) => lastResIndex = value;

  @action
  void setSeekHandleValue(final int value) => seekBarHandleValue = value;

  @observable
  MalPollBaseJson? malPoll;

  @observable
  MalPaging? malPaging;

  @computed
  int get minIndexForSeekBar {
    final first = (content.content.length) >= 2 ? content.content[1]?.index : 1;
    return first ?? 1;
  }

  @computed
  double get initialSeekableIndex {
    final length = content.content.lastOrNull?.index ?? 1;
    final thu = (currentContentItemIndex / length);
    final result = 60 * thu;
    logger.d(
        'changedContentIndex: $length, currentContentItemIndex:$currentContentItemIndex, thu:$thu, result: $result;');
    if (result >= 1) {
      return result;
    } else {
      return 1;
    }
  }

  @computed
  String? get futabaLimit {
    final first = content.content.firstOrNull;
    if (first is FutabaChContent && first.limit != null) {
      return StringMethodData.replaceText(first.limit!);
    }
    return null;
  }

  @computed
  int get getJumpIndex {
    if (content.content.lastOrNull?.index == null) {
      return 0;
    }
    if (content.content.length < 2) {
      return 0;
    }
    // final firstItemIndex = currentContent!.content[1]!.index;
    final value = panY / 60;
    final result = content.content.lastOrNull!.index * value;
    return result.toInt();
  }

  @computed
  bool get showYtNextCommentsButton {
    if (content.type != Communities.youtube) {
      return false;
    }
    final current = [...content.content];
    if (current.isEmpty) {
      return false;
    }
    if (content.ytComments == null) {
      return false;
    }
    // current.removeAt(0);
    // final total = content.threadLength;
    // if (current.length >= total) {
    //   return false;
    // }
    return true;
  }

  @action
  Future<void> getYtNextComments() async {
    if (content.type != Communities.youtube) {
      return;
    }
    final coms = content.ytComments;
    if (coms == null) {
      return;
    }
    final result = await coms.nextPage();
    if (result == null) {
      content = content.copyWith(ytComments: null);
      return;
    }
    // logger.d('getYtNextComments: old: ${coms.length}, new: ${result?.length}');
    final old = [...content.content];
    final newList = YoutubeData.getComList(result);
    final newData =
        content.copyWith(ytComments: result, content: [...old, ...newList]);
    content = newData;
  }

  @computed
  List<GroupData?> get groupList {
    List<GroupData?> result = [];
    final list = content.content;
    // final list = content.content;
    if (list.isEmpty) {
      return result;
    }
    logger.f('groupList: list: ${list.length}, hot:$hot, timeago: $timeago');
    list.asMap().forEach((final key, final v) {
      if (v != null && v.createdAt != null) {
        final ta =
            getTimeago(v.createdAt!, locale, settings: timeago, hot: hot);
        if (ta != null) {
          final exist = result.firstWhere((element) => element?.date == ta,
              orElse: () => null);
          // logger.i('groupList: item: key:$key, timeAgo: $timeago v:${v.createdAt}');
          if (exist == null) {
            final data = GroupData(date: ta, firstIndex: key);
            result.add(data);
          }
        }
      }
    });
    logger.f('groupList: result: ${result.length}');
    return result;
  }

  @action
  void setTimeago(final TimeagoList value) => timeago = value;

  @computed
  String? get getDefaultName {
    if (content.type == Communities.chan4) {
      return Chan4Data.defaultName;
    }

    final names = content.content.map((e) => e?.name.trim()).toList();
    final counter = <String, int>{};
    for (final value in names) {
      if (value != null) {
        counter.update(value, (count) => count + 1, ifAbsent: () => 1);
      }
    }
    final maxNum = counter.values.reduce(max);
    String? result;
    for (final i in counter.entries) {
      if (i.value == maxNum) {
        result = i.key.trim();
      }
    }
    // if (result != null && result.contains('(') && result.contains(')')) {
    //   return result.substring(0, result.lastIndexOf('('));
    // }

    return result;
  }

  List<int?> filterdIndexList(final String value) {
    if (value.isEmpty) {
      return [];
    }
    if (content.content.isEmpty) {
      return [];
    }
    final result = content.content
        .where((element) =>
            element != null &&
            element.body.toLowerCase().contains(value.toLowerCase()))
        .toList();
    return content.type == Communities.chan4
        ? result.map((e) => (e as Chan4Content?)?.no).toList()
        : result.map((e) => e?.index).toList();
  }

  // @computed
  // List<int?> get filterdIndexList => filterd.map((e) => e?.index).toList();

  @action
  void updateContent(final ThreadContentData? value) {
    if (value != null) {
      content = value;
      final ikioi = getIkioi(value.createdAt ?? 0, value.threadLength);
      setHot(ikioi);
      setMalPaging(value.malOption?.paging);
    }
  }

  @action
  void setPoll(final MalPollBaseJson? poll) {
    malPoll = poll;
  }

  @action
  void setMalPaging(final MalPaging? value) {
    malPaging = value;
  }

  @action
  void setHot(final double value) {
    hot = value;
    logger.d('updateContent: hot: $hot');
  }

  // @action
  // void setFilterWord(final String value) {
  //   filterWord = value;
  // }

  // @action
  // void clearFilterWord() => filterWord = null;

  // @action
  // void setLastOpenedIndex(final int? value) {
  //   lastOpenedIndex = value;
  // }

  // @action
  // void setLastReIndex(final int? value) {
  //   lastResIndex = value;
  // }

  @action
  void setCurrentContentIndex(
    final int value,
  ) {
    if (currentContentIndex != value) {
      try {
        currentContentIndex = value;
        final itemIndex = content.content[value]?.index;
        if (itemIndex != null) {
          if (content.content.length >= 2 &&
              content.content.lastOrNull!.index > 1000 &&
              itemIndex == 1) {
            currentContentItemIndex = content.content[1]!.index;
          } else {
            currentContentItemIndex = itemIndex;
          }
        }
        // logger.i(
        //     'setCurrentContentIndex: value: $value, itemIndex:$itemIndex, currentContentItemIndex: $currentContentItemIndex');
      } catch (e) {
        logger.e('setCurrentContentIndex: $e');
      }
    }
  }

  @action
  void setPanY(final double value) {
    final result = panY + value;
    if (result >= 0 && result <= 60) {
      panY = result;
    }
  }

  @action
  void resetPanY() => panY = initialSeekableIndex;

  @action
  void setShowSeekBar() {
    if (content.content.length >= 2 &&
        content.content.lastOrNull!.index > 1000 &&
        currentContentItemIndex == 1) {
      currentContentItemIndex = content.content[1]!.index;
    } else {
      seekBarHandleValue = currentContentItemIndex;
    }

    showSeekBar = true;
  }

  @action
  void setHideSeekBar() => showSeekBar = false;

  void updateAgree(final Communities type, final int index, final bool good) {
    final indexData =
        content.content.indexWhere((element) => element?.index == index);
    if (indexData != -1) {
      final item = content.content[indexData];
      late ContentData newData;
      switch (type) {
        case Communities.girlsCh:
          if (good) {
            final old = (item as GirlsChContent).plus;
            final newValue = old + 1;
            newData = item.copyWith(plus: newValue);
          } else {
            final old = (item as GirlsChContent).minus;
            final newValue = old - 1;
            newData = item.copyWith(minus: newValue);
          }
          break;
        default:
      }
      final old = [...content.content];
      old.removeAt(indexData);
      old.insert(indexData, newData);
      final newContent = content.copyWith(content: old);
      updateContent(newContent);
    }
  }

  String? getIdCount(final int currentIndex, final String? selfId) {
    if (selfId == null || selfId.isEmpty) {
      return null;
    }
    // logger.d('getIdCount: $selfId');
    final count = content.content
        .where((element) => element?.getPostId == selfId)
        .toList();
    if (count.isEmpty || count.length == 1) {
      return null;
    }
    final before = count
        .where((element) => element != null && element.index <= currentIndex)
        .toList();
    final result = '${before.length} / ${count.length}';
    return result;
  }

  List<int?> getResCount(
    final int index,
  ) {
    final list = content.content;
    List<int?> result = [];
    final target = '>>$index';
    for (final i in list) {
      if (i != null && i.anchorList.contains(target)) {
        result.add(i.index);
      }
    }
    return result;
  }

  List<int?> getNoCount(
    final int no,
  ) {
    final list = content.content;
    List<int?> result = [];
    final target = '>>$no';
    for (final i in list) {
      if (i is Chan4Content && i.anchorList.contains(target)) {
        result.add(i.no);
      }
    }
    return result;
  }

  List<int?> getResCountForFutaba(
      final FutabaChContent self, final List<String> targetBody) {
    final list = content.content;
    final targetNumber = 'No.${self.number}';
    // final targetBody = self.body.splitLines();
    final targetSrc = self.srcContent;
    // final targetBody = self.body.replaceAll(RegExp(r'>+.+'), '');
    // logger.d('getResCountForFutaba: index: ${self.index}, targetbody: $targetBody, raw: ${self.body}');
    final result = list.map((final e) {
      if (e is FutabaChContent && e.anchorList.isNotEmpty) {
        final existNum = e.anchorList.firstWhere(
          (final element) {
            return element != null &&
                element.isNotEmpty &&
                e.index != self.index &&
                targetNumber.contains(element);
          },
          orElse: () => null,
        );
        final existSrc = e.anchorList.firstWhere(
          (final element) {
            return element != null &&
                element.isNotEmpty &&
                e.index != self.index &&
                targetSrc != null &&
                targetSrc.contains(element);
          },
          orElse: () => null,
        );
        final existText = e.anchorList.firstWhere(
          (final element) {
            return element != null &&
                element.isNotEmpty &&
                e.index != self.index &&
                targetBody
                    .firstWhere(
                      (final el) => el.isNotEmpty && el == element,
                      orElse: () => '',
                    )
                    .isNotEmpty;
          },
          orElse: () => null,
        );
        return (existNum != null || existText != null || existSrc != null)
            ? e.index
            : null;
      }
    }).toList();
    return result.whereType<int>().toList();
  }

  String? getUserIdList(
    final int index,
    final String? selfId,
  ) {
    if (selfId == null) return null;
    final list = content.content;
    final idList =
        list.map((e) => e?.getUserId == selfId ? e?.getUserId : null).toList();
    final total = idList.where((element) => element == selfId).toList().length;
    List<String?> beforeList = [];
    idList.asMap().forEach((final key, final value) {
      if (key < index && value != null) {
        beforeList.add(value);
      }
    });
    final result = '${beforeList.length} / $total';
    return result;
  }

  @computed
  bool get showBottomChip {
    return (rangeListBy1000Steps != null && rangeListBy1000Steps!.isNotEmpty) ||
        futabaLimit != null ||
        content.girlsPages != null ||
        malPoll != null ||
        malPaging != null ||
        showYtNextCommentsButton;
  }

  @computed
  bool get showThreadCommentsCount {
    return content.type == Communities.youtube;
  }

  @computed
  int? get threadCommentsCount {
    if (showThreadCommentsCount && content.threadLength >1) {
      return content.threadLength;
    }
    return null;
  }

  @computed
  List<RangeList?>? get rangeListBy1000Steps {
    if (content.type != Communities.shitaraba) {
      return null;
    }
    return ShitarabaData.getRangeList(content.threadLength);
  }
}
