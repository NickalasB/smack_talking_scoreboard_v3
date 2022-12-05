import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboared_page_dependencies.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

import 'helpers/FakeScoreboardDependenciesData.dart';
import 'helpers/fake_bloc.dart';
import 'helpers/fake_tts.dart';
import 'helpers/pump_material_widget.dart';
import 'helpers/test_helpers.dart';
import 'helpers/test_observer.dart';

Future<void> Function(WidgetTester) appHarness(
  WidgetTestHarnessCallback<AppHarness> callback,
) {
  return (tester) => givenWhenThenWidgetTest(AppHarness(tester), callback);
}

class AppHarness extends WidgetTestHarness with FakeScoreboardDependenciesData {
  AppHarness(super.tester);
  FakeScoreBloc scoreBloc = FakeScoreBloc(initialScoreboardState);
  TestObserver navigationObserver = TestObserver();
}

extension AppGiven on WidgetTestGiven<AppHarness> {
  Future<void> pumpWidget(Widget child) async {
    await harness.tester.pumpMaterialWidget(
      BlocProvider<ScoreboardBloc>(
        create: (context) => harness.scoreBloc,
        child: Builder(
          builder: (context) {
            return child;
          },
        ),
      ),
      navigatorObserver: harness.navigationObserver,
    );
  }

  Future<void> pumpWidgetWithDependencies(Widget child) async {
    await harness.tester.pumpMaterialWidget(
      BlocProvider<ScoreboardBloc>(
        create: (context) => harness.scoreBloc,
        child: Builder(
          builder: (context) {
            return ScoreboardPageDependencies(
              data: harness,
              child: child,
            );
          },
        ),
      ),
    );
  }

  Future<void> pumpWidgetWithState(
    Widget child, {
    required ScoreboardState scoreboardState,
  }) async {
    harness.scoreBloc = FakeScoreBloc(scoreboardState);
    await harness.tester.pumpMaterialWidget(
      BlocProvider<ScoreboardBloc>(
        create: (context) => harness.scoreBloc,
        child: Builder(
          builder: (context) {
            return child;
          },
        ),
      ),
      navigatorObserver: harness.navigationObserver,
    );
  }

  Future<void> scoreBoardState(ScoreboardState state) async {
    harness.scoreBloc.emit(state);
    await tick();
  }
}

extension AppThen on WidgetTestThen<AppHarness> {
  void findsWidget(Finder finder) {
    return expect(finder, findsOneWidget);
  }

  void findsWidgets(Finder finder, {required int widgetCount}) {
    return expect(finder, findsNWidgets(widgetCount));
  }

  void findsNoWidget(Finder finder) {
    return expect(finder, findsNothing);
  }

  Future<void> multiScreenGoldensMatch(
    String testName, {
    List<Device>? devices,
    bool shouldSkipPumpAndSettle = false,
  }) {
    return multiScreenGolden(
      tester,
      testName,
      devices: devices,
      customPump: shouldSkipPumpAndSettle ? (_) async {} : null,
    );
  }

  Future<void> screenMatchesGolden(Finder finder, String name) async {
    await expectLater(
      finder,
      matchesGoldenFile('./goldens/$name.png'),
    );
  }

  void addedScoreBlocEvents(Matcher matcher) {
    expect(harness.scoreBloc.addedEvents, matcher);
  }
}

extension AppWhen on WidgetTestWhen<AppHarness> {
  Future<void> userTaps(Finder finder) {
    return tester.tap(finder);
  }

  Future<void> userSwipesHorizontally(Finder finder, {double dx = -3000.00}) {
    return tester.drag(finder, Offset(dx, 0));
  }

  Future<void> userDragsVertically(Finder finder, Offset offset) {
    return tester.timedDrag(
      finder,
      offset,
      const Duration(milliseconds: 750),
    );
  }

  Future<dynamic> deviceBackButtonPressedResult() async {
    final dynamic widgetsAppState =
        harness.tester.state(find.byType(WidgetsApp));

    // ignore: avoid_dynamic_calls
    return widgetsAppState.didPopRoute();
  }

  void exitGameDialogReturns({required bool shouldExitGame}) {
    harness.exitGameCompleters[0].complete(shouldExitGame);
  }

  Future<void> userDragsWidgetTo({
    required Finder draggable,
    required Finder target,
  }) async {
    final firstLocation = tester.getCenter(draggable);
    final secondLocation = tester.getCenter(target);

    final gesture = await tester.startGesture(firstLocation);
    await gesture.moveTo(secondLocation);

    await gesture.up();
    await pumpAndSettle();
  }

  Future<void> pumpAndSettle() {
    return tester.pumpAndSettle(const Duration(seconds: 3));
  }

  Future<void> pump({Duration? duration}) {
    return tester.pump(duration);
  }

  Future<void> userTypes(String text, Finder finder) {
    return tester.enterText(finder, text);
  }

  Future<void> idle() {
    return TestAsyncUtils.guard<void>(() => tester.binding.idle());
  }
}

class FakeScoreBloc extends FakeBloc<ScoreboardEvent, ScoreboardState>
    implements ScoreboardBloc {
  FakeScoreBloc(super.initialState);

  @override
  Tts get tts => FakeTts();
}
