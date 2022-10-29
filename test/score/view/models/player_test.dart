// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

void main() {
  group('Player View Model', () {
    test('Should have value-type equality', () {
      final originalPlayer = Player(playerId: 1, score: 1);

      expect(originalPlayer, equals(Player(playerId: 1, score: 1)));

      expect(originalPlayer, isNot(Player(playerId: 2, score: 1)));
      expect(originalPlayer, isNot(Player(playerId: 1, score: 2)));
    });
  });
}
