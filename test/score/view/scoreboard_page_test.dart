// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page.dart';

import '../../helpers/fake_bloc.dart';
import '../../helpers/pump_app.dart';
import 'scoreboard_page_objects.dart';

final scoreboardPage = ScoreBoardPageObject();

void main() {
  group('ScoreboardPage', () {
    testGoldens(
      'Should look correct',
      appHarness((given, when, then) async {
        await given.appIsPumped();

        await expectLater(
          find.byType(ScoreboardView),
          matchesGoldenFile('../view/goldens/scoreboard_page.png'),
        );
      }),
    );

    testWidgets('renders ScoreboardView', (tester) async {
      await tester.pumpApp(const ScoreboardPage());
      expect(find.byType(ScoreboardView), findsOneWidget);
    });
  });

  group('ScoreboardView', () {
    testWidgets(
      'should add IncreaseScoreEvent when add button tapped',
      appHarness((given, when, then) async {
        await given.appIsPumped();
        await when.tester.tap(scoreboardPage.playerScore(forPlayerId: 1));
        expect(
          then.harness.scoreBloc.addedEvents,
          [IncreaseScoreEvent(playerId: 1)],
        );
      }),
    );

    testWidgets(
      'should add DecreaseScoreEvent when swiping down on player score',
      appHarness((given, when, then) async {
        await given.appIsPumped();

        await when.tester.timedDrag(
          scoreboardPage.playerScore(forPlayerId: 1),
          const Offset(0, 300),
          const Duration(milliseconds: 750),
        );

        await when.tester.pumpAndSettle();
        expect(
          then.harness.scoreBloc.addedEvents,
          [DecreaseScoreEvent(playerId: 1)],
        );
      }),
    );

    testWidgets(
      'should add IncreaseScoreEvent when swiping up on player score',
      appHarness((given, when, then) async {
        await given.appIsPumped();

        await when.tester.timedDrag(
          scoreboardPage.playerScore(forPlayerId: 1),
          const Offset(0, -300),
          const Duration(milliseconds: 750),
        );

        await when.tester.pumpAndSettle();
        expect(
          then.harness.scoreBloc.addedEvents,
          [IncreaseScoreEvent(playerId: 1)],
        );
      }),
    );
  });
}

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
  Future<void> multiScreenGoldensMatch(
    String testName, {
    List<Device>? devices,
  }) {
    return multiScreenGolden(tester, testName, devices: devices);
  }
}

extension AppWhen on WidgetTestWhen<AppHarness> {
  Future<void> idle() {
    return TestAsyncUtils.guard<void>(() => tester.binding.idle());
  }
}

class FakeScoreBloc extends FakeBloc<ScoreboardEvent, ScoreboardState>
    implements ScoreboardBloc {
  FakeScoreBloc(super.initialState);
}
