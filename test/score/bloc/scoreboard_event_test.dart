// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game_point_params.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('StartGameEvent', () {
    test('Should have value-type equality', () {
      final originalGamePointParams = GamePointParams(
        winningScore: 1,
        pointsPerScore: 2,
        winByMargin: 3,
      );
      final originalStartGameEvent = StartGameEvent(
        player1: testPlayer1,
        player2: testPlayer2,
        gamePointParams: originalGamePointParams,
      );

      expect(
        originalStartGameEvent,
        equals(originalStartGameEvent.copyWith()),
      );

      expect(
        originalStartGameEvent,
        isNot(
          originalStartGameEvent.copyWith(
            player1: Player(playerId: 3, playerName: 'Player 3'),
          ),
        ),
      );

      expect(
        originalStartGameEvent,
        isNot(
          originalStartGameEvent.copyWith(
            player2: Player(playerId: 4, playerName: 'Player 4'),
          ),
        ),
      );

      expect(
        originalStartGameEvent,
        isNot(
          originalStartGameEvent.copyWith(
            gamePointParams: originalGamePointParams.copyWith(winningScore: 5),
          ),
        ),
      );
    });
  });
}
