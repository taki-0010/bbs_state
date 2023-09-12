// import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart' as path;

import 'importer.dart';

part 'repository.g.dart';

class RepositoryState = RepositoryStateBase with _$RepositoryState;

abstract class RepositoryStateBase with Store, WithDateTime {
  RepositoryStateBase({required this.parent});
  late MainStoreBase parent;
  late Database db;
  late Database mediaCache;
  // late final SembastCacheStore store;
  late final server = AppwriteState(parent: this);

  late final threadLocal = ThreadStateForLocal(parent: this);
  late final userLocal = UserStateForLocal(parent: this);
  late final forumLocal = ForumStateForLocal(parent: this);
  late final mediaLocal = MediaCacheState(parent: this);

  @observable
  ConnectTo connection = ConnectTo.local;

  @observable
  UserData? user;

  @computed
  List<Communities>? get forums => user?.forums;

  @action
  Future<void> init() async {
    // final dir = Directory('vault');
    // // Temporary database file for a shared store
    // final path = '${dir.path}/main.sdb';
    // store = await newSembastLocalCacheStore(path: path);
    final dir = await getApplicationDocumentsDirectory();
// make sure it exists
    await dir.create(recursive: true);
    final folder =
        PlatformData.instance.isDebugMode ? 'forumbookDBdebug' : 'forumbookDB';
    final filePath = '$folder/database.db';
    final mediaCachePath = '$folder/mediaCache.db';
    final dbPath = path.join(dir.path, filePath);
    final mediaCachePathData = path.join(dir.path, mediaCachePath);
// open the database
    db = await databaseFactoryIo.openDatabase(dbPath);
    mediaCache = await databaseFactoryIo.openDatabase(mediaCachePathData);
    // String dbPath = 'samplesembast.db';
    // DatabaseFactory dbFactory = databaseFactoryIo;
    // db = await dbFactory.openDatabase(dbPath);
    final accountExist = await server.init();
    if (!accountExist) {
      connection = ConnectTo.local;
      await userLocal.init();
      await threadLocal.init();
      await forumLocal.init();
    } else {
      connection = ConnectTo.server;
    }
    logger.d(
        'repository: init: connection: $connection, user: ${user?.toJson()}');
  }

  @action
  void setUser(final UserData? value) => user = value;

  Future<void> addForum(final Communities value) async {
    if (user == null) return;
    final copied = [...forums!];
    if (copied.contains(value)) return;
    copied.add(value);
    final newUserData = user!.copyWith(forums: copied);
    final forum = InitialForumData.getInitialSettings(value, user!.id);
    if (forum == null) return;
    switch (connection) {
      case ConnectTo.server:
        await server.forumState.addNewForum(forum);
        await server.userState.updateUser(newUserData);
        break;
      case ConnectTo.local:
        await forumLocal.addForum(forum);
        await userLocal.update(newUserData);
      default:
    }
    setUser(newUserData);
    setForumSettings(forum);
  }

  Future<void> removeForum(final Communities value) async {
    if (user == null) return;
    final copied = [...forums!];
    copied.removeWhere((element) => element == value);
    final newUserData = user!.copyWith(forums: copied);
    switch (connection) {
      case ConnectTo.server:
        await server.forumState.deleteForum(value, user!.id);
        await server.userState.updateUser(newUserData);
        break;
      case ConnectTo.local:
        await forumLocal.deleteData(value, user!.id);
        await userLocal.update(newUserData);
        await threadLocal.clearForumThreads(value);
        break;
      default:
    }
    setUser(newUserData);
    parent.setSelectedForum(0);
    _clearForumThreads(value);
  }

  void _clearForumThreads(final Communities value) {
    switch (value) {
      case Communities.fiveCh:
        parent.fiveCh.clear();
        break;
      case Communities.girlsCh:
        parent.girlsCh.clear();
        break;
      case Communities.futabaCh:
        parent.futabaCh.clear();
        break;
      case Communities.pinkCh:
        parent.pinkCh.clear();
        break;
      default:
    }
  }

