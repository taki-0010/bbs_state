// import 'package:stash/stash_api.dart' as st;

import '../importer.dart';

part 'user.g.dart';

class UserStateForLocal = UserStateForLocalBase with _$UserStateForLocal;

abstract class UserStateForLocalBase with Store {
  UserStateForLocalBase({required this.parent});
  late RepositoryStateBase parent;

  late final store = stringMapStoreFactory.store(dbCollectionId);

  // SembastCacheStore get store => parent.store;
  // late st.Cache<UserData> cache;
  String get dbCollectionId => AppwriteData.usersDbCollectionId;

  // static const _userStorage = 'user_storage';
  static const _userKey = 'user_key';
  // static const searchWords = ['ニュース', 'スポーツ', '天気'];

  static final _initialData = UserData(
      id: StringMethodData.generateRandomString(23),
      forums: [
        Communities.fiveCh,
        Communities.girlsCh,
        Communities.machi,
        Communities.shitaraba,
        Communities.hatena,
        // Communities.open2Ch
      ],
      randomAvatar: StringMethodData.generateRandomString(15),
      lastOpenedForum: Communities.fiveCh,
      language: LangList.ja);

  Future<void> init() async {
    await _loadCache();
  }

  Future<void> _loadCache() async {
    final data = await store.record(_userKey).get(parent.db);
    UserData? user;
    if (data == null) {
      await _setInitialUserData();
      user = _initialData;
    } else {
      // final data = await store.record(_userKey).get(parent.db);
      // if (data != null) {
      user = UserData.fromJson(data);
      // }
    }
    parent.setUser(user);
  }

  Future<void> _setInitialUserData() async {
    await store.record(_userKey).put(parent.db, _initialData.toJson());
    // await cache.put(_userKey, _initialData);
  }

  Future<void> update(final UserData value) async {
    await store.record(_userKey).update(parent.db, value.toJson());
    // await cache.put(_userKey, value);
  }
}
