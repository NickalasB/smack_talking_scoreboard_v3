// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
// ignore_for_file:avoid_redundant_argument_values
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

const hiPlayerInsultKey = '##HI##';
const lowPlayerInsultKey = '##LOW##';

class ScoreboardBloc extends HydratedBloc<ScoreboardEvent, ScoreboardState> {
  ScoreboardBloc(this.tts) : super(initialScoreboardState) {
    on<StartGameEvent>(_startGame);

    on<IncreaseScoreEvent>(_increaseScore);

    on<DecreaseScoreEvent>(_decreaseScore);

    on<NextTurnEvent>(_changeToNextTurn);

    on<ToggleInsultVolumeEvent>(_toggleInsultVolume);

    on<GameOverEvent>(_gameOverEvent);

    on<ResetGameEvent>(_resetGame);

    on<SpeakInsultEvent>(_speak);
  }
  final Tts tts;
  final List<String?> _emittedInsults = [];
  final List<String?> _emittedTieInsults = [];

  void _startGame(StartGameEvent event, Emitter<ScoreboardState> emit) {
    return emit(
      state.copyWith(
        isGameInProgress: true,
        game: state.game.copyWith(
          players: [event.player1, event.player2],
          gamePointParams: event.gamePointParams,
          gameWinner: null,
        ),
      ),
    );
  }

  void _increaseScore(IncreaseScoreEvent event, Emitter<ScoreboardState> emit) {
    final players = List<Player>.from(state.game.players);

    final currentPlayer =
        players.singleWhereOrNull((p) => p.playerId == event.playerId);

    if (currentPlayer != null) {
      final currentScore = currentPlayer.score;

      final updatedPlayers = players
        ..remove(currentPlayer)
        ..add(
          currentPlayer.copyWith(
            score: currentScore + state.game.gamePointParams.pointsPerScore,
            roundScore: currentPlayer.roundScore +
                state.game.gamePointParams.pointsPerScore,
          ),
        )
        ..sort((a, b) => a.playerId.compareTo(b.playerId));

      return emit(
        state.copyWith(
          game: state.game.copyWith(players: updatedPlayers),
        ),
      );
    }
  }

  void _decreaseScore(DecreaseScoreEvent event, Emitter<ScoreboardState> emit) {
    final players = List<Player>.from(state.game.players);

    final currentPlayer =
        players.singleWhereOrNull((p) => p.playerId == event.playerId);

    if (currentPlayer != null && currentPlayer.score >= 1) {
      final currentScore = currentPlayer.score;

      final updatedPlayers = players
        ..remove(currentPlayer)
        ..add(
          currentPlayer.copyWith(
            score: currentScore - state.game.gamePointParams.pointsPerScore,
            roundScore: currentPlayer.roundScore -
                state.game.gamePointParams.pointsPerScore,
          ),
        )
        ..sort((a, b) => a.playerId.compareTo(b.playerId));

      return emit(
        state.copyWith(
          game: state.game.copyWith(
            players: updatedPlayers,
          ),
        ),
      );
    }
  }

  // TODO(me): handle tie game case + hitting button twice emits wrong player
  void _changeToNextTurn(NextTurnEvent event, Emitter<ScoreboardState> emit) {
    final game = state.game;
    final players = game.players;
    Player? roundWinner;
    Player? roundLoser;

    final roundScores = players.map((e) => e.roundScore).toSet();

    if (roundScores.length > 1) {
      final roundHighScore = roundScores.max;
      roundWinner =
          players.firstWhereOrNull((p) => p.roundScore == roundHighScore);

      roundLoser =
          players.firstWhereOrNull((element) => element != roundWinner);
    }

    final playersWithResetRoundScores = <Player>[];

    String? newInsult;

    for (final player in game.players) {
      playersWithResetRoundScores.add(player.copyWith(roundScore: 0));
    }

    final insults = List<String>.from(event.insults);
    final tieInsults = List<String>.from(event.tieInsults);
    if (insults.isNotEmpty && state.areInsultsEnabled) {
      final isNotATieGame = roundWinner != null && roundLoser != null;

      if (isNotATieGame) {
        newInsult = _shuffledAndFormattedInsult(
          insults,
          roundWinner,
          roundLoser,
        );
      } else {
        newInsult = _shuffledTieInsult(tieInsults);
      }

      tts.speak(newInsult);
    }

    final scores = players.map((e) => e.score);

    final gameWinnerOrNull = playersWithResetRoundScores.firstWhereOrNull(
      (player) =>
          player.score >= game.gamePointParams.winningScore &&
          player.score - scores.min >= game.gamePointParams.winByMargin,
    );

    emit(
      state.copyWith(
        game: game.copyWith(
          players: playersWithResetRoundScores,
          round: game.round.copyWith(
            roundWinner: roundWinner,
            roundCount: game.round.roundCount + 1,
          ),
          mostRecentInsult: newInsult,
          gameWinner: gameWinnerOrNull,
        ),
      ),
    );
  }

