// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file:avoid_redundant_argument_values
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('ScoreBloc', () {
    test('initial state is 0', () {
      expect(
        ScoreboardBloc().state,
        equals(
          const ScoreboardState(
            Game(
              players: [
                Player(playerId: 1, score: 0),
                Player(playerId: 2, score: 0),
              ],
            ),
          ),
        ),
      );
    });

    test('should increase score by 1 when IncreaseScoreEvent added', () async {
      final bloc = ScoreboardBloc()..add(IncreaseScoreEvent(playerId: 1));
      await tick();
      expect(
        bloc.state,
        equals(
          const ScoreboardState(
            Game(
              players: [
                Player(playerId: 1, score: 1),
                Player(playerId: 2, score: 0),
              ],
            ),
          ),
        ),
      );
    });

    test('should decrease score by 1 when DecreaseScoreEvent added', () async {
      final bloc = ScoreboardBloc()..add(IncreaseScoreEvent(playerId: 2));
      await tick();
      bloc.add(DecreaseScoreEvent(playerId: 2));
      await tick();
      expect(
        bloc.state,
        equals(
          const ScoreboardState(
            Game(
              players: [
                Player(playerId: 1, score: 0),
                Player(playerId: 2, score: 0),
              ],
            ),
          ),
        ),
      );
    });

    test(
        'should not decrease score by 1 when DecreaseScoreEvent added if score is zero',
        () async {
      final bloc = ScoreboardBloc()..add(DecreaseScoreEvent(playerId: 1));
      await tick();
      expect(
        bloc.state,
        equals(
          const ScoreboardState(
            Game(
              players: [
                Player(playerId: 1, score: 0),
                Player(playerId: 2, score: 0),
              ],
            ),
          ),
        ),
      );
    });
  });
}
