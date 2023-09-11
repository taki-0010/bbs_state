// import 'package:stash/stash_api.dart' as st;

// import '../importer.dart';

// part 'board.g.dart';

// class BoardStorageState = BoardStorageStateBase with _$BoardStorageState;

// abstract class BoardStorageStateBase with Store {
//   BoardStorageStateBase({required this.parent});
//   late ForumStateBase parent;

//   // static const _lastOpenedIndexKey = 'lastOpenedIndex';
//   static const _boardDataName = 'boardDataName';

//   SembastCacheStore get store => parent.parent.store;
//   late st.Cache<BoardDataForStorage> boardData;

//   Future<void> init() async {
//     await _setCache();
//     // await _setData();
//   }

//   Future<void> _setCache() async {
//     boardData = await store.cache<BoardDataForStorage>(
//         name: '${parent.type.name}$_boardDataName',
//         fromEncodable: (json) => BoardDataForStorage.fromJson(json),
//         expiryPolicy: st.TouchedExpiryPolicy(Duration(days: 30)),
//         eventListenerMode: st.EventListenerMode.synchronous)
//       ..on<st.CacheEntryCreatedEvent<BoardDataForStorage>>().listen((event) =>
//           logger.d(
//               '${parent.type.name}: Key "${event.entry.key}" added to the task vault, entry: ${event.entry}, info:${event.entry.info}'));
//   }

//   Future<BoardDataForStorage?> getBoardData(final String boardId) async =>
//       await boardData.get(boardId);

//   Future<List<BoardDataForStorage?>?> getBoardDataList(
//       final Set<String> idList) async {
//     final data = await boardData.getAll(idList);
//     final result = data.values.toList();
//     return result;
//   }

//   Future<void> setBoardData(
//       final String boardId, final List<ThreadData?> threads) async {
//     final data = await getBoardData(boardId);
//     if (data == null) {
//       final board = parent.board;
//       if (board != null) {
//         final putData = BoardDataForStorage(board: board, threads: threads);
//         await _putData(putData);
//       }
//     } else {
//       final newData = data.copyWith(threads: threads);
//       await _putData(newData);
//     }
//   }

//   Future<void> _putData(final BoardDataForStorage value) async {
//     await boardData.put(value.board.id, value);
//   }
// }
