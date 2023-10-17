// ignore_for_file:prefer_const_constructors
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

void main() {
  group('TtsImplementation', () {
    test('should set proper iOS options on creation', () {
      final fakeTts = _FakeTtsEngine();
      TtsImplementation(fakeTts);

      expect(
        fakeTts.iosTextToSpeechAudioCategory,
        IosTextToSpeechAudioCategory.playback,
      );

      expect(
        fakeTts.iosTextToSpeechAudioCategoryOptions,
        [
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          IosTextToSpeechAudioCategoryOptions
              .interruptSpokenAudioAndMixWithOthers,
        ],
      );

      expect(
        fakeTts.iosTextToSpeechAudioMode,
        IosTextToSpeechAudioMode.voicePrompt,
      );
    });

    test('Should speak when speak called', () async {
      final fakeTtsEngine = _FakeTtsEngine();
      final tts = TtsImplementation(fakeTtsEngine);

      final speakCall = tts.speak('anything');
      unawaited(speakCall);
      expect(fakeTtsEngine.speakCompleters, hasLength(1));
    });

    test('Should set volume when setVolume called', () async {
      final fakeTtsEngine = _FakeTtsEngine();
      final tts = TtsImplementation(fakeTtsEngine);

      final setVolumeCall = tts.setVolume(10);
      unawaited(setVolumeCall);
      expect(fakeTtsEngine.volumeCompleters, hasLength(1));
    });

    test('Should stop when stop called', () async {
      final fakeTtsEngine = _FakeTtsEngine();
      final tts = TtsImplementation(fakeTtsEngine);

      final stopCall = tts.stop();
      unawaited(stopCall);
      expect(fakeTtsEngine.stopCompleters, hasLength(1));
    });

    group('available voices', () {
      test(
          'Should return available voices as a list of voices when get availableVoices called',
          () async {
        final fakeTtsEngine = _FakeTtsEngine();
        final tts = TtsImplementation(fakeTtsEngine);

        final availableVoicesCall = tts.availableVoices;

        fakeTtsEngine.availableVoicesCompleters.last.complete(
          [
            {
              'name': 'any_name',
              'locale': 'any_locale',
            },
            {
              'name': 'any_name2',
              'locale': 'any_locale2',
            },
          ],
        );

        expect(
          await availableVoicesCall,
          const [
            Voice(name: 'any_name', locale: 'any_locale'),
            Voice(name: 'any_name2', locale: 'any_locale2'),
          ],
        );
      });

      test(
          'Should return empty list and log error when get availableVoices call fails',
          () async {
        final fakeTtsEngine = _FakeTtsEngine();
        final tts = TtsImplementation(fakeTtsEngine);

        final availableVoicesCall = tts.availableVoices;

        fakeTtsEngine.availableVoicesCompleters.last.completeError(
          Exception('something went wrong'),
        );

        expect(await availableVoicesCall, isEmpty);
      });

      test(
          'Should call ttsEngine.setVoice with correct data when setVoice called',
          () async {
        final fakeTtsEngine = _FakeTtsEngine();
        final tts = TtsImplementation(fakeTtsEngine);

        unawaited(
          tts.setVoice(const Voice(name: 'any_name', locale: 'any_locale')),
        );

        expect(
          fakeTtsEngine.setVoiceCalls,
          const [
            {
              'name': 'any_name',
              'locale': 'any_locale',
            }
          ],
        );
      });
    });
  });

  group('Voice', () {
    final voice1 = Voice(name: 'name1', locale: 'locale1');
    test('Should have value-type equality', () {
      expect(voice1, equals(Voice(name: 'name1', locale: 'locale1')));

      expect(voice1, isNot(Voice(name: 'name2', locale: 'locale1')));
      expect(voice1, isNot(Voice(name: 'name1', locale: 'locale2')));
    });
  });
}

