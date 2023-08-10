import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';

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
    this.didCompleteInitialLoad = false,
  });

  factory AppState.fromJson(Map<String, dynamic> json) {
    return _$AppStateFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  AppState copyWith({
    List<String>? insults,
    List<String>? tieInsults,
    bool? didCompleteInitialLoad,
  }) {
    return AppState(
      insults: insults ?? this.insults,
      tieInsults: tieInsults ?? this.tieInsults,
      didCompleteInitialLoad:
          didCompleteInitialLoad ?? this.didCompleteInitialLoad,
    );
  }

  final List<String> insults;
  final List<String> tieInsults;
  final bool didCompleteInitialLoad;

  @override
  List<Object?> get props => [insults, tieInsults, didCompleteInitialLoad];
}
