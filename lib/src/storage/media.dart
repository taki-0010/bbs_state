// import 'dart:typed_data';

import 'dart:typed_data';

import 'package:sembast/blob.dart';

import '../importer.dart';

part 'media.g.dart';

class MediaCacheState = MediaCacheStateBase with _$MediaCacheState;

abstract class MediaCacheStateBase with Store {
  MediaCacheStateBase({required this.parent});
  late RepositoryStateBase parent;
  late final store = stringMapStoreFactory.store(dbCollectionId);

  Database get _db => parent.mediaCache;

  String get dbCollectionId => 'mediaCache';
  String get _blob => 'blob';
  String get _threadMarkId => 'threadMarkId';
  String get _retentionPeriod => 'retentionPeriod';

  Future<void> putMediaData(final String? threadMarkId,
      {required final String url, required final Uint8List data}) async {
    final blob = Blob(data);
    final retentionPeriod = DateTime.now().add(Duration(days: 14));
    await store.record(url).put(_db, {
      _threadMarkId: threadMarkId,
      _retentionPeriod: retentionPeriod.millisecondsSinceEpoch,
      _blob: blob
    });
  }

  Future<Uint8List?> getDataByUrl(final String srcPath) async {
    final result = await store.findFirst(_db,
        finder: Finder(filter: Filter.byKey(srcPath)));
    final data = result?.value[_blob];
    logger.i('cache: ${data.runtimeType}');
    if (data is Blob) {
      return data.bytes;
    }
    return null;
  }

  Future<void> deleteThreadCacheByThreadMarkId(
      final ThreadMarkData? value) async {
    if (value == null) {
      return;
    }
    final threadMarkId = value.documentId;
    final result = await store.delete(_db,
        finder: Finder(filter: Filter.equals(_threadMarkId, threadMarkId)));
    logger.i('media cache delete: $result');
  }

  Future<void> deleteCacheAutomatically() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final query =
        Finder(filter: Filter.lessThanOrEquals(_retentionPeriod, now));
    final result = await store.delete(_db, finder: query);
    logger.i('media cache auto delete: $result');
  }
}
