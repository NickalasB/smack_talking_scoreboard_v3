// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file:avoid_redundant_argument_values
// ignore_for_file:prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/round.dart';

import '../../flutter_test_config.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('HydratedScoreBloc', () {
    test('initial state is Game with Player1 and Player2 with scores of zero',
        () {
      final bloc = ScoreboardBloc();
      expect(testStorage.readForKeyCalls, ['ScoreboardBloc']);
      expect(testStorage.writeForKeyCalls, ['ScoreboardBloc']);

      final initialState = ScoreboardState(
        Game(
          players: const [
            Player(playerId: 1, score: 0),
            Player(playerId: 2, score: 0),
          ],
        ),
        insults: const [],
      );

      expect(
        bloc.state,
        equals(initialState),
      );

      expect(testStorage.readForKeyCalls, hasLength(1));
      expect(testStorage.writeForKeyCalls, hasLength(1));

      expect(
        bloc.fromJson(testStorage.read('ScoreboardBloc')!),
        initialState,
      );
    });

    group('IncreaseScoreEvent', () {
      test('should increase score by 1 when IncreaseScoreEvent added',
          () async {
        final bloc = ScoreboardBloc()..add(IncreaseScoreEvent(playerId: 1));
        await tick();
        expect(
          bloc.state,
          equals(
            const ScoreboardState(
              Game(
                players: [
                  Player(playerId: 1, score: 1, roundScore: 1),
                  Player(playerId: 2, score: 0, roundScore: 0),
                ],
              ),
            ),
          ),
        );
      });
    });

    group('DecreaseScoreEvent', () {
      test('should decrease score by 1 when DecreaseScoreEvent added',
          () async {
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

    group('SaveInsultEvent', () {
      test(
          'should emit state with new insult when SaveInsultEvent added with valid text',
          () async {
        final bloc = ScoreboardBloc();
        await tick();

        bloc.add(SaveInsultEvent('be better'));
        await tick();

        const updatedState = ScoreboardState(
          Game(
            players: [
              Player(playerId: 1, score: 0),
              Player(playerId: 2, score: 0),
            ],
          ),
          insults: ['be better'],
        );

        expect(
          bloc.state,
          equals(updatedState),
        );

        await tick();

        expect(
          bloc.fromJson(testStorage.read('ScoreboardBloc')!),
          updatedState,
        );
      });

      test(
          'should NOT emit state with new insult when SaveInsultEvent added with empty or null text',
          () async {
        final bloc = ScoreboardBloc();
        await tick();

        bloc.add(SaveInsultEvent(''));
        await tick();
        expect(
          bloc.state,
          equals(initialScoreboardState),
        );

        bloc.add(SaveInsultEvent(null));
        await tick();

        expect(
          bloc.state,
          equals(initialScoreboardState),
        );
      });

      test(
          'should emit proper state with insults and scores when both are update',
          () async {
        final bloc = ScoreboardBloc();
        await tick();

        bloc
          ..add(SaveInsultEvent('be better'))
          ..add(IncreaseScoreEvent(playerId: 1));
        await tick();
        await tick();

        const updatedState = ScoreboardState(
          Game(
            players: [
              Player(playerId: 1, score: 1, roundScore: 1),
              Player(playerId: 2, score: 0, roundScore: 0),
            ],
          ),
          insults: ['be better'],
        );

        expect(
          bloc.state,
          equals(updatedState),
        );

        await tick();

        expect(
          bloc.fromJson(testStorage.read('ScoreboardBloc')!),
          updatedState,
        );
      });
    });

    group('NextTurnEvent', () {
      test(
          'Should emit roundWinner based on player with highest round points, not total score',
          () async {
        final bloc = ScoreboardBloc()
          ..emit(
            ScoreboardState(
              Game(
                players: const [
                  Player(playerId: 1, score: 10),
                  Player(playerId: 2, score: 5),
                ],
              ),
            ),
          );
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 1));
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 2));
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 2));
        await tick();

        expect(
          bloc.state.game.players,
          [
            Player(playerId: 2, score: 7, roundScore: 2),
            Player(playerId: 1, score: 11, roundScore: 1),
          ],
        );

        bloc.add(NextTurnEvent());
        await tick();
        await tick();

        expect(
          bloc.state.game.round,
          Round(
            roundCount: 2,
            roundWinner: Player(playerId: 2, score: 7, roundScore: 2),
          ),
        );

        expect(
          bloc.fromJson(testStorage.read('ScoreboardBloc')!),
          isAScoreboardState.havingRound(
            Round(
              roundCount: 2,
              roundWinner: Player(playerId: 2, score: 7, roundScore: 2),
            ),
          ),
        );
      });

      test('Should emit correct roundWinner even if user decreases points',
          () async {
        final bloc = ScoreboardBloc()
          ..emit(
            ScoreboardState(
              Game(
                players: const [
                  Player(playerId: 1, score: 10),
                  Player(playerId: 2, score: 5),
                ],
              ),
            ),
          );
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 1));
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 2));
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 2));
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 2));
        await tick();

        /// decreasing score to cancel out last increase
        bloc.add(DecreaseScoreEvent(playerId: 2));
        await tick();

        expect(
          bloc.state.game.players,
          [
            Player(playerId: 1, score: 11, roundScore: 1),
            Player(playerId: 2, score: 7, roundScore: 2),
          ],
        );

        bloc.add(NextTurnEvent());
        await tick();
        await tick();

        expect(
          bloc.state.game.round,
          Round(
            roundCount: 2,
            roundWinner: Player(playerId: 2, score: 7, roundScore: 2),
          ),
        );
      });
    });

    group('ResetGameEvent', () {
      test('Should rest scores and rounds when ResetGameEvent added', () async {
        final inProgressGame = Game(
          players: const [
            Player(playerId: 1, score: 10),
            Player(playerId: 2, score: 5),
          ],
          round: Round(
            roundWinner: Player(playerId: 1, score: 10),
            roundCount: 10,
          ),
        );

        final bloc = ScoreboardBloc()
          ..emit(
            ScoreboardState(
              Game(
                players: const [
                  Player(playerId: 1, score: 10),
                  Player(playerId: 2, score: 5),
                ],
                round: Round(
                  roundWinner: Player(playerId: 1, score: 10),
                  roundCount: 10,
                ),
              ),
            ),
          );

        expect(
          bloc.state,
          ScoreboardState(inProgressGame),
        );

        bloc.add(ResetGameEvent());
        await tick();

        expect(
          bloc.state,
          initialScoreboardState,
        );
      });
    });
  });
}

final isAScoreboardState = TypeMatcher<ScoreboardState>();

extension on TypeMatcher<ScoreboardState> {
  TypeMatcher<ScoreboardState> havingRound(Round round) =>
      isAScoreboardState.having((p0) => p0.game.round, 'round', round);
}
