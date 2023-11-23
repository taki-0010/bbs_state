// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RepositoryState on RepositoryStateBase, Store {
  Computed<List<Communities>?>? _$forumsComputed;

  @override
  List<Communities>? get forums =>
      (_$forumsComputed ??= Computed<List<Communities>?>(() => super.forums,
              name: 'RepositoryStateBase.forums'))
          .value;

  late final _$connectionAtom =
      Atom(name: 'RepositoryStateBase.connection', context: context);

  @override
  ConnectTo get connection {
    _$connectionAtom.reportRead();
    return super.connection;
  }

  @override
  set connection(ConnectTo value) {
    _$connectionAtom.reportWrite(value, super.connection, () {
      super.connection = value;
    });
  }

  late final _$userAtom =
      Atom(name: 'RepositoryStateBase.user', context: context);

  @override
  UserData? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserData? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('RepositoryStateBase.init', context: context);

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$RepositoryStateBaseActionController =
      ActionController(name: 'RepositoryStateBase', context: context);

  @override
  void setUser(UserData? value) {
    final _$actionInfo = _$RepositoryStateBaseActionController.startAction(
        name: 'RepositoryStateBase.setUser');
    try {
      return super.setUser(value);
    } finally {
      _$RepositoryStateBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
connection: ${connection},
user: ${user},
forums: ${forums}
    ''';
  }
}
