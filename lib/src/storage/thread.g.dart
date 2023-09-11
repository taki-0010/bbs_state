// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThreadStateForLocal on ThreadStateForLocalBase, Store {
  late final _$randomStringAtom =
      Atom(name: 'ThreadStateForLocalBase.randomString', context: context);

  @override
  String? get randomString {
    _$randomStringAtom.reportRead();
    return super.randomString;
  }

  @override
  set randomString(String? value) {
    _$randomStringAtom.reportWrite(value, super.randomString, () {
      super.randomString = value;
    });
  }

  late final _$ThreadStateForLocalBaseActionController =
      ActionController(name: 'ThreadStateForLocalBase', context: context);

  @override
  void setRandomStr(Timer timer) {
    final _$actionInfo = _$ThreadStateForLocalBaseActionController.startAction(
        name: 'ThreadStateForLocalBase.setRandomStr');
    try {
      return super.setRandomStr(timer);
    } finally {
      _$ThreadStateForLocalBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
randomString: ${randomString}
    ''';
  }
}
