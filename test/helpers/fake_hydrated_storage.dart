// coverage:ignore-file

import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';

typedef FakeScoreboardJson = Map<String, dynamic>?;

class FakeStorage implements Storage {
  final storageMap = <String, FakeScoreboardJson>{};
  final readForKeyCalls = [];
  final writeForKeyCalls = [];

  @override
  Future<void> clear() async {
    readForKeyCalls.clear();
    writeForKeyCalls.clear();
    storageMap.clear();
  }

  @override
  Future<void> delete(String key) async {
    storageMap.remove(key);
  }

  @override
  FakeScoreboardJson read(String key) {
    readForKeyCalls.add(key);
    return storageMap[key];
  }

  @override
  Future<void> write(String key, dynamic value) async {
    writeForKeyCalls.add(key);
    final json = value as FakeScoreboardJson;
    storageMap.update(key, (value) => json, ifAbsent: () => json);
  }
}
