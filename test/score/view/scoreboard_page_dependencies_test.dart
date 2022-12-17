import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/exit_game_dialog.dart';
import 'package:smack_talking_scoreboard_v3/score/view/game_winner_dialog.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page_dependencies.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

import '../../harness.dart';
import '../../helpers/pump_material_widget.dart';
import '../../helpers/test_helpers.dart';

void main() {
  testWidgets(
    'Should NOT update widget when data is the same',
    appHarness((given, when, then) async {
      expect(
        given.dependencies1.updateShouldNotify(given.dependencies1),
        isFalse,
      );
    }),
  );

  testWidgets(
    'Should update widget when data is NOT the same',
    appHarness((given, when, then) async {
      expect(
        given.dependencies1.updateShouldNotify(
          const ScoreboardPageDependencies(
            data: _TestScoreboardDependencies(),
            child: Placeholder(),
          ),
        ),
        isTrue,
      );
    }),
  );

  group('NavigationMixin', () {
    testWidgets(
      'Should launch ExitGameDialog when launchExitGameDialog called',
      integrationHarness((given, when, then) async {
        final globalKey = GlobalKey();
        await given.pumpWidgetWithRealDependencies(
          ScoreboardView(key: globalKey),
        );

        unawaited(
          when.harness.launchExitGameDialog(
            globalKey.currentContext!,
            scoreboardBloc: FakeScoreBloc(initialScoreboardState),
          ),
        );

        await when.tester.pump();
        expect(find.byType(ExitGameDialog), findsOneWidget);
      }),
    );

    testWidgets(
      'Should launch GameWinnerDialog when launchGameWinnerDialog called',
      integrationHarness((given, when, then) async {
        final globalKey = GlobalKey();
        await given.pumpWidgetWithRealDependencies(
          ScoreboardView(key: globalKey),
        );

        unawaited(
          when.harness.launchGameWinnerDialog(
            globalKey.currentContext!,
            testPlayer1,
            scoreboardBloc: FakeScoreBloc(initialScoreboardState),
          ),
        );

        await when.tester.pump();
        expect(find.byType(GameWinnerDialog), findsOneWidget);
      }),
    );
  });
}

extension on WidgetTestGiven<AppHarness> {
  ScoreboardPageDependencies get dependencies1 => ScoreboardPageDependencies(
        data: harness,
        child: const Placeholder(),
      );
}

class _TestScoreboardDependencies extends StatelessWidget with NavigationMixin {
  const _TestScoreboardDependencies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScoreboardPageDependencies(
        data: this,
        child: Builder(
          builder: (context) {
            return PrimaryButton(
              label: 'test',
              onPressed: () async {
                await ScoreboardPageDependencies.of(context)
                    ?.data
                    .launchExitGameDialog(
                      context,
                      scoreboardBloc: FakeScoreBloc(initialScoreboardState),
                    );
              },
            );
          },
        ),
      ),
    );
  }
}

Future<void> Function(WidgetTester) integrationHarness(
  WidgetTestHarnessCallback<IntegrationHarness> callback,
) {
  return (tester) =>
      givenWhenThenWidgetTest(IntegrationHarness(tester), callback);
}

class IntegrationHarness extends WidgetTestHarness with NavigationMixin {
  IntegrationHarness(super.tester);
  FakeScoreBloc scoreBloc = FakeScoreBloc(initialScoreboardState);
  FakeAppBloc appBloc = FakeAppBloc(const AppState());
}

extension IntegrationGiven on WidgetTestGiven<IntegrationHarness> {
  Future<void> pumpWidgetWithRealDependencies(Widget child) async {
    await harness.tester.pumpMaterialWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ScoreboardBloc>(create: (context) => harness.scoreBloc),
          BlocProvider<AppBloc>(create: (context) => harness.appBloc),
        ],
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
}

extension IntegrationHarnessWhen on WidgetTestWhen<IntegrationHarness> {
  Future<dynamic> deviceBackButtonPressedResult() async {
    final dynamic widgetsAppState =
        harness.tester.state(find.byType(WidgetsApp));

    // ignore: avoid_dynamic_calls
    return widgetsAppState.didPopRoute();
  }
}
