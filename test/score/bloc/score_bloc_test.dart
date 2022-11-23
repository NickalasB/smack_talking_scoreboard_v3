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
import 'package:smack_talking_scoreboard_v3/score/view/models/round.dart';

import '../../flutter_test_config.dart';
import '../../helpers/fake_tts.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('HydratedScoreBloc', () {
    test('initial state is Game with Player1 and Player2 with scores of zero',
        () {
      final bloc = ScoreboardBloc(FakeTts());
      expect(testStorage.readForKeyCalls, ['ScoreboardBloc']);
      expect(testStorage.writeForKeyCalls, ['ScoreboardBloc']);

      final initialState = ScoreboardState(
        Game(
          players: [
            testPlayer1.copyWith(playerName: 'Player1', score: 0),
            testPlayer2.copyWith(playerName: 'Player2', score: 0),
          ],
        ),
        insults: const [],
      );

      expect(testStorage.readForKeyCalls, hasLength(1));
      expect(testStorage.writeForKeyCalls, hasLength(1));

      expectStateAndHydratedState(bloc, equals(initialState));
    });

    group('IncreaseScoreEvent', () {
      test('should increase score by 1 when IncreaseScoreEvent added',
          () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..add(IncreaseScoreEvent(playerId: 1));
        await tick();
        expectStateAndHydratedState(
          bloc,
          equals(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 1, roundScore: 1),
                  testPlayer2.copyWith(score: 0, roundScore: 0),
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
        final bloc = ScoreboardBloc(FakeTts())
          ..add(IncreaseScoreEvent(playerId: 2));
        await tick();
        bloc.add(DecreaseScoreEvent(playerId: 2));
        await tick();
        expectStateAndHydratedState(
          bloc,
          equals(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 0),
                  testPlayer2.copyWith(score: 0),
                ],
              ),
            ),
          ),
        );
      });

      test(
          'should not decrease score by 1 when DecreaseScoreEvent added if score is zero',
          () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..add(DecreaseScoreEvent(playerId: 1));
        await tick();
        expectStateAndHydratedState(
          bloc,
          equals(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 0),
                  testPlayer2.copyWith(score: 0),
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
        final bloc = ScoreboardBloc(FakeTts());
        await tick();

        bloc.add(SaveInsultEvent('be better'));
        await tick();

        final updatedState = ScoreboardState(
          Game(
            players: [
              testPlayer1.copyWith(score: 0),
              testPlayer2.copyWith(score: 0),
            ],
          ),
          insults: const ['be better'],
        );

        await tick();

        expectStateAndHydratedState(bloc, equals(updatedState));
      });

      test(
          'should NOT emit state with new insult when SaveInsultEvent added with empty or null text',
          () async {
        final bloc = ScoreboardBloc(FakeTts());
        await tick();

        bloc.add(SaveInsultEvent(''));
        await tick();
        expectStateAndHydratedState(
          bloc,
          equals(initialScoreboardState),
        );

        bloc.add(SaveInsultEvent(null));
        await tick();

        expectStateAndHydratedState(
          bloc,
          equals(initialScoreboardState),
        );
      });

      test(
          'should emit proper state with insults and scores when both are update',
          () async {
        final bloc = ScoreboardBloc(FakeTts());
        await tick();

        bloc
          ..add(SaveInsultEvent('be better'))
          ..add(IncreaseScoreEvent(playerId: 1));
        await tick();
        await tick();

        final updatedState = ScoreboardState(
          Game(
            players: [
              testPlayer1.copyWith(score: 1, roundScore: 1),
              testPlayer2.copyWith(score: 0, roundScore: 0),
            ],
          ),
          insults: const ['be better'],
        );

        await tick();

        expectStateAndHydratedState(
          bloc,
          updatedState,
        );
      });
    });

    group('NextTurnEvent', () {
      test(
          'Should emit roundWinner based on player with highest round points, not total score',
          () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..emit(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 10),
                  testPlayer2.copyWith(score: 5),
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
            testPlayer1.copyWith(score: 7, roundScore: 2),
            testPlayer2.copyWith(score: 11, roundScore: 1),
          ],
        );

        bloc.add(NextTurnEvent());
        await tick();
        await tick();

        expect(
          bloc.state.game.round,
          Round(
            roundCount: 2,
            roundWinner: testPlayer2.copyWith(score: 7, roundScore: 2),
          ),
        );

        expectStateAndHydratedState(
          bloc,
          isAScoreboardState.havingRound(
            Round(
              roundCount: 2,
              roundWinner: testPlayer2.copyWith(score: 7, roundScore: 2),
            ),
          ),
        );
      });

      test('Should emit correct roundWinner even if user decreases points',
          () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..emit(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 10),
                  testPlayer2.copyWith(score: 5),
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
            testPlayer1.copyWith(score: 11, roundScore: 1),
            testPlayer2.copyWith(score: 7, roundScore: 2),
          ],
        );

        bloc.add(NextTurnEvent());
        await tick();
        await tick();

        expect(
          bloc.state.game.round,
          Round(
            roundCount: 2,
            roundWinner: testPlayer2.copyWith(score: 7, roundScore: 2),
          ),
        );
      });

      test(
          'Should call tts.speak with correctly modified insult when NextTurnEvent added',
          () async {
        final fakeTts = FakeTts();
        final bloc = ScoreboardBloc(fakeTts)
          ..emit(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 10),
                  testPlayer2.copyWith(score: 5),
                ],
              ),
              insults: const [r'$HI$ you are good. $LOW$ you are bad.'],
            ),
          );
        await tick();

        bloc.add(NextTurnEvent());
        await tick();

        expect(
          fakeTts.fakeTsEvents,
          [FakeSpeakEvent('Player1 you are good. Player2 you are bad.')],
        );
      });

      test(
          'Should not call tts.speak if insults are empty when NextTurnEvent added',
          () async {
        final fakeTts = FakeTts();
        final bloc = ScoreboardBloc(fakeTts)
          ..emit(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 10),
                  testPlayer2.copyWith(score: 5),
                ],
              ),
              insults: const [],
            ),
          );
        await tick();

        bloc.add(NextTurnEvent());
        await tick();

        expect(
          fakeTts.fakeTsEvents,
          isEmpty,
        );
      });
    });

    group('ResetGameEvent', () {
      test(
          'Should rest scores and rounds but keep insults when ResetGameEvent added',
          () async {
        final inProgressState = ScoreboardState(
          Game(
            players: [
              testPlayer1.copyWith(score: 10),
              testPlayer2.copyWith(score: 5),
            ],
            round: Round(
              roundWinner: testPlayer1.copyWith(score: 10),
              roundCount: 10,
            ),
          ),
          insults: const ['I should not be deleted when resetting game'],
        );

        final bloc = ScoreboardBloc(FakeTts())..emit(inProgressState);

        expectStateAndHydratedState(
          bloc,
          inProgressState,
        );

        bloc.add(ResetGameEvent());
        await tick();

        expectStateAndHydratedState(
          bloc,
          initialScoreboardState.copyWith(
            insults: const ['I should not be deleted when resetting game'],
          ),
        );
      });
    });

    group('DeleteInsultEvent', () {
      test('Should remove insult when DeleteInsultEvent added', () async {
        final stateWithInsults = ScoreboardState(
          Game(),
          insults: const [
            'insult1',
            'insult2',
          ],
        );

        final bloc = ScoreboardBloc(FakeTts())..emit(stateWithInsults);
        await tick();

        bloc.add(DeleteInsultEvent('insult1'));
        await tick();

        expectStateAndHydratedState(
          bloc,
          equals(
            stateWithInsults.copyWith(
              insults: const ['insult2'],
            ),
          ),
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

void expectStateAndHydratedState(ScoreboardBloc bloc, dynamic matcher) {
  expect(bloc.state, matcher);
  expect(bloc.fromJson(testStorage.read('ScoreboardBloc')!), matcher);
}
