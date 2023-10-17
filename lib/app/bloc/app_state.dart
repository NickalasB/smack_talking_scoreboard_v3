import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

part 'app_state.g.dart';

extension AppContext on BuildContext {
  AppBloc get readApp => read<AppBloc>();

  AppBloc get watchApp => watch<AppBloc>();
}

@JsonSerializable()
class AppState extends Equatable {
  const AppState({
    this.insults = const [],
    this.tieInsults = const [],
    this.availableVoices = const [],
    this.selectedVoice,
    this.originalDefaultInsults = const [],
    this.deletedDefaultInsults = const [],
    this.didCompleteInitialLoad = false,
  });

  factory AppState.fromJson(Map<String, dynamic> json) {
    return _$AppStateFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  AppState copyWith({
    List<String>? insults,
    List<String>? tieInsults,
    List<Voice>? availableVoices,
    Voice? selectedVoice,
    List<String>? originalDefaultInsults,
    List<String>? deletedDefaultInsults,
    bool? didCompleteInitialLoad,
  }) {
    return AppState(
      insults: insults ?? this.insults,
      tieInsults: tieInsults ?? this.tieInsults,
      availableVoices: availableVoices ?? this.availableVoices,
      selectedVoice: selectedVoice ?? this.selectedVoice,
      originalDefaultInsults:
          originalDefaultInsults ?? this.originalDefaultInsults,
      deletedDefaultInsults:
          deletedDefaultInsults ?? this.deletedDefaultInsults,
      didCompleteInitialLoad:
          didCompleteInitialLoad ?? this.didCompleteInitialLoad,
    );
  }

  final List<String> insults;
  final List<String> tieInsults;
  final List<Voice> availableVoices;
  final Voice? selectedVoice;
  final List<String> originalDefaultInsults;
  final List<String> deletedDefaultInsults;
  final bool didCompleteInitialLoad;

  @override
  String toString() {
    return 'AppState(\n'
        'insults:$insults\n'
        'tieInsults:$tieInsults\n'
        'availableVoices:$availableVoices\n'
        'selectedVoice:$selectedVoice\n'
        'originalDefaultInsults:$originalDefaultInsults\n'
        'deletedDefaultInsults:$deletedDefaultInsults\n'
        'didCompleteInitialLoad:$didCompleteInitialLoad\n'
        ')';
  }

  @override
  List<Object?> get props => [
        insults,
        tieInsults,
        availableVoices,
        selectedVoice,
        originalDefaultInsults,
        deletedDefaultInsults,
        didCompleteInitialLoad,
      ];
}
