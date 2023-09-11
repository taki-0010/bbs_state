// import 'package:appwrite/models.dart';

import '../importer.dart';

part 'forum.g.dart';

class ForumSettingsState = ForumSettingsStateBase with _$ForumSettingsState;

abstract class ForumSettingsStateBase with Store {
  ForumSettingsStateBase({required this.parent});
  late AppwriteStateBase parent;

  // static const dbCollectionId = 'forumSettings';

  @computed
  ForumSettingsData? get currentData =>
      parent.parent.parent.selectedForumState?.settings;

  String get dbCollectionId => AppwriteData.forumSettingsDbCollectionId;

  // void _updateState(final ForumSettingsData value) {
  //   parent.parent.selectedForumState?.setSettings(value);
  // }

  Future<void> update() async {
    if (currentData == null) return;
    // if (currentData?.theme == value) return;
    final newData = currentData!;
    await _updateDatabase(newData);
  }

  Future<void> addNewForum(final ForumSettingsData value) async {

      await _create(value);

  }

  Future<void> _create(final ForumSettingsData value) async {
    final current = parent.parent.user;
    if (current == null) return;
    await parent.databases.createDocument(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        documentId: '${value.forum.name}_${current.id}',
        data: value.toJson());
    // _updateState(value);
  }

  Future<void> _updateDatabase(final ForumSettingsData value) async {
    final current = parent.parent.user;
    if (current == null) return;
    await parent.databases.updateDocument(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        documentId: '${value.forum.name}_${current.id}',
        data: value.toJson());
    // _updateState(value);
  }

  Future<void> getForumSettings({required final String userId}) async {
    // final data = await getUserAccount;
    final doc = await parent.databases.listDocuments(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        queries: [
          Query.equal("userId", [userId])
        ]);
    if (doc.documents.isNotEmpty) {
      final docList =
          doc.documents.map((e) => ForumSettingsData.fromJson(e.data)).toList();
      parent.parent.setSettingsData(docList);
    }
  }

  // void _setSettingsData(final List<ForumSettingsData?> list) {
  //   // if (doc.documents.isNotEmpty) {
  //   //   final docList =
  //   //       doc.documents.map((e) => ForumSettingsData.fromJson(e.data)).toList();
  //   for (final d in list) {
  //     if (d != null) {
  //       switch (d.forum) {
  //         case Communities.fiveCh:
  //           parent.parent.fiveCh.setSettings(d);
  //           break;
  //         case Communities.girlsCh:
  //           parent.parent.girlsCh.setSettings(d);
  //           break;
  //         case Communities.futabaCh:
  //           parent.parent.futabaCh.setSettings(d);
  //           break;
  //         case Communities.pinkCh:
  //           parent.parent.pinkCh.setSettings(d);
  //           break;
  //         default:
  //       }
  //     }
  //   }
  // }

  Future<void> deleteForum(final Communities value, final String userId) async {
    await parent.databases.deleteDocument(
        databaseId: parent.dbID,
        collectionId: dbCollectionId,
        documentId: '${value.name}_$userId');
  }
}
