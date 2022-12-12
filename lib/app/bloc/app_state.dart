import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';

part 'app_state.g.dart';

extension AppContext on BuildContext {
  AppBloc get readApp => read<AppBloc>();
  void addAppEvent(AppEvent event) => readApp.add(event);
}

@JsonSerializable()
class AppState extends Equatable {
  const AppState({
    this.insults = const [],
  });

  factory AppState.fromJson(Map<String, dynamic> json) {
    return _$AppStateFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  AppState copyWith({
    List<String>? insults,
  }) {
    return AppState(
      insults: insults ?? this.insults,
    );
  }

  final List<String> insults;

  @override
  List<Object?> get props => [insults];
}
