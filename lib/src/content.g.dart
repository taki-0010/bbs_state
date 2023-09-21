// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ContentState on ContentStateBase, Store {
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

  late final _$ContentStateBaseActionController =
      ActionController(name: 'ContentStateBase', context: context);

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
initialSeekableIndex: ${initialSeekableIndex},
futabaLimit: ${futabaLimit},
getJumpIndex: ${getJumpIndex},
groupList: ${groupList}
    ''';
  }
}
