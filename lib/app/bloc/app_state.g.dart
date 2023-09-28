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
      availableVoices: (json['availableVoices'] as List<dynamic>?)
              ?.map((e) => Voice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      selectedVoice: json['selectedVoice'] == null
          ? null
          : Voice.fromJson(json['selectedVoice'] as Map<String, dynamic>),
      originalDefaultInsults: (json['originalDefaultInsults'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      deletedDefaultInsults: (json['deletedDefaultInsults'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      didCompleteInitialLoad: json['didCompleteInitialLoad'] as bool? ?? false,
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'insults': instance.insults,
      'tieInsults': instance.tieInsults,
      'availableVoices': instance.availableVoices,
      'selectedVoice': instance.selectedVoice,
      'originalDefaultInsults': instance.originalDefaultInsults,
      'deletedDefaultInsults': instance.deletedDefaultInsults,
      'didCompleteInitialLoad': instance.didCompleteInitialLoad,
    };
