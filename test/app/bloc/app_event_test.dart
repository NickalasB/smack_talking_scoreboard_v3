import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

void main() {
  group('LoadDefaultInsultsEvent', () {
    test('Should have value-type equality', () {
      final initialEvent = LoadDefaultInsultsEvent(
        defaultInsults: const ['default1', 'default2'],
        defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
      );

      expect(
        initialEvent,
        equals(
          LoadDefaultInsultsEvent(
            defaultInsults: const ['default1', 'default2'],
            defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
          ),
        ),
      );

      expect(
        initialEvent,
        isNot(
          LoadDefaultInsultsEvent(
            defaultInsults: const ['default3', 'default4'],
            defaultTieInsults: const ['tieDefault1', 'tieDefault2'],
          ),
        ),
      );

      expect(
        initialEvent,
        isNot(
          LoadDefaultInsultsEvent(
            defaultInsults: const ['default1', 'default2'],
            defaultTieInsults: const ['tieDefault3', 'tieDefault4'],
          ),
        ),
      );
    });
  });

  group('SetVoiceEvent', () {
    test('Should have value-type equality', () {
      final setVoiceEvent1 = SetVoiceEvent(
        const Voice(name: 'anyName', locale: 'anyLocale'),
        sampleInsult: 'anything',
      );

      expect(
        setVoiceEvent1,
        equals(
          SetVoiceEvent(
            const Voice(name: 'anyName', locale: 'anyLocale'),
            sampleInsult: 'anything',
          ),
        ),
      );

      expect(
        setVoiceEvent1,
        isNot(
          SetVoiceEvent(
            const Voice(name: 'anyName2', locale: 'anyLocale'),
            sampleInsult: 'anything',
          ),
        ),
      );

      expect(
        setVoiceEvent1,
        isNot(
          SetVoiceEvent(
            const Voice(name: 'anyName', locale: 'anyLocale'),
            sampleInsult: 'anything2',
          ),
        ),
      );
    });
  });
}
