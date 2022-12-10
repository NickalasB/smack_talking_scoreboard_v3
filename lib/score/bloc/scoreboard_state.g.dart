// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoreboard_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreboardState _$ScoreboardStateFromJson(Map<String, dynamic> json) =>
    ScoreboardState(
      Game.fromJson(json['game'] as Map<String, dynamic>),
      areInsultsEnabled: json['areInsultsEnabled'] as bool? ?? true,
      isGameInProgress: json['isGameInProgress'] as bool? ?? false,
    );

Map<String, dynamic> _$ScoreboardStateToJson(ScoreboardState instance) =>
    <String, dynamic>{
      'game': instance.game,
      'areInsultsEnabled': instance.areInsultsEnabled,
      'isGameInProgress': instance.isGameInProgress,
    };