  Future<void> saveThreadMark(final ThreadMarkData value) async {
    //  final newData = value.copyWith(
    //     retentionPeriodSeconds:
    //         DateTime.now().add(Duration(minutes: 1)).millisecondsSinceEpoch);
    switch (connection) {
      case ConnectTo.server:
        await server.threadState.saveThreadMark(value);

        break;
      case ConnectTo.local:
        await threadLocal.saveThreadMark(value);
        setThreadData(value);
        break;
      default:
    }
    logger.i('repo: saveThread: ${value.toJson()}');
  }

  Future<void> updateThreadMark(final ThreadMarkData value) async {
    switch (connection) {
      case ConnectTo.server:
        await server.threadState.updateThreadMark(value);
        break;
      case ConnectTo.local:
        await threadLocal.updateThreadMark(value);
        setThreadData(value);
        break;
      default:
    }
    logger.i('repo: updateThread: ${value.toJson()}');
  }

  Future<void> deleteThread(final ThreadMarkData value) async {
    switch (connection) {
      case ConnectTo.server:
        await server.threadState.deleteThreadMark(value);
        break;
      case ConnectTo.local:
        await threadLocal.deleteCacheByDataId(value.documentId);
        deleteThreadData(value);
      default:
    }
  }

  Future<void> clearThreads(final List<ThreadMarkData?> value) async {
    switch (connection) {
      case ConnectTo.server:
        await server.threadState.clearThreads(value);
        break;
      case ConnectTo.local:
        await threadLocal.clearThreads(value);
      default:
    }
  }

  Future<void> updateForumSettings() async {
    switch (connection) {
      case ConnectTo.server:
        await server.forumState.update();
        break;
      case ConnectTo.local:
        await forumLocal.updateData();
      default:
    }
  }

  Future<void> updateUserData(final UserData value) async {
    switch (connection) {
      case ConnectTo.server:
        await server.userState.updateUser(value);
        break;
      case ConnectTo.local:
        await userLocal.update(value);
      default:
    }
    setUser(value);
  }

  Future<void> removeUserData() async {
    switch (connection) {
      case ConnectTo.server:
        await server.userState.removeUserData();
        break;
      default:
    }
  }

  void setSettingsData(final List<ForumSettingsData?> list) {
    // if (doc.documents.isNotEmpty) {
    //   final docList =
    //       doc.documents.map((e) => ForumSettingsData.fromJson(e.data)).toList();
    for (final d in list) {
      if (d != null) {
        setForumSettings(d);
      }
    }
  }

  void setForumSettings(final ForumSettingsData value) {
    logger.d('repository: setForumSettings: ${value.forum}');
    switch (value.forum) {
      case Communities.fiveCh:
        parent.fiveCh.setSettings(value);
        break;
      case Communities.girlsCh:
        parent.girlsCh.setSettings(value);
        break;
      case Communities.futabaCh:
        parent.futabaCh.setSettings(value);
        break;
      case Communities.pinkCh:
        parent.pinkCh.setSettings(value);
        break;
      default:
    }
  }

  void setThreadData(final ThreadMarkData? value) {
    if (value != null) {
      switch (value.type) {
        case Communities.fiveCh:
          parent.fiveCh.history.setLog(value);
          break;
        case Communities.girlsCh:
          parent.girlsCh.history.setLog(value);
          break;
        case Communities.futabaCh:
          parent.futabaCh.history.setLog(value);
          break;
        case Communities.pinkCh:
          parent.pinkCh.history.setLog(value);
          break;
        default:
      }
    }
  }

  void deleteThreadById(final String id) {}

  void deleteThreadData(final ThreadMarkData? value,
      {final bool showSnack = true}) {
    if (value != null) {
      switch (value.type) {
        case Communities.fiveCh:
          parent.fiveCh.deleteContent(value);
          break;
        case Communities.girlsCh:
          parent.girlsCh.deleteContent(value);
          break;
        case Communities.futabaCh:
          parent.futabaCh.deleteContent(value);
          break;
        case Communities.pinkCh:
          parent.pinkCh.deleteContent(value);
          break;
        default:
      }
      if (showSnack) {
        parent.setDeletedThreadTitle(value.title);
      }

      mediaLocal.deleteThreadCacheByThreadMarkId(value);
    }
  }
}
