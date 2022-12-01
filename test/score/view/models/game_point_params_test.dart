// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game_point_params.dart';

void main() {
  group('GamePointParams', () {
    test('Should have value-type equality', () {
      final originalParams = GamePointParams(
        winningScore: 1,
        pointsPerScore: 2,
        winByMargin: 3,
      );

      expect(originalParams, equals(originalParams.copyWith()));

      expect(
        originalParams,
        isNot(originalParams.copyWith(winningScore: 11)),
      );
      expect(
        originalParams,
        isNot(originalParams.copyWith(winningScore: 22)),
      );
      expect(
        originalParams,
        isNot(originalParams.copyWith(pointsPerScore: 33)),
      );
    });
  });
}
