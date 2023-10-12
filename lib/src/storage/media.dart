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
  String get _forum => 'forum';
  String get _size => 'size';
  String get _retentionPeriod => 'retentionPeriod';

  String _getPath(final String url) {
    final parsed = Uri.parse(url);
    logger.d('persed: $parsed');
    final file = parsed.pathSegments.last;

    final extIndex = file.lastIndexOf('.');
    final ext = extIndex == -1 ? '.jpg' : file.substring(extIndex);
    final hashed = md5.string(parsed.toString());
    final path = '${parsed.host}_$hashed$ext';
    final replaced = path.replaceAll('/', '_');
    logger.i('file path: $replaced');
    // if (replaced.length > 40) {
    //   return replaced.substring(0, 40);
    // }
    return replaced;
  }

  File _getFile(final String path) {
    final pathData = '$_cacheFolderPath$path';
    // logger.d('pathData: $pathData');
    return File(pathData);
  }

  Future<void> init(final String dbPath) async {
    mediaCacheInfo = await databaseFactoryIo.openDatabase(dbPath);
    logger.i('cacheState: path: $dbPath');
    await _deleteCacheAutomatically(null);

    Timer.periodic(const Duration(minutes: 15), _deleteCacheAutomatically);
  }

  File getFullPath(final String url) {
    final path = _getPath(url);
    return _getFile(path);
  }

  Future<void> putMediaData(final String? threadMarkId,
      {required final String url,
      required final Communities? forum,
      required final Uint8List data}) async {
    final path = _getPath(url);
    final file = _getFile(path);
    if (!file.existsSync()) {
      await file.writeAsBytes(data);
      final length = data.lengthInBytes;
      final retentionPeriod =
          DateTime.now().add(Duration(days: 14)).millisecondsSinceEpoch;
      await store.record(path).put(_db, {
        _threadMarkId: threadMarkId,
        _forum: forum?.name,
        _retentionPeriod: retentionPeriod,
        _size: length,
        _url: url
      });
      logger.i('putMediaData: size: ${filesize(length)}  path: ${file.path}');
    }

    // final blob = Blob(data);
  }

  Finder _getFilterdByForum(final Communities forum) =>
      Finder(filter: Filter.equals(_forum, forum.name));
  Finder _getFinderOfForumThumbnail(final Communities forum) => Finder(
      filter: Filter.and(
          [Filter.equals(_forum, forum.name), Filter.isNull(_threadMarkId)]));

  Future<int> getTotalSize(
    final Communities forum,
  ) async {
    final result = await store.find(_db, finder: _getFilterdByForum(forum));
    return _total(result);
  }

  Future<int> getThumbnailTotalSize(
    final Communities forum,
  ) async {
    final result =
        await store.find(_db, finder: _getFinderOfForumThumbnail(forum));
    return _total(result);
  }

  int _total(final List<RecordSnapshot<String, Map<String, Object?>>> list) {
    final totalList = list.map((e) => e.value[_size]).whereType<int>();
    if (totalList.isNotEmpty) {
      final total = totalList.reduce((value, element) => value + element);
      logger.d('totalsize: total:$total, ${totalList.length}');
      return total;
    }
    return 0;
  }

  Future<Uint8List?> getDataByUrl(final String srcPath) async {
    final path = _getPath(srcPath);
    final result =
        await store.findFirst(_db, finder: Finder(filter: Filter.byKey(path)));
    // final data = result?.value[_blob];
    // logger.i('cache: ${data.runtimeType}');
    // result.ref.
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

  Future<void> deleteForumData(final Communities forum) async {
    final result = await store.find(_db, finder: _getFilterdByForum(forum));
    await _deleteList(result);
  }

  Future<void> deleteForumThumbnailData(final Communities forum) async {
    final result =
        await store.find(_db, finder: _getFinderOfForumThumbnail(forum));
    await _deleteList(result);
  }

  Future<void> _deleteCacheAutomatically(final Timer? value) async {
    // final now = DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch;
    final now = DateTime.now().millisecondsSinceEpoch;
    final query =
        Finder(filter: Filter.lessThanOrEquals(_retentionPeriod, now));
    final result = await store.find(_db, finder: query);
    await _deleteList(result);
    logger.i(
        'media cache auto delete: ${result.length}, now:${DateTime.fromMillisecondsSinceEpoch(now)}');
  }

  // Future<>

  Future<void> _deleteList(
      final List<RecordSnapshot<String, Map<String, Object?>>> list) async {
    if (list.isNotEmpty) {
      for (final i in list) {
        final path = i.key;
        final file = _getFile(path);
        if (file.existsSync()) {
          file.deleteSync();
        }
        final deleted = await store.record(path).delete(_db);
        logger.i('_deleteList: deleted: $deleted, $path');
      }
    }
  }
}
