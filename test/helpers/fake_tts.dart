import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

class FakeTts implements Tts {
  FakeTts();

  final speakCompleters = <Completer<String>>[];
  final stopCompleters = <Completer<dynamic>>[];
  final volumeCompleters = <Completer<double>>[];
  final getVoicesCompleters = <Completer<dynamic>>[];
  final setVoiceCompleters = <Completer<Voice>>[];

  final fakeTsEvents = <FakeTtsEvent>[];

  @override
  Future<dynamic> setVolume(double volume) async {
    final completer = Completer<double>();
    volumeCompleters.add(completer);
    fakeTsEvents.add(FakeSetVolumeEvent(volume));
    return completer.future;
  }

  @override
  Future<dynamic> speak(String text) async {
    final completer = Completer<String>();
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
  Future<List<Voice>> get availableVoices {
    final completer = Completer<List<Voice>>();
    fakeTsEvents.add(FakeGetVoicesEvent());
    getVoicesCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<void> setVoice(Voice voice) {
    final completer = Completer<Voice>();
    fakeTsEvents.add(FakeSetVoiceEvent(voice));
    setVoiceCompleters.add(completer);
    return completer.future;
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

class FakeGetVoicesEvent extends FakeTtsEvent {
  FakeGetVoicesEvent();

  @override
  List<Object?> get props => [];
}

class FakeSetVoiceEvent extends FakeTtsEvent {
  FakeSetVoiceEvent(this.voice);

  final Voice voice;

  @override
  List<Object?> get props => [voice];
}
