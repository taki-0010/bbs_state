// import 'dart:convert';

// import 'package:appwrite/models.dart';

import 'dart:convert';

import '../importer.dart';

part 'user.g.dart';

class UserState = UserStateBase with _$UserState;

abstract class UserStateBase with Store {
  UserStateBase({required this.parent});
  late AppwriteStateBase parent;
  static final faild = ProcessResults.failed;
  static final success = ProcessResults.success;

  // @observable
  // bool loading = false;

  // static const dbCollectionId = '64dac55c112d814e0629';

  RealtimeSubscription? subscription;
  String get dbCollectionId => AppwriteData.usersDbCollectionId;

  @computed
  UserData? get currentUser => parent.parent.user;

  // late final subscription = parent.realtime.subscribe(
  //     ['databases.${parent.dbID}.collections.$dbCollectionId.documents']);

  // static const searchWords = ['ニュース', 'スポーツ', '天気'];

  // @computed
  // Future<User> get getUserAccount async => await parent.account.get();

  // @observable
  // UserData? user;

  // @computed
  // Future<String?> get currentSessionId async {
  //   final list = await parent.account.listSessions();
  //   final session = list.sessions.where(
  //     (element) => element.userId == currentUser?.id,
  //   );
  //   if (session.isNotEmpty) {
  //     return session.firstOrNull?.$id;
  //   }
  //   return null;
  // }



  @action
  Future<String?> account() async {
    // user = await parent.account.get();
    try {
      final userAccount = await parent.account.get();
      // final userAccount = await getUserAccount;
      logger.i('user: ${userAccount.$id}, ${userAccount.status}, ');
      await _getUser(userId: userAccount.$id);
      // await parent.forumState.getForumSettings(userId: userAccount.$id);
      return userAccount.$id;
    } on AppwriteException catch (e) {
      logger.e('account: $e');
      // if (e.code == 401) {
      //   return await _createInitialData();
      // }
      return null;
    }
  }

  // Future<String?> _createInitialData() async {
  //   try {
  //     final result = await parent.account.createAnonymousSession();
  //     logger.i(
  //         '_createInitialData: ${result.userId}, session: ${result.toMap()}');
  //     // await Future.delayed(Duration(seconds: 2));
  //     // await _getUser(userId: result.userId);
  //     await createUser(result.userId);
  //     await _getUser(userId: result.userId);
  //     // await parent.forumState.getForumSettings(userId: result.userId);

  //     return result.userId;
  //   } catch (e) {
  //     logger.e('_createInitialData: $e');
  //     return null;
  //   }
  // }

  Future<void> createUser(final String userId) async {
    final result = await parent.functions.createExecution(
        functionId: AppwriteData.funcIdCreateUser, data: userId);
    logger.i(
        'createUser: ${result.status}, per: ${result.$permissions}, res: ${result.response}');
    // final userData = UserData.fromJson(jsonDecode(result.response)['userData']);
    // user = userData;
  }

  // @action
  Future<void> updateUser(final UserData value) async {
    logger.i('updateUser: ${value.toJson()}');
    await parent.databases.updateDocument(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        documentId: value.id,
        data: value.toJson());
    // user = value;
    // parent.parent.setUser(value);
  }

  // @action
  Future<void> _getUser({required final String userId}) async {
    // final ac = await parent.account
    final doc = await parent.databases.getDocument(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        documentId: userId);
    final value = UserData.fromJson(doc.data);
    parent.parent.setUser(value);
    // user = userData;
    // subscription = parent.realtime.subscribe([
    //   'databases.${parent.dbID}.collections.$dbCollectionId.documents.$userId'
    // ]);
    // subscription!.stream.listen((event) {
    //   logger.d('liten user: ${event.payload}');
    // });
  }

  Future<void> deleteForumSettingsList() async {
    final current = parent.parent.forums;
    // final current = user?.forums;
    if (current == null) return;
    for (final i in current) {
      await parent.forumState.deleteForum(i, currentUser!.id);
      // await parent.forumState.deleteForum(i, user!.id);
    }
  }

  // Future<void> setAddedFont(final String value) async {
  //   final current = [...?user?.addedFonts];
  //   current.removeWhere((element) => element == value);
  //   current.insert(0, value);
  //   final newData = user!.copyWith(addedFonts: current);
  //   await _updateUser(newData);
  // }

  // Future<void> setLastOpenedForum(final Communities selected) async {
  //   final newData = currentUser!.copyWith(lastOpenedForum: selected);
  //   await _updateUser(newData);
  // }

  // @action
  void _removeUser() => parent.parent.setUser(null);

  Future<void> removeUserData() async {
    // final data = await getUserAccount;
    // final sessions = await parent.account.listSessions();
    // if (sessions.sessions.isNotEmpty) {
    //   for (final s in sessions.sessions) {
    //     logger.f('session: ${s.$id}, ${s.userId}');
    //     await parent.account.deleteSession(sessionId: s.$id);
    //   }
    // }
    if (currentUser == null) return;
    parent.parent.parent.toggleEntireLoading();
    final result = await parent.functions.createExecution(
        functionId: AppwriteData.funcIdDeleteUserAccount, data: currentUser!.id);
    final success = jsonDecode(result.response)['success'];
    logger.i('success: $success');
    if (success is bool && success) {
      // final sessions = await parent.account.listSessions();
      // if (sessions.sessions.isNotEmpty) {
      //   for (final s in sessions.sessions) {
      //     logger.f('session: ${s.$id}, ${s.userId}');
      //     await parent.account.deleteSession(sessionId: s.$id);
      //   }
      // }
      _removeUser();
      parent.parent.parent.toggleEntireLoading();
      parent.parent.parent.setLaunchStatus(LaunchStatus.close);
    }
  }

  // @action
  // void toggleLoading() => loading = !loading;
}
