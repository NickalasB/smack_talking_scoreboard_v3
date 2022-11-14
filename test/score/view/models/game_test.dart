// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

void main() {
  group('Game ViewModel', () {
    test('Should have value-type equality', () {
      final initialRound = Round();
      final game1 = Game(
        players: const [
          Player(
            playerId: 1,
          )
        ],
        round: initialRound,
      );

      expect(game1, equals(game1.copyWith()));

      expect(
        game1,
        isNot(game1.copyWith(players: [Player(playerId: 2)])),
      );
      expect(
        game1,
        isNot(game1.copyWith(round: initialRound.copyWith(roundCount: 2))),
      );
    });
  });

  group('Round ViewModel', () {
    test('Should have value-type equality', () {
      final player1 = Player(playerId: 1);
      final round1 = Round(roundCount: 1, roundWinner: player1);

      expect(round1, equals(round1.copyWith()));

      expect(round1, isNot(round1.copyWith(roundCount: 2)));
      expect(round1, isNot(round1.copyWith(roundWinner: Player(playerId: 2))));
    });
  });
}
