// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

void main() {
  group('Player View Model', () {
    test('Should have value-type equality', () {
      final originalPlayer = Player(playerId: 1, score: 1);

      expect(originalPlayer, originalPlayer.copyWith());

      expect(originalPlayer, isNot(originalPlayer.copyWith(playerId: 2)));
      expect(originalPlayer, isNot(originalPlayer.copyWith(score: 2)));
    });

    test('toJson', () {
      expect(
        Player(playerId: 1, score: 1).toJson(),
        {
          'playerId': 1,
          'score': 1,
        },
      );
    });

    test('fromJson', () {
      expect(
        Player.fromJson(
          Player(playerId: 1, score: 1).toJson(),
        ),
        Player(
          playerId: 1,
          score: 1,
        ),
      );
    });
  });
}
