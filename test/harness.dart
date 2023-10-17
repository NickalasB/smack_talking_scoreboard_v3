import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/app/locale_service.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/insult_creator_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/score.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

import 'helpers/fake_bloc.dart';
import 'helpers/fake_scoreboard_dependencies_data.dart';
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
  FakeAppBloc appBloc = FakeAppBloc(const AppState());
  FakeScoreBloc scoreBloc = FakeScoreBloc(initialScoreboardState);
  FakeInsultCreatorBloc insultCreatorBloc =
      FakeInsultCreatorBloc(const InsultCreatorState(''));
  TestObserver navigationObserver = TestObserver();
}

extension AppGiven on WidgetTestGiven<AppHarness> {
  Future<void> pumpWidget(Widget child, {Brightness? brightness}) async {
    await harness.tester.pumpMaterialWidget(
      child,
      providers: [
        BlocProvider<ScoreboardBloc>(create: (context) => harness.scoreBloc),
        BlocProvider<AppBloc>(create: (context) => harness.appBloc),
        BlocProvider<InsultCreatorBloc>(
          create: (context) => harness.insultCreatorBloc,
        ),
      ],
      navigatorObserver: harness.navigationObserver,
      brightness: brightness,
    );
  }

  Future<void> pumpWidgetWithDependencies(Widget child) async {
    await harness.tester.pumpMaterialWidget(
      ScoreboardPageDependencies(
        data: harness,
        child: child,
      ),
      providers: [
        BlocProvider<ScoreboardBloc>(create: (context) => harness.scoreBloc),
        BlocProvider<AppBloc>(create: (context) => harness.appBloc),
      ],
    );
  }

  Future<void> pumpWidgetWithState(
    Widget child, {
    ScoreboardState? scoreboardState,
    AppState? appState,
    InsultCreatorState? insultCreatorState,
    Brightness brightness = Brightness.light,
  }) async {
    if (scoreboardState != null) {
      harness.scoreBloc = FakeScoreBloc(scoreboardState);
    }
    if (appState != null) {
      harness.appBloc = FakeAppBloc(appState);
    }
    if (insultCreatorState != null) {
      harness.insultCreatorBloc = FakeInsultCreatorBloc(insultCreatorState);
    }
    await harness.tester.pumpMaterialWidget(
      child,
      navigatorObserver: harness.navigationObserver,
      brightness: brightness,
      providers: [
        BlocProvider<ScoreboardBloc>(create: (_) => harness.scoreBloc),
        BlocProvider<AppBloc>(create: (_) => harness.appBloc),
        BlocProvider<InsultCreatorBloc>(
          create: (context) => harness.insultCreatorBloc,
        ),
      ],
    );
  }

  Future<void> scoreBoardState(ScoreboardState state) async {
    harness.scoreBloc.emit(state);
    await tick();
  }

  Future<void> appState(AppState state) async {
    harness.appBloc.emit(state);
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
      devices: devices ??
          [
            Device.phone,
            Device.tabletLandscape,
            Device.phone.dark(),
          ],
      customPump: shouldSkipPumpAndSettle
          ? (_) async {}
          : (tester) async {
              // This is needed to allow time to switch to dark mode
              await tester.pump(kThemeAnimationDuration);
              await tester.pump();
            },
    );
  }

  Future<void> screenMatchesGoldenFile(
    String name, {
    Finder? finder,
    bool shouldSkipPumpAndSettle = false,
  }) async {
    await screenMatchesGolden(
      tester,
      name,
      finder: finder,
      customPump: shouldSkipPumpAndSettle
          ? (_) async {}
          : (tester) async {
              // This is needed to allow time to switch to dark mode
              await tester.pump(kThemeAnimationDuration);
              await tester.pump();
            },
    );
  }

  void addedScoreBlocEvents(dynamic matcher) {
    expect(harness.scoreBloc.addedEvents, matcher);
  }

  void addedAppBlocEvents(dynamic matcher) {
    expect(harness.appBloc.addedEvents, matcher);
  }

  void addedInsultCreatorEvents(dynamic matcher) {
    expect(harness.insultCreatorBloc.addedEvents, matcher);
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
    harness.launchExitGameCompleters[0].complete(shouldExitGame);
  }

  void launchGameWinnerDialogCompletes({int at = 0, Player? withPlayer}) {
    harness.launchGameWinnerDialogCompleters[at].complete(withPlayer);
  }

  Future<void> userDragsWidgetTo({
    required Finder draggable,
    required Finder target,
  }) async {
    final firstLocation = tester.getCenter(draggable);
    final secondLocation = tester.getCenter(target);

    final gesture = await tester.startGesture(firstLocation);
    // Have to add 50 here as the feedbackOffset for the DraggableHiLowScore is
    // set to Offset(0, -50)
    await gesture.moveTo(Offset(secondLocation.dx, secondLocation.dy + 50));

    await gesture.up();
    await pumpAndSettle();
  }

  Future<void> userDragsWidgetToTargetThenOffTarget({
    required Finder draggable,
    required Finder target,
  }) async {
    final firstLocation = tester.getCenter(draggable);
    final secondLocation = tester.getCenter(target);

    final gesture = await tester.startGesture(firstLocation);
    // Have to add 50 here as the feedbackOffset for the DraggableHiLowScore is
    // set to Offset(0, -50)
    await gesture.moveTo(Offset(secondLocation.dx, secondLocation.dy + 50));

    await gesture.moveTo(firstLocation);
    await pumpAndSettle();
  }

  Future<void> pumpAndSettle() {
    return tester.pumpAndSettle(const Duration(seconds: 3));
  }

  Future<void> pump({Duration? duration}) {
    return tester.pump(duration);
  }

  // Use this when the screen will never pumpAndSettle
  // https://github.com/flutter/flutter/issues/60372#issuecomment-654634203
  Future<void> pumpForInfiniteAnimation() async {
    for (var count = 0; count < 2; count += 1) {
      await pump(duration: const Duration(seconds: 3));
    }
  }

  Future<void> userTypes(String text, Finder finder) {
    return tester.enterText(finder, text);
  }

  Future<void> idle() {
    return TestAsyncUtils.guard<void>(() => tester.binding.idle());
  }
}

class FakeScoreBloc extends FakeBloc<ScoreboardEvent, ScoreboardState>
    with TtsMixin
    implements ScoreboardBloc {
  FakeScoreBloc(super.initialState);
}

class FakeAppBloc extends FakeBloc<AppEvent, AppState>
    with TtsMixin, LocaleServiceMixin
    implements AppBloc {
  FakeAppBloc(super.initialState);

  @override
  AppState? get initialAppState => throw UnimplementedError();
}

class FakeInsultCreatorBloc
    extends FakeBloc<InsultCreatorEvent, InsultCreatorState>
    implements InsultCreatorBloc {
  FakeInsultCreatorBloc(super.initialState);
}

mixin TtsMixin {
  FakeTts get tts => FakeTts();
}

mixin LocaleServiceMixin {
  AppLocaleService get localeService => FakeLocaleService();
}

class FakeLocaleService implements AppLocaleService {
  String fakeLocaleName = 'en_US';

  @override
  String get platformLocaleName => fakeLocaleName;
}
