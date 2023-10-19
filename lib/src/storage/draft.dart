import '../importer.dart';

part 'draft.g.dart';

class TemplateStateForLocal = TemplateStateForLocalBase
    with _$TemplateStateForLocal;

abstract class TemplateStateForLocalBase with Store {
  TemplateStateForLocalBase({required this.parent});
  late RepositoryStateBase parent;
  late final store = stringMapStoreFactory.store(dbCollectionId);
  late Database postDraftCache;

  String get dbCollectionId => AppwriteData.postDraftDbCollectionId;

  Database get _db => postDraftCache;

  String get _userId => 'userId';

  Future<void> init(final String path) async {
    postDraftCache = await databaseFactoryIo.openDatabase(path);
  }

  Future<void> load() async {
    final query = Finder(filter: Filter.matches(_userId, parent.user!.id));
    final list = await store.find(_db, finder: query);
    if (list.isNotEmpty) {
      for (final i in list) {
        final data = TemplateData.fromJson(i.value);
        parent.setTemplateData(data);
      }
    }
  }

  TemplateData initialTemplate(final ForumSettingsData value) {
    final random = StringMethodData.generateRandomString();
    final documentIdData = '${value.userId}_${value.forum.name}_$random';
    final documentId = documentIdData.length > 36
        ? documentIdData.substring(0, 36)
        : documentIdData;
    final data = TemplateData(
        documentId: documentId, forum: value.forum, userId: value.userId);
    logger.i('saveTemplate: $documentId');
    return data;
  }

  Future<void> saveTemplate(final ForumSettingsData value) async {
    final data = initialTemplate(value);

    await store.record(data.documentId).put(_db, data.toJson());
    parent.setTemplateData(data);
  }

  Future<void> updateTemplate(final TemplateData value) async {
    await store.record(value.documentId).update(_db, value.toJson());
  }

  Future<void> deleteTemplate(final Communities value) async {
    final query = Finder(
        filter: Filter.and([
      Filter.equals('forum', value.name),
      Filter.equals(_userId, parent.user!.id)
    ]));
    final data = await store.findFirst(_db, finder: query);
    if (data != null) {
      final template = TemplateData.fromJson(data.value);
      final result = await store.record(template.documentId).delete(_db);
      logger.i('delete template: $result');
    }
  }
}
