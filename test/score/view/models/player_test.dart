// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

void main() {
  group('Player View Model', () {
    test('Should have value-type equality', () {
      final originalPlayer =
          Player(playerId: 1, playerName: 'Player1', score: 1, roundScore: 1);

      expect(originalPlayer, originalPlayer.copyWith());

      expect(originalPlayer, isNot(originalPlayer.copyWith(playerId: 2)));
      expect(
        originalPlayer,
        isNot(originalPlayer.copyWith(playerName: 'Player2')),
      );
      expect(originalPlayer, isNot(originalPlayer.copyWith(score: 2)));
      expect(originalPlayer, isNot(originalPlayer.copyWith(roundScore: 2)));
    });
  });
}