  String _shuffledAndFormattedInsult(
    List<String> insults,
    Player winningPlayer,
    Player losingPlayer,
  ) {
    if (_emittedInsults.length == insults.length) {
      // this is covered in tests but it's flaky in CI
      _emittedInsults.clear(); // coverage:ignore-line
    }

    final randomInsult = _randomizedInsult(insults, _emittedInsults);

    _emittedInsults.add(randomInsult);
    return randomInsult
        .replaceAll(hiPlayerInsultKey, winningPlayer.playerName)
        .replaceAll(lowPlayerInsultKey, losingPlayer.playerName);
  }

  String _shuffledTieInsult(
    List<String> tieInsults,
  ) {
    if (_emittedTieInsults.length == tieInsults.length) {
      // this is covered in tests but it's flaky in CI
      _emittedTieInsults.clear(); // coverage:ignore-line
    }

    final randomInsult = _randomizedInsult(tieInsults, _emittedTieInsults);

    _emittedTieInsults.add(randomInsult);
    return randomInsult;
  }

  String _randomizedInsult(List<String> insults, List<String?> emittedInsults) {
    String? randomInsult;

    do {
      final randomIndex = Random().nextInt(insults.length);
      randomInsult = insults[randomIndex];
    } while (emittedInsults.contains(randomInsult) ||
        randomInsult == state.game.mostRecentInsult);

    return randomInsult;
  }

  void _toggleInsultVolume(
    ToggleInsultVolumeEvent event,
    Emitter<ScoreboardState> emit,
  ) {
    final bool newAreInsultsEnabled;
    if (state.areInsultsEnabled) {
      newAreInsultsEnabled = false;
    } else {
      newAreInsultsEnabled = true;
    }

    tts.setVolume(newAreInsultsEnabled ? 1 : 0);
    emit(
      state.copyWith(
        areInsultsEnabled: newAreInsultsEnabled,
      ),
    );
  }

  void _resetGame(ResetGameEvent event, Emitter<ScoreboardState> emit) {
    final initialGame = initialScoreboardState.game;
    final keepNamesNewGame = state.game.players
        .map(
          (e) => e.copyWith(
            score: 0,
            roundScore: 0,
          ),
        )
        .toList();

    final newGame = event.shouldKeepNames
        ? initialScoreboardState.game.copyWith(
            players: keepNamesNewGame,
            gamePointParams: state.game.gamePointParams,
          )
        : initialGame.copyWith(
            gamePointParams: state.game.gamePointParams,
          );

    emit(
      state.copyWith(
        isGameInProgress: event.shouldKeepNames,
        game: newGame,
      ),
    );
  }

  void _gameOverEvent(GameOverEvent event, Emitter<ScoreboardState> emit) {
    emit(
      state.copyWith(
        game: state.game.copyWith(gameWinner: null),
      ),
    );
  }

  void _speak(SpeakInsultEvent event, _) {
    final genericInsult = event.insult
        .replaceAll(hiPlayerInsultKey, 'winning player')
        .replaceAll(lowPlayerInsultKey, 'losing player');
    tts.speak(genericInsult);
  }

  @override
  ScoreboardState? fromJson(Map<String, dynamic> json) {
    return ScoreboardState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ScoreboardState state) {
    return state.toJson();
  }
}
