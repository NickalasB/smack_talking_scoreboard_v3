// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game_point_params.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/round.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('Game ViewModel', () {
    test('Should have value-type equality', () {
      final initialRound = Round();
      final initialPointParams = GamePointParams(
        winningScore: 1,
        pointsPerScore: 2,
        winByMargin: 3,
      );

      final game1 = Game(
        players: [testPlayer1],
        round: initialRound,
        gamePointParams: initialPointParams,
      );

      expect(game1, equals(game1.copyWith()));

      expect(
        game1,
        isNot(game1.copyWith(players: [testPlayer2])),
      );
      expect(
        game1,
        isNot(game1.copyWith(round: initialRound.copyWith(roundCount: 2))),
      );
      expect(
        game1,
        isNot(
          game1.copyWith(
              gamePointParams: initialPointParams.copyWith(winningScore: 5)),
        ),
      );
    });
  });
}
