// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      playerId: json['playerId'] as int,
      playerName: json['playerName'] as String,
      score: json['score'] as int? ?? 0,
      roundScore: json['roundScore'] as int? ?? 0,
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'playerId': instance.playerId,
      'playerName': instance.playerName,
      'score': instance.score,
      'roundScore': instance.roundScore,
    };
