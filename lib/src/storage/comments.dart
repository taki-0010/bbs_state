// import 'package:stash/stash_api.dart' as st;

// import '../importer.dart';

// part 'comments.g.dart';

// class CommentsState = CommentsStateBase with _$CommentsState;

// abstract class CommentsStateBase with Store {
//   CommentsStateBase({required this.parent});
//   late ForumStateBase parent;

//   SembastCacheStore get store => parent.parent.store;
//   late st.Cache<CommentData> cache;

//   // static const _key = 'commentsKey';
//   static const _name = 'commentsName';

//   @observable
//   ObservableList<CommentData?> commentsLog = ObservableList<CommentData?>();

//   Future<void> init() async {
//     await _setCache();
//     await _setData();
//     // if (data == null) {
//     //   await _setLastIndex(_initialData);
//     // }
//   }

//   Future<List<CommentData?>> getAll() async {
//     final keys = await cache.keys;
//     final result = await cache.getAll(keys.toSet());
//     return result.values.map((e) => e).toList();
//   }

//   @action
//   Future<void> _setData() async {
//     commentsLog.addAll(await getAll());
//   }

//   Future<void> _setCache() async {
//     cache = await store.cache<CommentData>(
//         name: '${parent.type.name}$_name',
//         fromEncodable: (json) => CommentData.fromJson(json),
//         expiryPolicy: st.EternalExpiryPolicy(),
//         eventListenerMode: st.EventListenerMode.synchronous)
//       ..on<st.CacheEntryCreatedEvent<CommentData>>().listen((event) => logger.d(
//           '${parent.type.name}: Key "${event.entry.key}" added to the task vault, entry: ${event.entry}, info:${event.entry.info}'));
//   }

//   @action
//   Future<void> setComment(final CommentData value) async {
//     await cache.put(value.threadId, value);
//     commentsLog.add(value);
//   }
// }
