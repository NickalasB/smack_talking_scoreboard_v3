// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'round.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Round _$RoundFromJson(Map<String, dynamic> json) => Round(
      roundCount: json['roundCount'] as int? ?? 1,
      roundWinner: json['roundWinner'] == null
          ? null
          : Player.fromJson(json['roundWinner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoundToJson(Round instance) => <String, dynamic>{
      'roundCount': instance.roundCount,
      'roundWinner': instance.roundWinner,
    };
