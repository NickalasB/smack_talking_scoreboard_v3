// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
      insults: (json['insults'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isGameInProgress: json['isGameInProgress'] as bool? ?? false,
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'insults': instance.insults,
      'isGameInProgress': instance.isGameInProgress,
    };
