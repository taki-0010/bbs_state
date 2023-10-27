import 'importer.dart';

part 'player.g.dart';

class PlayerState = PlayerStateBase with _$PlayerState;

abstract class PlayerStateBase with Store {
  PlayerStateBase({required this.data});
  final LinkData data;
}
