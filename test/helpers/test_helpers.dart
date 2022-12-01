import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

Future<void> tick() {
  return Future.microtask(() {});
}

Player get testPlayer1 => const Player(playerId: 1, playerName: 'Player 1');
Player get testPlayer2 => const Player(playerId: 2, playerName: 'Player 2');
