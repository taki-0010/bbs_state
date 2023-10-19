// import 'package:stash/stash_api.dart' as st;

import '../importer.dart';

part 'forum.g.dart';

class ForumStateForLocal = ForumStateForLocalBase with _$ForumStateForLocal;

abstract class ForumStateForLocalBase with Store {
  ForumStateForLocalBase({required this.parent});
  late RepositoryStateBase parent;

  late final store = stringMapStoreFactory.store(dbCollectionId);

  // SembastCacheStore get store => parent.store;
  // late st.Cache<ForumSettingsData> cache;

  String get dbCollectionId => AppwriteData.forumSettingsDbCollectionId;

  @computed
  ForumSettingsData? get currentData =>
      parent.parent.selectedForumState?.settings;

  // Future<void> init() async {
  //   await _load();
  // }

  Future<void> load() async {
    final query = Finder(filter: Filter.matches('userId', parent.user!.id));
    final list = await store.find(parent.db, finder: query);
    if (list.isEmpty) {
      await _setInitialData();
    } else {
      for (final i in list) {
        final data = ForumSettingsData.fromJson(i.value);
        parent.setForumSettings(data);
      }
    }
  }

  Future<void> _setInitialData() async {
    final forums = parent.user?.forums;
    if (forums == null || forums.isEmpty) {
      throw 'forums ==null || forums.isEmpty';
    }
    for (final i in forums) {
      final value = InitialForumData.getInitialSettings(i, parent.user!.id);
      if (value == null) {
        throw 'forumLocal: value == null';
      }
      await _putData(value);
      await parent.postDraftLocal.saveTemplate(value);
      parent.setForumSettings(value);
      logger.d('forumLocal:  _setInitialData: ${value.forum}');
    }
  }

  Future<void> addForum(final ForumSettingsData value) async {
    await _putData(value);
  }

  Future<void> _putData(final ForumSettingsData value) async {
    // await cache.put('${value.forum.name}_${parent.user!.id}', value);
    await store
        .record('${value.forum.name}_${parent.user!.id}')
        .put(parent.db, value.toJson());
  }

  Future<void> updateData({final ForumSettingsData? settings}) async {
    final data = settings ?? currentData;
    if (data == null) return;
    await store
        .record('${data.forum.name}_${parent.user!.id}')
        .update(parent.db, data.toJson());
  }

  Future<void> deleteData(final Communities value, final String userId) async {
    final query = Finder(filter: Filter.matches('forum', value.name));
    final data = await store.findFirst(parent.db, finder: query);
    if (data != null) {
      logger.e('deleteforum: key:${data.key}, ${data.value}');
      await store.record(data.key).delete(parent.db);
    }
  }
}