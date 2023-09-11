// import 'package:appwrite/models.dart';

import 'dart:typed_data';

import '../importer.dart';

part 'main.g.dart';

class AppwriteState = AppwriteStateBase with _$AppwriteState;

abstract class AppwriteStateBase with Store {
  AppwriteStateBase({required this.parent});
  late RepositoryStateBase parent;
  late final userState = UserState(parent: this);
  late final forumState = ForumSettingsState(parent: this);
  late final threadState = ThreadState(parent: this);
  // static const _mainDbId = '64dac551c1bc6db3e94c';
  static Client client = Client()
      .setEndpoint(AppwriteData.endpoint)
      .setProject(AppwriteData.projectId);
  late final Account account = Account(client);
  late final Databases databases = Databases(client);
  late final Avatars avatars = Avatars(client);
  late final Functions functions = Functions(client);
  late final realtime = Realtime(client);

  // String get dbID => _mainDbId;

  String get dbID => AppwriteData.mainDbId;

  // @observable
  // User? user;

  Future<bool> init() async {
    final userId = await userState.account();
    logger.i('init: userId: $userId');
    if (userId == null) {
      return false;
    } else {
      await forumState.getForumSettings(userId: userId);
      await threadState.getInitialThreads(userId: userId);
      await threadState.subscribeThreads(userId: userId);
      return true;
    }
  }

  Future<Uint8List> getFavicon(final String value) async {
    return await avatars.getFavicon(url: value);
  }

  Future runFunc() async {
    final result = await functions.createExecution(
      functionId: '64db712fef990e0a196d',
    );
    logger.i('function: ${result.toMap()}');
  }
}
