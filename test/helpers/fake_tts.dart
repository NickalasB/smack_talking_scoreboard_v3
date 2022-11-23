import 'dart:async';

import 'package:equatable/equatable.dart';
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
