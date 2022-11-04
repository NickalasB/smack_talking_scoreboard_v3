import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page.dart';

import 'helpers/fake_bloc.dart';
import 'helpers/pump_app.dart';

Future<void> Function(WidgetTester) appHarness(
  WidgetTestHarnessCallback<AppHarness> callback,
) {
  return (tester) => givenWhenThenWidgetTest(AppHarness(tester), callback);
}

class AppHarness extends WidgetTestHarness {
  AppHarness(super.tester);
  final scoreBloc = FakeScoreBloc(initialScoreboardState);
}

extension AppGiven on WidgetTestGiven<AppHarness> {
  Future<void> appIsPumped() async {
    await harness.tester.pumpApp(
      BlocProvider<ScoreboardBloc>(
        create: (context) => harness.scoreBloc,
        child: Builder(
          builder: (context) {
            return const ScoreboardView();
          },
        ),
      ),
    );
  }
}

extension AppThen on WidgetTestThen<AppHarness> {
  void findsWidget(Finder finder) {
    return expect(finder, findsOneWidget);
  }

  Future<void> multiScreenGoldensMatch(
    String testName, {
    List<Device>? devices,
  }) {
    return multiScreenGolden(tester, testName, devices: devices);
  }
}

extension AppWhen on WidgetTestWhen<AppHarness> {
  Future<void> userTaps(Finder finder) {
    return tester.tap(finder);
  }

  Future<void> pumpAndSettle() {
    return tester.pumpAndSettle(const Duration(seconds: 3));
  }

  Future<void> idle() {
    return TestAsyncUtils.guard<void>(() => tester.binding.idle());
  }
}

class FakeScoreBloc extends FakeBloc<ScoreboardEvent, ScoreboardState>
    implements ScoreboardBloc {
  FakeScoreBloc(super.initialState);
}
