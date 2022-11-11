// coverage:ignore-file

import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';

typedef FakeScoreboardJson = Map<String, dynamic>?;

class FakeStorage implements Storage {
  final storageCompletersMap = <String, FakeScoreboardJson>{};

  @override
  Future<void> clear() async {
    storageCompletersMap.clear();
  }

  @override
  Future<void> delete(String key) async {
    storageCompletersMap.remove(key);
  }

  @override
  FakeScoreboardJson read(String key) {
    return storageCompletersMap[key];
  }

  @override
  Future<void> write(String key, dynamic value) async {
    storageCompletersMap.putIfAbsent(key, () => value as FakeScoreboardJson);
  }
}
