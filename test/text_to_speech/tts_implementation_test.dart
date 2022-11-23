import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

void main() {
  group('TtsImplementation', () {
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
  });
}

class _FakeTtsEngine implements FlutterTts {
  final speakCompleters = <Completer<dynamic>>[];
  final stopCompleters = <Completer<dynamic>>[];
  final volumeCompleters = <Completer<dynamic>>[];

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
  Future<dynamic> get getVoices => throw UnimplementedError();

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
  ]) {
    throw UnimplementedError();
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
  Future<dynamic> setVoice(Map<String, String> voice) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> synthesizeToFile(String text, String fileName) {
    throw UnimplementedError();
  }
}
