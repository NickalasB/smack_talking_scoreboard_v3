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
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page.dart';

import '../../helpers/fake_bloc.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('ScoreboardPage', () {
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
        await when.tester.tap(find.byKey(const Key('increase_button')));
        expect(then.harness.scoreBloc.addedEvents, [IncreaseScoreEvent()]);
      }),
    );

    testWidgets(
      'should add DecreaseScoreEvent when add button tapped',
      appHarness((given, when, then) async {
        await given.appIsPumped();
        await when.tester.tap(find.byKey(const Key('decrease_button')));
        expect(then.harness.scoreBloc.addedEvents, [DecreaseScoreEvent()]);
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
  final scoreBloc = FakeScoreBloc(const ScoreboardState(0));
}

extension AppGiven on WidgetTestGiven<AppHarness> {
  Future<void> appIsPumped() async {
    await harness.tester.pumpApp(
      BlocProvider<ScoreBloc>(
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

extension AppThen on WidgetTestThen<AppHarness> {}

extension AppWhen on WidgetTestWhen<AppHarness> {
  Future<void> idle() {
    return TestAsyncUtils.guard<void>(() => tester.binding.idle());
  }
}

class FakeScoreBloc extends FakeBloc<CounterEvent, ScoreboardState>
    implements ScoreBloc {
  FakeScoreBloc(super.initialState);
}
