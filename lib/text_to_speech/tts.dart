import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

abstract class Tts {
  Future<dynamic> speak(String text);
  Future<dynamic> stop();
  Future<dynamic> setVolume(double volumeLevel);
}

class TtsImplementation implements Tts {
  const TtsImplementation(this.ttsEngine);

  final FlutterTts ttsEngine;

  @override
  Future<dynamic> setVolume(double volumeLevel) async {
    return ttsEngine.setVolume(volumeLevel);
  }

  @override
  Future<dynamic> speak(String text) async {
    return ttsEngine.speak(text);
  }

  @override
  Future<dynamic> stop() async {
    return ttsEngine.stop();
  }
}
