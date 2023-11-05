// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContentState on ContentStateBase, Store {
  Computed<int>? _$minIndexForSeekBarComputed;

  @override
  int get minIndexForSeekBar => (_$minIndexForSeekBarComputed ??= Computed<int>(
          () => super.minIndexForSeekBar,
          name: 'ContentStateBase.minIndexForSeekBar'))
      .value;
  Computed<double>? _$initialSeekableIndexComputed;

  @override
  double get initialSeekableIndex => (_$initialSeekableIndexComputed ??=
          Computed<double>(() => super.initialSeekableIndex,
              name: 'ContentStateBase.initialSeekableIndex'))
      .value;
  Computed<String?>? _$futabaLimitComputed;

  @override
  String? get futabaLimit =>
      (_$futabaLimitComputed ??= Computed<String?>(() => super.futabaLimit,
              name: 'ContentStateBase.futabaLimit'))
          .value;
  Computed<int>? _$getJumpIndexComputed;

  @override
  int get getJumpIndex =>
      (_$getJumpIndexComputed ??= Computed<int>(() => super.getJumpIndex,
              name: 'ContentStateBase.getJumpIndex'))
          .value;
  Computed<List<GroupData?>>? _$groupListComputed;

  @override
  List<GroupData?> get groupList =>
      (_$groupListComputed ??= Computed<List<GroupData?>>(() => super.groupList,
              name: 'ContentStateBase.groupList'))
          .value;
  Computed<String?>? _$getDefaultNameComputed;

  @override
  String? get getDefaultName => (_$getDefaultNameComputed ??= Computed<String?>(
          () => super.getDefaultName,
          name: 'ContentStateBase.getDefaultName'))
      .value;
  Computed<bool>? _$showBottomChipComputed;

  @override
  bool get showBottomChip =>
      (_$showBottomChipComputed ??= Computed<bool>(() => super.showBottomChip,
              name: 'ContentStateBase.showBottomChip'))
          .value;
  Computed<List<RangeList?>?>? _$rangeListBy1000StepsComputed;

  @override
  List<RangeList?>? get rangeListBy1000Steps =>
      (_$rangeListBy1000StepsComputed ??= Computed<List<RangeList?>?>(
              () => super.rangeListBy1000Steps,
              name: 'ContentStateBase.rangeListBy1000Steps'))
          .value;

  late final _$contentAtom =
      Atom(name: 'ContentStateBase.content', context: context);

  @override
  ThreadContentData get content {
    _$contentAtom.reportRead();
    return super.content;
  }

  @override
  set content(ThreadContentData value) {
    _$contentAtom.reportWrite(value, super.content, () {
      super.content = value;
    });
  }

  late final _$currentContentIndexAtom =
      Atom(name: 'ContentStateBase.currentContentIndex', context: context);

  @override
  int get currentContentIndex {
    _$currentContentIndexAtom.reportRead();
    return super.currentContentIndex;
  }

  @override
  set currentContentIndex(int value) {
    _$currentContentIndexAtom.reportWrite(value, super.currentContentIndex, () {
      super.currentContentIndex = value;
    });
  }

  late final _$lastResIndexAtom =
      Atom(name: 'ContentStateBase.lastResIndex', context: context);

  @override
  int? get lastResIndex {
    _$lastResIndexAtom.reportRead();
    return super.lastResIndex;
  }

  @override
  set lastResIndex(int? value) {
    _$lastResIndexAtom.reportWrite(value, super.lastResIndex, () {
      super.lastResIndex = value;
    });
  }

  late final _$panYAtom = Atom(name: 'ContentStateBase.panY', context: context);

  @override
  double get panY {
    _$panYAtom.reportRead();
    return super.panY;
  }

  @override
  set panY(double value) {
    _$panYAtom.reportWrite(value, super.panY, () {
      super.panY = value;
    });
  }

  late final _$showSeekBarAtom =
      Atom(name: 'ContentStateBase.showSeekBar', context: context);

  @override
  bool get showSeekBar {
    _$showSeekBarAtom.reportRead();
    return super.showSeekBar;
  }

  @override
  set showSeekBar(bool value) {
    _$showSeekBarAtom.reportWrite(value, super.showSeekBar, () {
      super.showSeekBar = value;
    });
  }

  late final _$seekBarHandleValueAtom =
      Atom(name: 'ContentStateBase.seekBarHandleValue', context: context);

  @override
  int get seekBarHandleValue {
    _$seekBarHandleValueAtom.reportRead();
    return super.seekBarHandleValue;
  }

  @override
  set seekBarHandleValue(int value) {
    _$seekBarHandleValueAtom.reportWrite(value, super.seekBarHandleValue, () {
      super.seekBarHandleValue = value;
    });
  }

  late final _$currentContentItemIndexAtom =
      Atom(name: 'ContentStateBase.currentContentItemIndex', context: context);

  @override
  int get currentContentItemIndex {
    _$currentContentItemIndexAtom.reportRead();
    return super.currentContentItemIndex;
  }

  @override
  set currentContentItemIndex(int value) {
    _$currentContentItemIndexAtom
        .reportWrite(value, super.currentContentItemIndex, () {
      super.currentContentItemIndex = value;
    });
  }

  late final _$selectedTextAtom =
      Atom(name: 'ContentStateBase.selectedText', context: context);

  @override
  String? get selectedText {
    _$selectedTextAtom.reportRead();
    return super.selectedText;
  }

  @override
  set selectedText(String? value) {
    _$selectedTextAtom.reportWrite(value, super.selectedText, () {
      super.selectedText = value;
    });
  }

  late final _$timeagoAtom =
      Atom(name: 'ContentStateBase.timeago', context: context);

  @override
  TimeagoList get timeago {
    _$timeagoAtom.reportRead();
    return super.timeago;
  }

  @override
  set timeago(TimeagoList value) {
    _$timeagoAtom.reportWrite(value, super.timeago, () {
      super.timeago = value;
    });
  }

  late final _$hotAtom = Atom(name: 'ContentStateBase.hot', context: context);

  @override
  double? get hot {
    _$hotAtom.reportRead();
    return super.hot;
  }

  @override
  set hot(double? value) {
    _$hotAtom.reportWrite(value, super.hot, () {
      super.hot = value;
    });
  }

  late final _$selectedRangeAtom =
      Atom(name: 'ContentStateBase.selectedRange', context: context);

  @override
  RangeList? get selectedRange {
    _$selectedRangeAtom.reportRead();
    return super.selectedRange;
  }

  @override
  set selectedRange(RangeList? value) {
    _$selectedRangeAtom.reportWrite(value, super.selectedRange, () {
      super.selectedRange = value;
    });
  }

  late final _$selectedPageAtom =
      Atom(name: 'ContentStateBase.selectedPage', context: context);

  @override
  int? get selectedPage {
    _$selectedPageAtom.reportRead();
    return super.selectedPage;
  }

  @override
  set selectedPage(int? value) {
    _$selectedPageAtom.reportWrite(value, super.selectedPage, () {
      super.selectedPage = value;
    });
  }

  late final _$malOffsetAtom =
      Atom(name: 'ContentStateBase.malOffset', context: context);

  @override
  int? get malOffset {
    _$malOffsetAtom.reportRead();
    return super.malOffset;
  }

  @override
  set malOffset(int? value) {
    _$malOffsetAtom.reportWrite(value, super.malOffset, () {
      super.malOffset = value;
    });
  }

  late final _$malPollAtom =
      Atom(name: 'ContentStateBase.malPoll', context: context);

  @override
  MalPollBaseJson? get malPoll {
    _$malPollAtom.reportRead();
    return super.malPoll;
  }

  @override
  set malPoll(MalPollBaseJson? value) {
    _$malPollAtom.reportWrite(value, super.malPoll, () {
      super.malPoll = value;
    });
  }

  late final _$malPagingAtom =
      Atom(name: 'ContentStateBase.malPaging', context: context);

  @override
  MalPaging? get malPaging {
    _$malPagingAtom.reportRead();
    return super.malPaging;
  }

  @override
  set malPaging(MalPaging? value) {
    _$malPagingAtom.reportWrite(value, super.malPaging, () {
      super.malPaging = value;
    });
  }

  late final _$ContentStateBaseActionController =
      ActionController(name: 'ContentStateBase', context: context);

  @override
  void setSelectedText(String? value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setSelectedText');
    try {
      return super.setSelectedText(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedRangeList(RangeList? value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setSelectedRangeList');
    try {
      return super.setSelectedRangeList(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSelectedPage(int? value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setSelectedPage');
    try {
      return super.setSelectedPage(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMalOffset(int? value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setMalOffset');
    try {
      return super.setMalOffset(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLastResIndex(int? value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setLastResIndex');
    try {
      return super.setLastResIndex(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSeekHandleValue(int value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setSeekHandleValue');
    try {
      return super.setSeekHandleValue(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTimeago(TimeagoList value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setTimeago');
    try {
      return super.setTimeago(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateContent(ThreadContentData? value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.updateContent');
    try {
      return super.updateContent(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPoll(MalPollBaseJson? poll) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setPoll');
    try {
      return super.setPoll(poll);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMalPaging(MalPaging? value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setMalPaging');
    try {
      return super.setMalPaging(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHot(double value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setHot');
    try {
      return super.setHot(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentContentIndex(int value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setCurrentContentIndex');
    try {
      return super.setCurrentContentIndex(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPanY(double value) {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setPanY');
    try {
      return super.setPanY(value);
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetPanY() {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.resetPanY');
    try {
      return super.resetPanY();
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setShowSeekBar() {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setShowSeekBar');
    try {
      return super.setShowSeekBar();
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHideSeekBar() {
    final _$actionInfo = _$ContentStateBaseActionController.startAction(
        name: 'ContentStateBase.setHideSeekBar');
    try {
      return super.setHideSeekBar();
    } finally {
      _$ContentStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
content: ${content},
currentContentIndex: ${currentContentIndex},
lastResIndex: ${lastResIndex},
panY: ${panY},
showSeekBar: ${showSeekBar},
seekBarHandleValue: ${seekBarHandleValue},
currentContentItemIndex: ${currentContentItemIndex},
selectedText: ${selectedText},
timeago: ${timeago},
hot: ${hot},
selectedRange: ${selectedRange},
selectedPage: ${selectedPage},
malOffset: ${malOffset},
malPoll: ${malPoll},
malPaging: ${malPaging},
minIndexForSeekBar: ${minIndexForSeekBar},
initialSeekableIndex: ${initialSeekableIndex},
futabaLimit: ${futabaLimit},
getJumpIndex: ${getJumpIndex},
groupList: ${groupList},
getDefaultName: ${getDefaultName},
showBottomChip: ${showBottomChip},
rangeListBy1000Steps: ${rangeListBy1000Steps}
    ''';
  }
}
