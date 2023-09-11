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

  Future<void> init() async {
    // cache = await store.cache<ForumSettingsData>(
    //     name: dbCollectionId,
    //     fromEncodable: (json) => ForumSettingsData.fromJson(json),
    //     expiryPolicy: st.EternalExpiryPolicy(),
    //     // maxEntries: 1,
    //     eventListenerMode: st.EventListenerMode.synchronous)
    //   ..on<st.CacheEntryCreatedEvent<ForumSettingsData>>().listen((event) =>
    //       logger.d(
    //           '$dbCollectionId: Key "${event.entry.key}" added to the forumsettings vault, entry: ${event.entry}, info:${event.entry.info}'));
    await _load();
  }

  Future<void> _load() async {
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
    // final keys = await cache.keys;
    // if (keys.isEmpty) {
    //   await _setInitialData();
    // } else {
    //   final data = await cache.getAll(keys.toSet());
    //   final list = data.values.toList();
    //   if (list.isNotEmpty) {
    //     parent.setSettingsData(list);
    //   }
    // }
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

  Future<void> updateData() async {
    if (currentData == null) return;
    await store
        .record('${currentData!.forum.name}_${parent.user!.id}')
        .update(parent.db, currentData!.toJson());
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
