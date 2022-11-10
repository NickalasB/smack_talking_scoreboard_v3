// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

void main() {
  group('Game ViewModel', () {
    test('Should have value-type equality', () {
      final game1 = Game(players: const [Player(playerId: 1)]);

      expect(game1, equals(game1.copyWith()));
      expect(game1, isNot(game1.copyWith(players: [Player(playerId: 2)])));
    });

    test('toJson', () {
      expect(
        Game(players: const [Player(playerId: 1)]).toJson(),
        {
          'players': [Player(playerId: 1, score: 0)]
        },
      );
    });
  });
}
