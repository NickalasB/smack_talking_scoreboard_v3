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
      tieInsults: (json['tieInsults'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      didCompleteInitialLoad: json['didCompleteInitialLoad'] as bool? ?? false,
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'insults': instance.insults,
      'tieInsults': instance.tieInsults,
      'didCompleteInitialLoad': instance.didCompleteInitialLoad,
    };
