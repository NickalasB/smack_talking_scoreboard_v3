import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:smack_talking_scoreboard_v3/persistence/hive_service.dart';

void main() {
  late HiveServiceImpl hiveService;
  late HiveInterface hive;

  Future<HiveInterface> initHive() async {
    final tempDir = await Directory.systemTemp.createTemp();
    return Hive..init(tempDir.path);
  }

  setUp(() async {
    hive = await initHive();
    hiveService = HiveServiceImpl(hive);
  });

  tearDown(() async {
    await hiveService.closeAllBoxes();
  });

  group('Create Box/Read box', () {
    test('should create box', () async {
      await hiveService.createBox(
        boxName: 'anything',
      );

      await hiveService.addBoxValues(
        boxName: 'anything',
        boxValue: {'key': 'value'},
      );

      expect(
        await hiveService.readBoxValues(boxName: 'anything', index: 0),
        {'key': 'value'},
      );
    });

    test('doesBoxExist should return false if box does not exit', () async {
      expect(await hiveService.doesBoxExist(boxName: 'anything'), isFalse);
    });

    test('doesBoxExist should return true if box does not exit', () async {
      await hiveService.createBox(
        boxName: 'anything',
      );

      expect(await hiveService.doesBoxExist(boxName: 'anything'), isTrue);
    });
  });

  group('Update box values', () {
    test('Update box values', () async {
      await hiveService.createBox(
        boxName: 'anything',
      );

      await hiveService.addBoxValues(
        boxName: 'anything',
        boxValue: {'key': 'value'},
      );

      expect(
        await hiveService.readBoxValues(boxName: 'anything', index: 0),
        {'key': 'value'},
      );

      await hiveService.updateBoxValues(
        index: 0,
        boxName: 'anything',
        newValue: {'key': 'value2'},
      );

      expect(
        await hiveService.readBoxValues(boxName: 'anything', index: 0),
        {'key': 'value2'},
      );
    });
  });

  group('Delete box values', () {
    test('should delete value', () async {
      await hiveService.createBox(
        boxName: 'anything',
      );

      await hiveService.addBoxValues(
        boxName: 'anything',
        boxValue: {'key': 'value'},
      );

      expect(
        await hiveService.readBoxValues(boxName: 'anything', index: 0),
        {'key': 'value'},
      );

      await hiveService.deleteBoxValue(index: 0, boxName: 'anything');

      expect(
        await hiveService.readBoxValues(boxName: 'anything', index: 0),
        isEmpty,
      );
    });
  });
}
