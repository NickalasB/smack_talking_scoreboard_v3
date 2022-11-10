import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';

typedef StorageCompleter = Completer<dynamic>;

class FakeStorage implements Storage {
  final storageCompletersMap = <String, StorageCompleter>{};
  final storageCompleter = StorageCompleter();

  @override
  Future<void> clear() async {
    storageCompletersMap.clear();
  }

  @override
  Future<void> delete(String key) async {
    storageCompletersMap.remove(key);
    return storageCompleter.future;
  }

  @override
  StorageCompleter? read(String key) {
    return storageCompletersMap[key];
  }

  @override
  Future<void> write(String key, dynamic value) {
    storageCompletersMap.putIfAbsent(key, () => storageCompleter);
    return storageCompleter.future;
  }
}
