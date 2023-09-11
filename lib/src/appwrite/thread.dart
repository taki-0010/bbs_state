import 'package:appwrite/models.dart';

import '../importer.dart';

part 'thread.g.dart';

class ThreadState = ThreadStateBase with _$ThreadState;

abstract class ThreadStateBase with Store {
  ThreadStateBase({required this.parent});
  late AppwriteStateBase parent;

  // static const dbCollectionId = 'thread';
  String get dbCollectionId => AppwriteData.threadDbCollectionId;

  static const paginate = 25;
  late final subscription =
      parent.realtime.subscribe([AppwriteData.threadRealtimeChannel]);
  // ['databases.${parent.dbID}.collections.$dbCollectionId.documents']);

  @computed
  List<ThreadMarkData?> get currentData =>
      parent.parent.parent.selectedForumState?.history.markList ?? [];

  // Future<void> setLastOpenedContentIndex(
  //     final int index, final String documentId) async {

  //     }

  // String getDocumentId(final ThreadMarkData value) {
  //   // final result = '${value.boardId}_${value.id}_${ID.unique()}';
  //   final result = '${value.boardId}_${value.id}_${value.userId}';
  //   logger.d('id: $result, length: ${result.length}');
  //   if (result.length > 36) {
  //     return result.substring(0, 36);
  //   }
  //   return result;
  // }

  Future<void> updateThreadMark(final ThreadMarkData value) async {
    final doc = await parent.databases.updateDocument(
      databaseId: parent.dbID,
      collectionId: dbCollectionId,
      documentId: value.documentId,
      data: value.toJson(),
    );
    logger.d(doc.data);
  }

  Future<void> saveThreadMark(final ThreadMarkData value) async {
    // logger.d('retentionPeriodSeconds: ${value.retentionPeriodSeconds}');
     await parent.databases.createDocument(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        documentId: value.documentId,
        data: value.toJson(),
        permissions: [
          Permission.read(Role.user(value.userId)),
          Permission.update(Role.user(value.userId)),
          Permission.delete(Role.user(value.userId)),
        ]);
    // logger.d(doc.data);
  }

  Future<void> clearThreads(final List<ThreadMarkData?> value) async {
    if (value.isNotEmpty) {
      for (final i in value) {
        if (i != null) {
          await deleteThreadMark(i);
        }
      }
    }
  }

  Future<void> deleteThreadMark(final ThreadMarkData value) async {
    await parent.databases.deleteDocument(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        documentId: value.documentId);
  }

  Future<void> subscribeThreads({required final String userId}) async {
    subscription.stream.listen((response) {
      if (parent.parent.user == null) {
        return;
      }
      final thread = ThreadMarkData.fromJson(response.payload);
      // logger.i('stream event: ${response.events}');
      if (response.events.contains(
          'databases.${parent.dbID}.collections.$dbCollectionId.documents.*.delete')) {
        logger.i('stream: removed: ${response.timestamp}');
        parent.parent.deleteThreadData(thread);
      } else {
        parent.parent.setThreadData(thread);
      }
    });
  }

  Future<void> getInitialThreads({required final String userId}) async {
    // final data = await getUserAccount;
    final doc = await parent.databases.listDocuments(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        queries: [
          Query.limit(paginate),
          Query.equal("userId", [userId]),
        ]);
    final total = doc.total;
    logger.i('getInitialThreads: ${doc.documents.length}, total: ${doc.total}');
    _setDocuments(doc.documents);
    if (total > paginate) {
      final lastId = doc.documents.lastOrNull?.$id;
      if (lastId != null) {
        await _pagination(lastId, userId);
      }
    }
  }

  Future<void> _pagination(final String lastId, final String userId) async {
    final doc = await parent.databases.listDocuments(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        queries: [
          Query.limit(paginate),
          Query.equal("userId", [userId]),
          Query.cursorAfter(lastId)
        ]);
    _setDocuments(doc.documents);
    if (doc.documents.length == paginate) {
      final lastId = doc.documents.lastOrNull?.$id;
      if (lastId != null) {
        await _pagination(lastId, userId);
      }
      logger
          .i('paginate: length: ${doc.documents.length}, total: ${doc.total}');
    }
  }

  void _setDocuments(final List<Document> docs) {
    for (final i in docs) {
      final d = ThreadMarkData.fromJson(i.data);
      parent.parent.setThreadData(d);
    }
  }

  // void _setDataList(final List<ThreadMarkData?> list) {
  //   for (final d in list) {
  //     _setData(d);
  //   }
  // }

  // void _setData(final ThreadMarkData? value) {
  //   if (value != null) {
  //     switch (value.type) {
  //       case Communities.fiveCh:
  //         parent.parent.fiveCh.history.setLog(value);
  //         break;
  //       case Communities.girlsCh:
  //         parent.parent.girlsCh.history.setLog(value);
  //         break;
  //       case Communities.futabaCh:
  //         parent.parent.futabaCh.history.setLog(value);
  //         break;
  //       case Communities.pinkCh:
  //         parent.parent.pinkCh.history.setLog(value);
  //         break;
  //       default:
  //     }
  //   }
  // }

  // void _deleteData(final ThreadMarkData? value) {
  //   if (value != null) {
  //     switch (value.type) {
  //       case Communities.fiveCh:
  //         parent.parent.fiveCh.deleteContent(value);
  //         break;
  //       case Communities.girlsCh:
  //         parent.parent.girlsCh.deleteContent(value);
  //         break;
  //       case Communities.futabaCh:
  //         parent.parent.futabaCh.deleteContent(value);
  //         break;
  //       case Communities.pinkCh:
  //         parent.parent.pinkCh.deleteContent(value);
  //         break;
  //       default:
  //     }
  //     parent.parent.setDeletedThreadTitle(value.title);
  //   }
  // }
}
