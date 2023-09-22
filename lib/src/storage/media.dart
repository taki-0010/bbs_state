// import 'dart:typed_data';
// import 'package:path/path.dart' as path;

import 'dart:async';
import 'dart:typed_data';

// import 'package:sembast/blob.dart';

import '../importer.dart';

part 'media.g.dart';

class MediaCacheState = MediaCacheStateBase with _$MediaCacheState;

abstract class MediaCacheStateBase with Store {
  MediaCacheStateBase({required this.parent});
  late RepositoryStateBase parent;
  late final store = stringMapStoreFactory.store(dbCollectionId);
  late Database mediaCacheInfo;
  // late Directory cacheDir;
  String get _cacheFolderPath => parent.cacheFolderPath;

  Database get _db => mediaCacheInfo;

  String get dbCollectionId => 'mediaCache';
  // String get _blob => 'blob';
  String get _url => 'url';
  String get _threadMarkId => 'threadMarkId';
  String get _retentionPeriod => 'retentionPeriod';

  String _getPath(final String url) {
    final parsed = Uri.parse(url);
    final path = '${parsed.host}${parsed.path}';
    return path.replaceAll('/', '_');
  }

  File _getFile(final String path){
    return File('$_cacheFolderPath$path');
  }

  Future<void> init(final String dbPath) async {
    
    mediaCacheInfo = await databaseFactoryIo.openDatabase(dbPath);
    logger.i('cacheState: path: $dbPath');
    Timer.periodic(const Duration(hours: 6), _deleteCacheAutomatically);
  }

  Future<void> putMediaData(final String? threadMarkId,
      {required final String url, required final Uint8List data}) async {
    final path = _getPath(url);
    final file = _getFile(path);
    if (!file.existsSync()) {
      await file.writeAsBytes(data);
      final retentionPeriod = DateTime.now().add(Duration(days: 14));
      await store.record(path).put(_db, {
        _threadMarkId: threadMarkId,
        _retentionPeriod: retentionPeriod.millisecondsSinceEpoch,
        _url: path
      });
      logger.i('putMediaData: path: ${file.path}');
    }

    // final blob = Blob(data);
  }
  // Future<void> putMediaData(final String? threadMarkId,
  //     {required final String url, required final Uint8List data}) async {
  //   final blob = Blob(data);
  //   final retentionPeriod = DateTime.now().add(Duration(days: 14));
  //   await store.record(url).put(_db, {
  //     _threadMarkId: threadMarkId,
  //     _retentionPeriod: retentionPeriod.millisecondsSinceEpoch,
  //     _blob: blob
  //   });
  // }

  Future<Uint8List?> getDataByUrl(final String srcPath) async {
    final path = _getPath(srcPath);
    final result =
        await store.findFirst(_db, finder: Finder(filter: Filter.byKey(path)));
    // final data = result?.value[_blob];
    // logger.i('cache: ${data.runtimeType}');
    if (result != null) {
      final file = _getFile(path);
      if (file.existsSync()) {
        final data = await file.readAsBytes();
        return data;
      }
    }
    return null;
  }

  // Future<Uint8List?> getDataByUrl(final String srcPath) async {
  //   // final path = _getPath(srcPath);
  //   final result = await store.findFirst(_db,
  //       finder: Finder(filter: Filter.byKey(srcPath)));
  //   final data = result?.value[_blob];
  //   logger.i('cache: ${data.runtimeType}');
  //   if (data is Blob) {
  //     return data.bytes;
  //   }
  //   return null;
  // }

  Future<void> deleteCacheWhenThreadDeleted(final ThreadMarkData? value) async {
    if (value == null) {
      return;
    }
    final threadMarkId = value.documentId;
    final result = await store.find(_db,
        finder: Finder(filter: Filter.equals(_threadMarkId, threadMarkId)));
    logger.i('media cache delete: ${result.length}');
    await _deleteList(result);
  }
  // Future<void> deleteCacheWhenThreadDeleted(final ThreadMarkData? value) async {
  //   if (value == null) {
  //     return;
  //   }
  //   final threadMarkId = value.documentId;
  //   final result = await store.delete(_db,
  //       finder: Finder(filter: Filter.equals(_threadMarkId, threadMarkId)));
  //   logger.i('media cache delete: $result');

  // }

  Future<void> _deleteCacheAutomatically(final Timer value) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final query =
        Finder(filter: Filter.lessThanOrEquals(_retentionPeriod, now));
    final result = await store.find(_db, finder: query);
    await _deleteList(result);
    logger.i('media cache auto delete: ${result.length}');
  }
  // Future<void> deleteCacheAutomatically() async {
  //   final now = DateTime.now().millisecondsSinceEpoch;
  //   final query =
  //       Finder(filter: Filter.lessThanOrEquals(_retentionPeriod, now));

  //   final result = await store.delete(_db, finder: query);
  //   logger.i('media cache auto delete: $result');
  // }

  Future<void> _deleteList(
      final List<RecordSnapshot<String, Map<String, Object?>>> list) async {
    if (list.isNotEmpty) {
      for (final i in list) {
        final path = i.key;
        final file = _getFile(path);
        if (file.existsSync()) {
          file.deleteSync();
        }
        final deleted =
            await store.record(path).delete(_db);
        logger.i('_deleteList: deleted: $deleted, $path');
      }
    }
  }
}
