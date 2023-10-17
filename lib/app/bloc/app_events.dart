import 'package:equatable/equatable.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

abstract class AppEvent extends Equatable {}

class LoadDefaultInsultsEvent extends AppEvent {
  LoadDefaultInsultsEvent({
    required this.defaultInsults,
    required this.defaultTieInsults,
  });

  final List<String> defaultInsults;
  final List<String> defaultTieInsults;

  @override
  List<Object?> get props => [defaultInsults, defaultTieInsults];
}

class LoadAvailableVoicesEvent extends AppEvent {
  LoadAvailableVoicesEvent();

  @override // coverage:ignore-line
  List<Object?> get props => []; // coverage:ignore-line
}

class SetVoiceEvent extends AppEvent {
  SetVoiceEvent(this.voice, {this.sampleInsult});

  final Voice voice;
  final String? sampleInsult;

  @override
  List<Object?> get props => [voice, sampleInsult];
}

class SaveInsultEvent extends AppEvent {
  SaveInsultEvent(this.insult);
  final String? insult;

  @override
  List<Object?> get props => [insult];
}

class DeleteInsultEvent extends AppEvent {
  DeleteInsultEvent(this.insult);

  final String insult;
  @override
  List<Object?> get props => [insult];
}
