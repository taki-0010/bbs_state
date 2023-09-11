// import 'dart:convert';

// import 'dart:ffi';

import 'dart:async';

// import 'package:stash/stash_api.dart' as st;

import '../importer.dart';

part 'thread.g.dart';

class ThreadStateForLocal = ThreadStateForLocalBase with _$ThreadStateForLocal;

abstract class ThreadStateForLocalBase with Store {
  ThreadStateForLocalBase({required this.parent});
  late RepositoryStateBase parent;
  late final store = stringMapStoreFactory.store(dbCollectionId);

  String get dbCollectionId => AppwriteData.threadDbCollectionId;

  @observable
  String? randomString;

  Future<void> init() async {
    final query = Finder(filter: Filter.matches('userId', parent.user!.id));
    final list = await store.find(parent.db, finder: query);
    if (list.isNotEmpty) {
      await parent.db.transaction((transaction) {
        for (final i in list) {
          final data = ThreadMarkData.fromJson(i.value);
          parent.setThreadData(data);
        }
      });
    }
    await _delete(showSnackWhenDeleted: false);
    Timer.periodic(const Duration(minutes: 15), _deleteThreadAutomatically);
  }

  @action
  void setRandomStr(Timer timer) {
    randomString = StringMethodData.generateRandomString();
  }

  Future<void> _deleteThreadAutomatically(Timer timer) async {
    await _delete(showSnackWhenDeleted: true);
    await parent.mediaLocal.deleteCacheAutomatically();
  }

  Future<void> _delete({final bool showSnackWhenDeleted = false}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final query =
        Finder(filter: Filter.lessThanOrEquals('retentionPeriodSeconds', now));
    final list = await store.find(parent.db, finder: query);
    // await parent.db.transaction((transaction) {
    logger.f(
        'auto delete: list: ${list.length}, showSnackWhenDeleted: $showSnackWhenDeleted');
    for (final i in list) {
      final data = ThreadMarkData.fromJson(i.value);
      await deleteCacheByDataId(i.key);
      if (showSnackWhenDeleted) {
        parent.deleteThreadData(data);
      }
    }
  }

  Future<void> clearForumThreads(final Communities value) async {
    final query = Finder(filter: Filter.equals('type', value.name));
    await store.delete(parent.db, finder: query);
  }

  Future<void> saveThreadMark(final ThreadMarkData value) async {
    await store.record(value.documentId).put(parent.db, value.toJson());
  }

  Future<void> updateThreadMark(final ThreadMarkData value) async {
    await store.record(value.documentId).update(parent.db, value.toJson());
  }

  Future<void> clearThreads(final List<ThreadMarkData?> value) async {
    for (final i in value) {
      if (i != null) {
        await deleteCacheByDataId(i.documentId);
        parent.deleteThreadData(i);
      }
    }
  }

  Future<void> deleteCacheByDataId(final String id) async {
    final result = await store.record(id).delete(parent.db);
    logger.d('cache removed: id: $id, result: $result');
  }
}
