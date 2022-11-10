import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'helpers/fake_hydrated_storage.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  HydratedBloc.storage = FakeStorage();
  await loadAppFonts();
  return testMain();
}
