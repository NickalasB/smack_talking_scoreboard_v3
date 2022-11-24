// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';

void main() {
  group('StartGameEvent', () {
    test('Should have value-type equality', () {
      final originalStartGameEvent =
          StartGameEvent(defaultInsults: const ['default1']);

      expect(
        originalStartGameEvent,
        equals(
          StartGameEvent(defaultInsults: const ['default1']),
        ),
      );

      expect(
        originalStartGameEvent,
        isNot(
          StartGameEvent(defaultInsults: const ['default2']),
        ),
      );
    });
  });
}
