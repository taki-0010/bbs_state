import 'importer.dart';

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
  double? hot;

  @action
  void setSelectedText(final String? value) {
    selectedText = value;
  }

  // @observable
  // String? filterWord;

  // @action
  // void setLastResIndex() => lastResIndex = content.content.lastOrNull?.index;

  @action
  void setLastResIndex(final int? value) => lastResIndex = value;

  @action
  void setSeekHandleValue(final int value) => seekBarHandleValue = value;

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

  // @computed
  // List<ContentData?> get filterd {
  //   if (filterWord == null || filterWord!.isEmpty) {
  //     return content.content;
  //   }
  //   if (content.content.isEmpty) {
  //     return [];
  //   }
  //   final result = content.content
  //       .where((element) =>
  //           element != null &&
  //           element.body.toLowerCase().contains(filterWord!.toLowerCase()))
  //       .toList();
  //   return result;
  // }
  // @computed
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
    return result.map((e) => e?.index).toList();
  }

  // @computed
  // List<int?> get filterdIndexList => filterd.map((e) => e?.index).toList();

  @action
  void updateContent(final ThreadContentData? value) {
    if (value != null) {
      content = value;
      setHot(value.hot);
    }
   
  }

  @action
  void setHot(final double value){
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
    if (selfId == null) {
      return null;
    }
    final count = content.content
        .where((element) => element?.getPostId == selfId)
        .toList();
    final before = count
        .where((element) => element != null && element.index <= currentIndex)
        .toList();
    final result = '${before.length} / ${count.length}';
    return count.length == 1 ? null : result;
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
}
