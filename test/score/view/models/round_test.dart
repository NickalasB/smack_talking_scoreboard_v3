// ignore_for_file: prefer_const_constructors
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/round.dart';

void main() {
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
