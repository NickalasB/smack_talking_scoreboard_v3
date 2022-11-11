import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'helpers/fake_hydrated_storage.dart';

late FakeStorage testStorage;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  HydratedBloc.storage = FakeStorage();
  testStorage = HydratedBloc.storage as FakeStorage;
  await loadAppFonts();
  return testMain();
}
