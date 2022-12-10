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
import 'package:smack_talking_scoreboard_v3/score/view/models/game_point_params.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
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
            testPlayer1.copyWith(playerName: 'Player 1', score: 0),
            testPlayer2.copyWith(playerName: 'Player 2', score: 0),
          ],
          gamePointParams: _initialPointParams,
        ),
      );

      expect(testStorage.readForKeyCalls, hasLength(1));
      expect(testStorage.writeForKeyCalls, hasLength(1));

      expectStateAndHydratedState(bloc, equals(initialState));
    });

    group('StartGameEvent', () {
      test('should emit game with players and GamePointParams from event',
          () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..add(
            StartGameEvent(
              player1: Player(playerId: 111, playerName: 'Foo'),
              player2: Player(playerId: 222, playerName: 'Bar'),
              gamePointParams: GamePointParams(
                winningScore: 1,
                pointsPerScore: 2,
                winByMargin: 3,
              ),
            ),
          );
        await tick();

        expectStateAndHydratedState(
          bloc,
          equals(
            initialScoreboardState.copyWith(
              game: initialScoreboardState.game.copyWith(
                players: [
                  Player(playerId: 111, playerName: 'Foo'),
                  Player(playerId: 222, playerName: 'Bar'),
                ],
                gamePointParams: GamePointParams(
                  winningScore: 1,
                  pointsPerScore: 2,
                  winByMargin: 3,
                ),
              ),
            ),
          ),
        );
      });

      test('should reset gameWinner when adding StartGameEvent', () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..emit(
            initialScoreboardState.copyWith(
              game:
                  initialScoreboardState.game.copyWith(gameWinner: testPlayer1),
            ),
          );

        expect(bloc.state.game.gameWinner, testPlayer1);

        bloc.add(
          StartGameEvent(
            player1: Player(playerId: 111, playerName: 'Foo'),
            player2: Player(playerId: 222, playerName: 'Bar'),
            gamePointParams: GamePointParams(
              winningScore: 1,
              pointsPerScore: 2,
              winByMargin: 3,
            ),
          ),
        );
        await tick();

        expect(bloc.state.game.gameWinner, isNull);
      });
    });

    group('IncreaseScoreEvent', () {
      test(
          'should default to increase score by 1 when IncreaseScoreEvent added',
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
                gamePointParams: _initialPointParams,
              ),
            ),
          ),
        );
      });

      test(
          'should increase score by gamePointParams.pointsPerScore when IncreaseScoreEvent added',
          () async {
        const pointsPerScore = 100;
        final bloc = ScoreboardBloc(FakeTts())
          ..add(
            StartGameEvent(
              player1: initialScoreboardState.game.players.first,
              player2: initialScoreboardState.game.players[1],
              gamePointParams: GamePointParams(
                winningScore: 21,
                pointsPerScore: pointsPerScore,
              ),
            ),
          )
          ..add(IncreaseScoreEvent(playerId: 1));
        await tick();
        await tick();
        expectStateAndHydratedState(
          bloc,
          equals(
            initialScoreboardState.copyWith(
              game: initialScoreboardState.game.copyWith(
                players: [
                  testPlayer1.copyWith(score: 100, roundScore: 100),
                  testPlayer2.copyWith(score: 0, roundScore: 0),
                ],
                gamePointParams: GamePointParams(
                  winningScore: 21,
                  pointsPerScore: pointsPerScore,
                ),
              ),
            ),
          ),
        );
      });

      test(
          'should emit players in correct order when score increased on player 2',
          () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..add(IncreaseScoreEvent(playerId: 2));
        await tick();
        expectStateAndHydratedState(
          bloc,
          equals(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 0, roundScore: 0),
                  testPlayer2.copyWith(score: 1, roundScore: 1),
                ],
                gamePointParams: _initialPointParams,
              ),
            ),
          ),
        );
      });
    });

    group('DecreaseScoreEvent', () {
      test(
          'should default to decrease score by 1 when DecreaseScoreEvent added',
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
                gamePointParams: _initialPointParams,
              ),
            ),
          ),
        );
      });

      test(
          'should decrease score by gamePointParams.pointsPerScore when DecreaseScoreEvent added',
          () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..add(
            StartGameEvent(
              player1: initialScoreboardState.game.players.first,
              player2: initialScoreboardState.game.players[1],
              gamePointParams: GamePointParams(
                winningScore: 21,
                pointsPerScore: 500,
              ),
            ),
          )
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
                  testPlayer2.copyWith(score: 500, roundScore: 500),
                ],
                gamePointParams: GamePointParams(
                  winningScore: 21,
                  pointsPerScore: 500,
                ),
              ),
            ),
          ),
        );
      });

      test(
          'should emit players in correct order when score decreased on player 2',
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
                gamePointParams: _initialPointParams,
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
                gamePointParams: _initialPointParams,
              ),
            ),
          ),
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
                gamePointParams: _initialPointParams,
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
            testPlayer1.copyWith(score: 11, roundScore: 1),
            testPlayer2.copyWith(score: 7, roundScore: 2),
          ],
        );

        bloc.add(NextTurnEvent(const ['any insult']));
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
                gamePointParams: _initialPointParams,
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

        bloc.add(NextTurnEvent(const ['any insult']));
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
                gamePointParams: _initialPointParams,
              ),
            ),
          );
        await tick();

        bloc.add(
          NextTurnEvent(const [r'$HI$ you are good. $LOW$ you are bad.']),
        );
        await tick();

        expect(
          fakeTts.fakeTsEvents,
          [FakeSpeakEvent('Player 1 you are good. Player 2 you are bad.')],
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
                gamePointParams: _initialPointParams,
              ),
            ),
          );
        await tick();

        bloc.add(NextTurnEvent(const <String>[]));
        await tick();

        expect(
          fakeTts.fakeTsEvents,
          isEmpty,
        );
      });

      test('Should emit gameWinner based on player with winningScore',
          () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..emit(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 20),
                  testPlayer2.copyWith(score: 20),
                ],
                gamePointParams: GamePointParams(winningScore: 21),
              ),
            ),
          );
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 1));
        await tick();

        bloc.add(NextTurnEvent(const <String>[]));
        await tick();

        expectStateAndHydratedState(
          bloc,
          isAScoreboardState.havingGameWinner(testPlayer1.copyWith(score: 21)),
        );
      });

      test(
          'Should emit gameWinner based on player with highest score and satisfied winByMargin',
          () async {
        final bloc = ScoreboardBloc(FakeTts())
          ..emit(
            ScoreboardState(
              Game(
                players: [
                  testPlayer1.copyWith(score: 20),
                  testPlayer2.copyWith(score: 20),
                ],
                gamePointParams: GamePointParams(
                  winningScore: 21,
                  winByMargin: 2,
                ),
              ),
            ),
          );
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 2));
        await tick();

        bloc.add(NextTurnEvent(const <String>[]));
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 1));
        await tick();

        bloc.add(NextTurnEvent(const <String>[]));
        await tick();

        expectStateAndHydratedState(
          bloc,
          isAScoreboardState.havingGameWinner(null),
        );

        bloc.add(IncreaseScoreEvent(playerId: 2));
        await tick();

        bloc.add(IncreaseScoreEvent(playerId: 2));
        await tick();

        bloc.add(NextTurnEvent(const <String>[]));
        await tick();

        expectStateAndHydratedState(
          bloc,
          isAScoreboardState.havingGameWinner(testPlayer2.copyWith(score: 23)),
        );
      });
    });

    group('ToggleInsultVolumeEvent', () {
      test('Should emit state with opposite areInsultsEnabled param', () async {
        final fakeTts = FakeTts();

        final bloc = ScoreboardBloc(fakeTts);
        await tick();

        expect(bloc.state.areInsultsEnabled, isTrue);

        bloc.add(ToggleInsultVolumeEvent());
        await tick();

        expect(fakeTts.fakeTsEvents, [FakeSetVolumeEvent(0)]);
        expect(bloc.state.areInsultsEnabled, isFalse);

        bloc.add(ToggleInsultVolumeEvent());
        await tick();
        expect(fakeTts.fakeTsEvents[1], FakeSetVolumeEvent(1));
        expect(bloc.state.areInsultsEnabled, isTrue);
      });
    });

    group('ResetGameEvent', () {
      test(
          'Should rest scores and rounds but keep gamePointParams when ResetGameEvent added',
          () async {
        final inProgressState = ScoreboardState(
          Game(
            players: [
              testPlayer1.copyWith(score: 10),
              testPlayer2.copyWith(score: 5),
            ],
            gamePointParams: GamePointParams(winningScore: 100),
            round: Round(
              roundWinner: testPlayer1.copyWith(score: 10),
              roundCount: 10,
            ),
          ),
        );

        final bloc = ScoreboardBloc(FakeTts())..emit(inProgressState);

        expectStateAndHydratedState(
          bloc,
          inProgressState,
        );

        bloc.add(ResetGameEvent(shouldKeepNames: false));
        await tick();

        expectStateAndHydratedState(
          bloc,
          initialScoreboardState.copyWith(
            game: initialScoreboardState.game.copyWith(
              gamePointParams: GamePointParams(
                winningScore: 100,
              ),
            ),
          ),
        );
      });

      test(
          'Should rest scores and rounds but keep NAMES and gamePointParams when ResetGameEvent added with shouldKeepNames: true',
          () async {
        final inProgressState = ScoreboardState(
          Game(
            players: [
              testPlayer1.copyWith(playerName: 'Nick', score: 10),
              testPlayer2.copyWith(playerName: 'Bob', score: 5),
            ],
            gamePointParams: GamePointParams(winningScore: 100),
            round: Round(
              roundWinner: testPlayer1.copyWith(score: 10),
              roundCount: 10,
            ),
          ),
        );

        final bloc = ScoreboardBloc(FakeTts())..emit(inProgressState);

        expectStateAndHydratedState(
          bloc,
          inProgressState,
        );

        bloc.add(ResetGameEvent(shouldKeepNames: true));
        await tick();

        expectStateAndHydratedState(
          bloc,
          initialScoreboardState.copyWith(
            game: initialScoreboardState.game.copyWith(
              players: [
                testPlayer1.copyWith(playerName: 'Nick', score: 0),
                testPlayer2.copyWith(playerName: 'Bob', score: 0),
              ],
              gamePointParams: GamePointParams(
                winningScore: 100,
              ),
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

  TypeMatcher<ScoreboardState> havingGameWinner(Player? player) =>
      isAScoreboardState.having(
        (p0) => p0.game.gameWinner,
        'gameWinner',
        player,
      );
}

void expectStateAndHydratedState(ScoreboardBloc bloc, dynamic matcher) {
  expect(bloc.state, matcher);
  expect(bloc.fromJson(testStorage.read('ScoreboardBloc')!), matcher);
}

final _initialPointParams = GamePointParams(
  winningScore: 21,
  pointsPerScore: 1,
  winByMargin: 1,
);
