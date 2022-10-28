// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('ScoreBloc', () {
    test('initial state is 0', () {
      expect(ScoreBloc().state, equals(const ScoreboardState(0)));
    });

    test('should increase score by 1 when IncreaseScoreEvent added', () async {
      final bloc = ScoreBloc()..add(IncreaseScoreEvent());
      await tick();
      expect(bloc.state, equals(const ScoreboardState(1)));
    });

    test('should decrease score by 1 when DecreaseScoreEvent added', () async {
      final bloc = ScoreBloc()..add(IncreaseScoreEvent());
      await tick();
      expect(bloc.state, equals(const ScoreboardState(1)));
      bloc.add(DecreaseScoreEvent());
      await tick();
      expect(bloc.state, equals(const ScoreboardState(0)));
    });

    test(
        'should not decrease score by 1 when DecreaseScoreEvent added if score is zero',
        () async {
      final bloc = ScoreBloc()..add(DecreaseScoreEvent());
      await tick();
      expect(bloc.state, equals(const ScoreboardState(0)));
    });
  });
}
