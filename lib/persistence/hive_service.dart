import 'package:hive/hive.dart';

abstract class HiveService {
  Future<bool> doesBoxExist({required String boxName});
  Future<void> createBox({required String boxName});

  Future<Map<String, dynamic>?> readBoxValues({
    required String boxName,
    required int index,
  });

  Future<int> addBoxValues({
    required String boxName,
    required Map<String, dynamic> boxValue,
  });

  Future<void> updateBoxValues({
    required String boxName,
    required int index,
    required Map<String, dynamic> newValue,
  });

  Future<void> deleteBoxValue({
    required int index,
    required String boxName,
  });

  Future<void> closeAllBoxes();
}

class HiveServiceImpl implements HiveService {
  const HiveServiceImpl(HiveInterface hive) : _hive = hive;

  final HiveInterface _hive;

  @override
  Future<bool> doesBoxExist({required String boxName}) async {
    return _hive.boxExists(boxName);
  }

  @override
  Future<void> createBox({
    required String boxName,
  }) async {
    await _hive.openBox<Map<String, dynamic>>(boxName);
  }

  @override
  Future<Map<String, dynamic>?> readBoxValues({
    required String boxName,
    required int index,
  }) async {
    try {
      return _hive.box<Map<String, dynamic>>(boxName).getAt(index);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<int> addBoxValues({
    required String boxName,
    required Map<String, dynamic> boxValue,
  }) async {
    return _hive.box<Map<String, dynamic>>(boxName).add(boxValue);
  }

  @override
  Future<void> deleteBoxValue({
    required int index,
    required String boxName,
  }) async {
    return _hive.box<Map<String, dynamic>>(boxName).deleteAt(index);
  }

  @override
  Future<void> closeAllBoxes() async {
    return _hive.close();
  }

  @override
  Future<void> updateBoxValues({
    required String boxName,
    required int index,
    required Map<String, dynamic> newValue,
  }) {
    return _hive.box<Map<String, dynamic>>(boxName).putAt(index, newValue);
  }
}