class _FakeTtsEngine implements FlutterTts {
  final speakCompleters = <Completer<dynamic>>[];
  final stopCompleters = <Completer<dynamic>>[];
  final volumeCompleters = <Completer<dynamic>>[];
  final availableVoicesCompleters = <Completer<dynamic>>[];
  final setVoiceCalls = <Map<String, String>>[];

  late final IosTextToSpeechAudioCategory iosTextToSpeechAudioCategory;
  late final List<IosTextToSpeechAudioCategoryOptions>
      iosTextToSpeechAudioCategoryOptions;
  late final IosTextToSpeechAudioMode iosTextToSpeechAudioMode;

  @override
  VoidCallback? cancelHandler;

  @override
  VoidCallback? completionHandler;

  @override
  VoidCallback? continueHandler;

  @override
  ErrorHandler? errorHandler;

  @override
  VoidCallback? initHandler;

  @override
  VoidCallback? pauseHandler;

  @override
  ProgressHandler? progressHandler;

  @override
  VoidCallback? startHandler;

  @override
  Future<dynamic> setVolume(double volume) async {
    final completer = Completer<dynamic>();
    volumeCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<dynamic> speak(String text) async {
    final completer = Completer<dynamic>();
    speakCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<dynamic> stop() async {
    final completer = Completer<dynamic>();
    stopCompleters.add(completer);
  }

  @override
  Future<dynamic> get getVoices async {
    final completer = Completer<dynamic>();
    availableVoicesCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<dynamic> setVoice(Map<String, String> voice) async {
    setVoiceCalls.add(voice);
  }

  @override
  Future<dynamic> areLanguagesInstalled(List<String> languages) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> awaitSpeakCompletion(bool awaitCompletion) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> awaitSynthCompletion(bool awaitCompletion) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> get getDefaultEngine => throw UnimplementedError();

  @override
  Future<dynamic> get getDefaultVoice => throw UnimplementedError();

  @override
  Future<dynamic> get getEngines => throw UnimplementedError();

  @override
  Future<dynamic> get getLanguages => throw UnimplementedError();

  @override
  Future<int?> get getMaxSpeechInputLength => throw UnimplementedError();

  @override
  Future<SpeechRateValidRange> get getSpeechRateValidRange =>
      throw UnimplementedError();

  @override
  Future<dynamic> isLanguageAvailable(String language) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> isLanguageInstalled(String language) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> pause() {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> platformCallHandler(MethodCall call) {
    throw UnimplementedError();
  }

  @override
  void setCancelHandler(VoidCallback callback) {}

  @override
  void setCompletionHandler(VoidCallback callback) {}

  @override
  void setContinueHandler(VoidCallback callback) {}

  @override
  Future<dynamic> setEngine(String engine) {
    throw UnimplementedError();
  }

  @override
  void setErrorHandler(ErrorHandler handler) {}

  @override
  void setInitHandler(VoidCallback callback) {}

  @override
  Future<dynamic> setIosAudioCategory(
    IosTextToSpeechAudioCategory category,
    List<IosTextToSpeechAudioCategoryOptions> options, [
    IosTextToSpeechAudioMode mode = IosTextToSpeechAudioMode.defaultMode,
  ]) async {
    iosTextToSpeechAudioCategory = category;
    iosTextToSpeechAudioCategoryOptions = options;
    iosTextToSpeechAudioMode = mode;
  }

  @override
  Future<dynamic> setLanguage(String language) {
    throw UnimplementedError();
  }

  @override
  void setPauseHandler(VoidCallback callback) {}

  @override
  Future<dynamic> setPitch(double pitch) {
    throw UnimplementedError();
  }

  @override
  void setProgressHandler(ProgressHandler callback) {}

  @override
  Future<dynamic> setQueueMode(int queueMode) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> setSharedInstance(bool sharedSession) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> setSilence(int timems) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> setSpeechRate(double rate) {
    throw UnimplementedError();
  }

  @override
  void setStartHandler(VoidCallback callback) {}

  @override
  Future<dynamic> synthesizeToFile(String text, String fileName) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> autoStopSharedSession(bool autoStop) {
    throw UnimplementedError();
  }
}
