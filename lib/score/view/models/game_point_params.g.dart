// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_point_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GamePointParams _$GamePointParamsFromJson(Map<String, dynamic> json) =>
    GamePointParams(
      winningScore: json['winningScore'] as int,
      pointsPerScore: json['pointsPerScore'] as int? ?? 1,
      winByMargin: json['winByMargin'] as int? ?? 1,
    );

Map<String, dynamic> _$GamePointParamsToJson(GamePointParams instance) =>
    <String, dynamic>{
      'winningScore': instance.winningScore,
      'pointsPerScore': instance.pointsPerScore,
      'winByMargin': instance.winByMargin,
    };
