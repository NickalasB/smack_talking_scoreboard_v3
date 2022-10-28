// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/counter/counter.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('CounterBloc', () {
    test('initial state is 0', () {
      expect(CounterBloc().state, equals(const CounterState(0)));
    });

    test('should increase score by 1 when IncreaseScoreEvent added', () async {
      final bloc = CounterBloc()..add(IncreaseScoreEvent());
      await tick();
      expect(bloc.state, equals(const CounterState(1)));
    });

    test('should decrease score by 1 when DecreaseScoreEvent added', () async {
      final bloc = CounterBloc()..add(IncreaseScoreEvent());
      await tick();
      expect(bloc.state, equals(const CounterState(1)));
      bloc.add(DecreaseScoreEvent());
      await tick();
      expect(bloc.state, equals(const CounterState(0)));
    });

    test(
        'should not decrease score by 1 when DecreaseScoreEvent added if score is zero',
        () async {
      final bloc = CounterBloc()..add(DecreaseScoreEvent());
      await tick();
      expect(bloc.state, equals(const CounterState(0)));
    });
  });
}
