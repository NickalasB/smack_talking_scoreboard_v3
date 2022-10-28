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
import 'package:smack_talking_scoreboard_v3/counter/counter.dart';

import '../../helpers/fake_bloc.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('CounterPage', () {
    testWidgets('renders CounterView', (tester) async {
      await tester.pumpApp(const CounterPage());
      expect(find.byType(CounterView), findsOneWidget);
    });
  });

  group('CounterView', () {
    testWidgets(
      'should add IncreaseScoreEvent when add button tapped',
      appHarness((given, when, then) async {
        await given.appIsPumped();
        await when.tester.tap(find.byKey(const Key('increase_button')));
        expect(then.harness.counterBloc.addedEvents, [IncreaseScoreEvent()]);
      }),
    );

    testWidgets(
      'should add DecreaseScoreEvent when add button tapped',
      appHarness((given, when, then) async {
        await given.appIsPumped();
        await when.tester.tap(find.byKey(const Key('decrease_button')));
        expect(then.harness.counterBloc.addedEvents, [DecreaseScoreEvent()]);
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
  final counterBloc = FakeCounterBloc(const CounterState(0));
}

extension AppGiven on WidgetTestGiven<AppHarness> {
  Future<void> appIsPumped() async {
    await harness.tester.pumpApp(
      BlocProvider<CounterBloc>(
        create: (context) => harness.counterBloc,
        child: Builder(
          builder: (context) {
            return const CounterView();
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

class FakeCounterBloc extends FakeBloc<CounterEvent, CounterState>
    implements CounterBloc {
  FakeCounterBloc(super.initialState);
}
