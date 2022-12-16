import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';

void main() {
  group('LoadDefaultInsultsEvent', () {
    test('Should have value-type equality', () {
      final initialEvent = LoadDefaultInsultsEvent(
        defaultInsults: const ['default1', 'default2'],
      );

      expect(
        initialEvent,
        equals(
          LoadDefaultInsultsEvent(
            defaultInsults: const ['default1', 'default2'],
          ),
        ),
      );

      expect(
        initialEvent,
        isNot(
          LoadDefaultInsultsEvent(
            defaultInsults: const ['default3', 'default4'],
          ),
        ),
      );
    });
  });
}
