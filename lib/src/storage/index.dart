// import 'package:stash/stash_api.dart' as st;

// import '../importer.dart';

// part 'index.g.dart';

// class IndexState = IndexStateBase with _$IndexState;

// abstract class IndexStateBase with Store {
//   IndexStateBase({required this.parent});
//   late ForumStateBase parent;

//   static const _lastOpenedIndexKey = 'lastOpenedIndex';
//   static const _lastOpenedIndexStorage = 'lastOpenedIndexStorage';

//   SembastCacheStore get store => parent.parent.store;
//   late st.Cache<LastOpenedIndex> lastOpenedIndex;

//   late final _initialData = LastOpenedIndex();

//   @observable
//   LastOpenedIndex? data;

//   Future<void> init() async {
//     await _setCache();
//     await _setData();
//     if (data == null) {
//       await _setLastIndex(_initialData);
//     }
//   }

//   @action
//   Future<void> _setData() async {
//     data = await getLastIndex();
//   }

//   Future<LastOpenedIndex?> getLastIndex() async =>
//       await lastOpenedIndex.get(_lastOpenedIndexKey);

//   Future<void> _setCache() async {
//     lastOpenedIndex = await store.cache<LastOpenedIndex>(
//         name: '${parent.type.name}$_lastOpenedIndexStorage',
//         fromEncodable: (json) => LastOpenedIndex.fromJson(json),
//         expiryPolicy: st.EternalExpiryPolicy(),
//         eventListenerMode: st.EventListenerMode.synchronous)
//       ..on<st.CacheEntryCreatedEvent<LastOpenedIndex>>().listen((event) => logger
//           .d('${parent.type.name}: Key "${event.entry.key}" added to the task vault, entry: ${event.entry}, info:${event.entry.info}'));
//   }

//   Future<void> setLastOpenedBoardsIndex(final int index) async {
//     final cache = await getLastIndex();
//     if (cache == null) {
//       final indexData = LastOpenedIndex(boards: index);
//       logger.d(
//           'setLastOpenedBoardsIndex: no chache: indexData:${indexData.boards}');
//       await _setLastIndex(indexData);
//     } else {
//       final newData = cache.copyWith(boards: index);
//       logger
//           .d('setLastOpenedBoardsIndex: has chache: newData:${newData.boards}');
//       await _setLastIndex(newData);
//     }
//   }

//   Future<void> _setLastIndex(final LastOpenedIndex value) async {
//     await lastOpenedIndex.put(_lastOpenedIndexKey, value);
//     await _setData();
//   }

//   Future<void> setLastOpenedContentIndex(
//       final String id, final int index) async {
//     final cache = await getLastIndex();
//     if (cache == null) return;
//     final contents = {...?cache.contents};
//     contents.removeWhere((element) => element?.id == id);
//     final newData = LastOpenedContentIndex(id: id, index: index);
//     contents.add(newData);
//     final newCache = cache.copyWith(contents: contents);
//     logger.d(
//         'setLastOpenedContentIndex: index: $index, contents: ${contents.length}');
//     await _setLastIndex(newCache);
//   }

//   Future<void> deleteLastOpenedContentIndex(
//     final String id,
//   ) async {
//     final cache = await getLastIndex();
//     if (cache == null) return;
//     final contents = {...?cache.contents};
//     contents.removeWhere((element) => element?.id == id);
//     final newCache = cache.copyWith(contents: contents);
//     logger.d('deleteLastOpenedContentIndex: contents: ${contents.length}');
//     await _setLastIndex(newCache);
//   }
// }
