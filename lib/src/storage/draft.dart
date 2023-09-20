import '../importer.dart';

part 'draft.g.dart';

class PostDraftStateForLocal = PostDraftStateForLocalBase
    with _$PostDraftStateForLocal;

abstract class PostDraftStateForLocalBase with Store {
  PostDraftStateForLocalBase({required this.parent});
  late RepositoryStateBase parent;
  late final store = stringMapStoreFactory.store(dbCollectionId);
  late Database postDraftCache;

  String get dbCollectionId => AppwriteData.postDraftDbCollectionId;

  Database get _db => postDraftCache;

  // String get _threadMarkId => 'threadMarkId';

  Future<void> init(final String path) async {
    postDraftCache = await databaseFactoryIo.openDatabase(path);
  }

  Future<void> deleteCacheWhenThreadDeleted(final ThreadMarkData? value) async {
    if (value == null) {
      return;
    }

    await store.record(value.documentId).delete(_db);
  }
}
