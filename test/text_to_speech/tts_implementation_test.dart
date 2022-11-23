import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

import '../helpers/fake_tts_engine.dart';

void main() {
  group('TtsImplementation', () {
    test('Should speak when speak called', () async {
      final fakeTtsEngine = FakeTtsEngine();
      final tts = TtsImplementation(fakeTtsEngine);

      final speakCall = tts.speak('anything');
      unawaited(speakCall);
      expect(fakeTtsEngine.fakeTsEvents, [FakeSpeakEvent('anything')]);
    });

    test('Should set volume when setVolume called', () async {
      final fakeTtsEngine = FakeTtsEngine();
      final tts = TtsImplementation(fakeTtsEngine);

      final setVolumeCall = tts.setVolume(10);
      unawaited(setVolumeCall);
      expect(fakeTtsEngine.fakeTsEvents, [FakeSetVolumeEvent(10)]);
    });

    test('Should stop when stop called', () async {
      final fakeTtsEngine = FakeTtsEngine();
      final tts = TtsImplementation(fakeTtsEngine);

      final stopCall = tts.stop();
      unawaited(stopCall);
      expect(fakeTtsEngine.fakeTsEvents, [FakeStopEvent()]);
    });
  });
}
