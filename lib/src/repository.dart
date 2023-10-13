// import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart' as path;

import 'importer.dart';

part 'repository.g.dart';

class RepositoryState = RepositoryStateBase with _$RepositoryState;

abstract class RepositoryStateBase with Store, WithDateTime {
  RepositoryStateBase({required this.parent});
  late MainStoreBase parent;
  late Database db;
  // late Database mediaCache;

  late String cacheFolderPath;
  // late final SembastCacheStore store;
  late final server = AppwriteState(parent: this);

  late final threadLocal = ThreadStateForLocal(parent: this);
  late final userLocal = UserStateForLocal(parent: this);
  late final forumLocal = ForumStateForLocal(parent: this);
  late final mediaLocal = MediaCacheState(parent: this);
  late final postDraftLocal = PostDraftStateForLocal(parent: this);

  @observable
  ConnectTo connection = ConnectTo.local;

  @observable
  UserData? user;

  @computed
  List<Communities>? get forums => user?.forums;

  @action
  Future<void> init() async {
    late Directory cacheDir;
    try {
      cacheDir = await getApplicationCacheDirectory();
    } catch (e) {
      logger.e(e);
      return;
    }

    logger.i('cacheState: dir: ${cacheDir.path}');
    await cacheDir.create();
    final folder =
        PlatformData.instance.isDebugMode ? 'forumbookDBdebug' : 'forumbookDB';
    await _postDraftInit(cacheDir, folder);
    await _mediaInit(cacheDir, folder);
    await _threadInit(cacheDir, folder);

    final dir = await getApplicationSupportDirectory();
    await dir.create();
    final filePath = '$folder/database.db';
    final dbPath = path.join(dir.path, filePath);
    db = await databaseFactoryIo.openDatabase(dbPath);
  }

  @action
  Future<void> loadInitialData() async {
    await userLocal.init();
    await threadLocal.loadCache();
    await forumLocal.load();
    // final accountExist = await server.init();
    // if (!accountExist) {
    //   connection = ConnectTo.local;
    // } else {
    //   connection = ConnectTo.server;
    // }
    logger.d(
        'repository: init: connection: $connection, user: ${user?.toJson()}');
  }

  Future<void> _mediaInit(final Directory cacheDir, final String folder) async {
    cacheFolderPath = path.join(cacheDir.path, '$folder/');
    final mediaCachePath = '$folder/mediaCache.db';
    final mediaCacheDbPath = path.join(cacheDir.path, mediaCachePath);
    await mediaLocal.init(mediaCacheDbPath);
  }

  Future<void> _threadInit(
      final Directory cacheDir, final String folder) async {
    final threadCachePath = '$folder/threadCache.db';
    final threadCacheDbPath = path.join(cacheDir.path, threadCachePath);
    await threadLocal.init(threadCacheDbPath);
  }

  Future<void> _postDraftInit(
      final Directory cacheDir, final String folder) async {
    final postDraftCachePath = '$folder/postDraftCache.db';
    final postDraftCacheDbPath = path.join(cacheDir.path, postDraftCachePath);
    await postDraftLocal.init(postDraftCacheDbPath);
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
    mediaLocal.deleteForumData(value);
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
      case Communities.machi:
        parent.machi.clear();
        break;
      case Communities.shitaraba:
        parent.shitaraba.clear();
        break;
      case Communities.open2Ch:
        parent.open2ch.clear();
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

  Future<void> updateForumSettings({final ForumSettingsData? settings}) async {
    switch (connection) {
      case ConnectTo.server:
        await server.forumState.update();
        break;
      case ConnectTo.local:
        await forumLocal.updateData(settings: settings);
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
      case Communities.machi:
        parent.machi.setSettings(value);
        break;
      case Communities.shitaraba:
        parent.shitaraba.setSettings(value);
        break;
      case Communities.open2Ch:
        parent.open2ch.setSettings(value);
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
        case Communities.machi:
          parent.machi.history.setLog(value);
          break;
        case Communities.shitaraba:
          parent.shitaraba.history.setLog(value);
          break;
        case Communities.open2Ch:
          parent.open2ch.history.setLog(value);
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
        case Communities.machi:
          parent.machi.deleteContent(value);
          break;
        case Communities.shitaraba:
          parent.shitaraba.deleteContent(value);
          break;
        case Communities.open2Ch:
          parent.open2ch.deleteContent(value);
          break;
        default:
      }
      if (showSnack) {
        parent.setDeletedThreadTitle(value.title);
      }

      mediaLocal.deleteCacheWhenThreadDeleted(value);
      postDraftLocal.deleteCacheWhenThreadDeleted(value);
    }
  }
}
