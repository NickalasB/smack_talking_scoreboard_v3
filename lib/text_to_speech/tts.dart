import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tts.g.dart';

abstract class Tts {
  Future<void> speak(String text);

  Future<void> stop();

  Future<void> setVolume(double volumeLevel);

  Future<List<Voice>> get availableVoices;

  Future<void> setVoice(Voice voice);
}

class TtsImplementation implements Tts {
  TtsImplementation(this.ttsEngine) {
    // This is needed in order to hear the voice played on older iOS devices
    // https://github.com/dlutton/flutter_tts/issues/394
    ttsEngine.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions
            .interruptSpokenAudioAndMixWithOthers,
      ],
      IosTextToSpeechAudioMode.voicePrompt,
    );
  }

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

  @override
  Future<List<Voice>> get availableVoices async {
    try {
      final voicesMap =
          ((await ttsEngine.getVoices) as List).cast<Map<dynamic, dynamic>>();

      return voicesMap
          .map((e) => e.cast<String, dynamic>())
          .map(Voice.fromJson)
          .toList();
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<void> setVoice(Voice voice) {
    final voicesAsStringMap = voice.toJson().cast<String, String>();
    return ttsEngine.setVoice(voicesAsStringMap);
  }
}

@JsonSerializable()
class Voice extends Equatable {
  const Voice({
    required this.name,
    required this.locale,
  });

  factory Voice.fromJson(Map<String, dynamic> json) {
    return _$VoiceFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VoiceToJson(this);

  final String name;
  final String locale;

  @override
  List<Object?> get props => [name, locale];
}
