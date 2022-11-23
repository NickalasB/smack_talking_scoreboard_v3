import 'dart:async';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

class FakeTts implements Tts {
  FakeTts();
  final speakCompleters = <Completer<dynamic>>[];
  final stopCompleters = <Completer<dynamic>>[];
  final volumeCompleters = <Completer<dynamic>>[];

  final fakeTsEvents = <FakeTtsEvent>[];

  @override
  Future<dynamic> setVolume(double volume) async {
    final completer = Completer<dynamic>();
    volumeCompleters.add(completer);
    fakeTsEvents.add(FakeSetVolumeEvent(volume));
    return completer.future;
  }

  @override
  Future<dynamic> speak(String text) async {
    final completer = Completer<dynamic>();
    speakCompleters.add(completer);
    fakeTsEvents.add(FakeSpeakEvent(text));
    return completer.future;
  }

  @override
  Future<dynamic> stop() async {
    final completer = Completer<dynamic>();
    fakeTsEvents.add(FakeStopEvent());
    stopCompleters.add(completer);
  }
}

class FakeTtsEngine implements FlutterTts {
  final speakCompleters = <Completer<dynamic>>[];
  final stopCompleters = <Completer<dynamic>>[];
  final volumeCompleters = <Completer<dynamic>>[];

  final fakeTsEvents = <FakeTtsEvent>[];

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
    fakeTsEvents.add(FakeSetVolumeEvent(volume));
    return completer.future;
  }

  @override
  Future<dynamic> speak(String text) async {
    final completer = Completer<dynamic>();
    speakCompleters.add(completer);
    fakeTsEvents.add(FakeSpeakEvent(text));
    return completer.future;
  }

  @override
  Future<dynamic> stop() async {
    final completer = Completer<dynamic>();
    fakeTsEvents.add(FakeStopEvent());
    stopCompleters.add(completer);
  }

  @override
  Future areLanguagesInstalled(List<String> languages) {
    // TODO: implement areLanguagesInstalled
    throw UnimplementedError();
  }

  @override
  Future awaitSpeakCompletion(bool awaitCompletion) {
    // TODO: implement awaitSpeakCompletion
    throw UnimplementedError();
  }

  @override
  Future awaitSynthCompletion(bool awaitCompletion) {
    // TODO: implement awaitSynthCompletion
    throw UnimplementedError();
  }

  @override
  // TODO: implement getDefaultEngine
  Future get getDefaultEngine => throw UnimplementedError();

  @override
  // TODO: implement getDefaultVoice
  Future get getDefaultVoice => throw UnimplementedError();

  @override
  // TODO: implement getEngines
  Future get getEngines => throw UnimplementedError();

  @override
  // TODO: implement getLanguages
  Future get getLanguages => throw UnimplementedError();

  @override
  // TODO: implement getMaxSpeechInputLength
  Future<int?> get getMaxSpeechInputLength => throw UnimplementedError();

  @override
  // TODO: implement getSpeechRateValidRange
  Future<SpeechRateValidRange> get getSpeechRateValidRange =>
      throw UnimplementedError();

  @override
  // TODO: implement getVoices
  Future get getVoices => throw UnimplementedError();

  @override
  Future isLanguageAvailable(String language) {
    // TODO: implement isLanguageAvailable
    throw UnimplementedError();
  }

  @override
  Future isLanguageInstalled(String language) {
    // TODO: implement isLanguageInstalled
    throw UnimplementedError();
  }

  @override
  Future pause() {
    // TODO: implement pause
    throw UnimplementedError();
  }

  @override
  Future platformCallHandler(MethodCall call) {
    // TODO: implement platformCallHandler
    throw UnimplementedError();
  }

  @override
  void setCancelHandler(VoidCallback callback) {
    // TODO: implement setCancelHandler
  }

  @override
  void setCompletionHandler(VoidCallback callback) {
    // TODO: implement setCompletionHandler
  }

  @override
  void setContinueHandler(VoidCallback callback) {
    // TODO: implement setContinueHandler
  }

  @override
  Future setEngine(String engine) {
    // TODO: implement setEngine
    throw UnimplementedError();
  }

  @override
  void setErrorHandler(ErrorHandler handler) {
    // TODO: implement setErrorHandler
  }

  @override
  void setInitHandler(VoidCallback callback) {
    // TODO: implement setInitHandler
  }

  @override
  Future setIosAudioCategory(IosTextToSpeechAudioCategory category,
      List<IosTextToSpeechAudioCategoryOptions> options,
      [IosTextToSpeechAudioMode mode = IosTextToSpeechAudioMode.defaultMode]) {
    // TODO: implement setIosAudioCategory
    throw UnimplementedError();
  }

  @override
  Future setLanguage(String language) {
    // TODO: implement setLanguage
    throw UnimplementedError();
  }

  @override
  void setPauseHandler(VoidCallback callback) {
    // TODO: implement setPauseHandler
  }

  @override
  Future setPitch(double pitch) {
    // TODO: implement setPitch
    throw UnimplementedError();
  }

  @override
  void setProgressHandler(ProgressHandler callback) {
    // TODO: implement setProgressHandler
  }

  @override
  Future setQueueMode(int queueMode) {
    // TODO: implement setQueueMode
    throw UnimplementedError();
  }

  @override
  Future setSharedInstance(bool sharedSession) {
    // TODO: implement setSharedInstance
    throw UnimplementedError();
  }

  @override
  Future setSilence(int timems) {
    // TODO: implement setSilence
    throw UnimplementedError();
  }

  @override
  Future setSpeechRate(double rate) {
    // TODO: implement setSpeechRate
    throw UnimplementedError();
  }

  @override
  void setStartHandler(VoidCallback callback) {
    // TODO: implement setStartHandler
  }

  @override
  Future setVoice(Map<String, String> voice) {
    // TODO: implement setVoice
    throw UnimplementedError();
  }

  @override
  Future synthesizeToFile(String text, String fileName) {
    // TODO: implement synthesizeToFile
    throw UnimplementedError();
  }
}

abstract class FakeTtsEvent extends Equatable {}

class FakeSpeakEvent extends FakeTtsEvent {
  FakeSpeakEvent(this.textToSpeak);

  final String textToSpeak;

  @override
  List<Object?> get props => [textToSpeak];
}

class FakeSetVolumeEvent extends FakeTtsEvent {
  FakeSetVolumeEvent(this.volumeLevel);

  final double volumeLevel;

  @override
  List<Object?> get props => [volumeLevel];
}

class FakeStopEvent extends FakeTtsEvent {
  FakeStopEvent();

  @override
  List<Object?> get props => [];
}
