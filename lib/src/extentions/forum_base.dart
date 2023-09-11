import '../importer.dart';


abstract class ForumBase {
  late MainStoreBase parent;
  late Communities type;
  int selectedPrimaryViewIndex = 0;
  bool showContentOnHistoryView = false;
  List<bool> secondaryBodyToggleValue = [true, false];
  String? selectedHistoryId;
  String? get currentBoardDomain;
  Future<void> getBoards() async {}
  Future<void> getThreads() async {}
  Future<void> setVisibleContent(final String dataId) async {}
  Future<void> getData(final String dataId) async {}
}


