// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoreboard_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreboardState _$ScoreboardStateFromJson(Map<String, dynamic> json) =>
    ScoreboardState(
      Game.fromJson(json['game'] as Map<String, dynamic>),
      insults: (json['insults'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ScoreboardStateToJson(ScoreboardState instance) =>
    <String, dynamic>{
      'game': instance.game,
      'insults': instance.insults,
    };
