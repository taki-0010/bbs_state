// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserState on UserStateBase, Store {
  Computed<UserData?>? _$currentUserComputed;

  @override
  UserData? get currentUser =>
      (_$currentUserComputed ??= Computed<UserData?>(() => super.currentUser,
              name: 'UserStateBase.currentUser'))
          .value;

  late final _$accountAsyncAction =
      AsyncAction('UserStateBase.account', context: context);

  @override
  Future<String?> account() {
    return _$accountAsyncAction.run(() => super.account());
  }

  @override
  String toString() {
    return '''
currentUser: ${currentUser}
    ''';
  }
}
