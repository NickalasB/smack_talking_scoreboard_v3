// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
      players: (json['players'] as List<dynamic>?)
              ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      round: json['round'] == null
          ? const Round()
          : Round.fromJson(json['round'] as Map<String, dynamic>),
      gamePointParams: GamePointParams.fromJson(
          json['gamePointParams'] as Map<String, dynamic>),
      gameWinner: json['gameWinner'] == null
          ? null
          : Player.fromJson(json['gameWinner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
      'players': instance.players,
      'round': instance.round,
      'gamePointParams': instance.gamePointParams,
      'gameWinner': instance.gameWinner,
    };
