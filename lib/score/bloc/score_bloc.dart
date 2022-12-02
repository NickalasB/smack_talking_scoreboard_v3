// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'package:collection/collection.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

const hiPlayerInsultKey = r'$HI$';
const lowPlayerInsultKey = r'$LOW$';

class ScoreboardBloc extends HydratedBloc<ScoreboardEvent, ScoreboardState> {
  ScoreboardBloc(this.tts) : super(initialScoreboardState) {
    on<LoadDefaultInsultsEvent>(_loadDefaultInsults);

    on<StartGameEvent>(_startGame);

    on<IncreaseScoreEvent>(_increaseScore);

    on<DecreaseScoreEvent>(_decreaseScore);

    on<SaveInsultEvent>(_saveInsult);

    on<NextTurnEvent>(_changeToNextTurn);

    on<ToggleInsultVolumeEvent>(_toggleInsultVolume);

    on<ResetGameEvent>(_resetGame);

    on<DeleteInsultEvent>(_deleteInsult);
  }
  final Tts tts;

  void _loadDefaultInsults(
    LoadDefaultInsultsEvent event,
    Emitter<ScoreboardState> emit,
  ) {
    final userAddedInsultsOnly = state.insults
        .where((insult) => !event.defaultInsults.contains(insult))
        .toList();

    final userModifiedDefaultInsults = event.defaultInsults
        .where((insult) => state.insults.contains(insult))
        .toList();

    final correctDefaultInsultsToUse = userModifiedDefaultInsults.isNotEmpty
        ? userModifiedDefaultInsults
        : event.defaultInsults;

    return emit(
      state.copyWith(
        insults: [
          ...userAddedInsultsOnly,
          ...correctDefaultInsultsToUse,
        ],
      ),
    );
  }

  void _startGame(StartGameEvent event, Emitter<ScoreboardState> emit) {
    return emit(
      state.copyWith(
        game: state.game.copyWith(
          players: [event.player1, event.player2],
          gamePointParams: event.gamePointParams,
          // ignore:avoid_redundant_argument_values
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

  void _saveInsult(SaveInsultEvent event, Emitter<ScoreboardState> emit) {
    if (event.insult != null && event.insult!.isNotEmpty) {
      final newState =
          state.copyWith(insults: [event.insult!, ...state.insults]);
      emit(newState);
    }
  }

  void _changeToNextTurn(NextTurnEvent event, Emitter<ScoreboardState> emit) {
    final game = state.game;
    final players = game.players;
    final roundHighScore = players.map((e) => e.roundScore).max;
    final winningPlayer =
        players.firstWhere((p) => p.roundScore == roundHighScore);

    final losingPlayer =
        players.firstWhere((element) => element != winningPlayer);

    final playersWithResetRoundScores = <Player>[];
    for (final player in game.players) {
      playersWithResetRoundScores.add(player.copyWith(roundScore: 0));
    }

    final insults = List<String>.from(state.insults);
    if (insults.isNotEmpty) {
      final insultWithPlayerNamesInserted = (insults..shuffle())
          .first
          .replaceAll(hiPlayerInsultKey, winningPlayer.playerName)
          .replaceAll(lowPlayerInsultKey, losingPlayer.playerName);

      tts.speak(insultWithPlayerNamesInserted);
    }

    final scores = players.map((e) => e.score);
    final highScoreSatisfiesWinByMargin =
        scores.max - scores.min >= game.gamePointParams.winByMargin;

    final gameWinnerOrNull = playersWithResetRoundScores.firstWhereOrNull(
      (player) =>
          player.score >= game.gamePointParams.winningScore &&
          highScoreSatisfiesWinByMargin,
    );

    emit(
      state.copyWith(
        game: game.copyWith(
          players: playersWithResetRoundScores,
          round: game.round.copyWith(
            roundWinner: winningPlayer,
            roundCount: game.round.roundCount + 1,
          ),
          gameWinner: gameWinnerOrNull,
        ),
      ),
    );
  }

  void _toggleInsultVolume(
    ToggleInsultVolumeEvent event,
    Emitter<ScoreboardState> emit,
  ) {
    final newAreInsultsEnabled = !state.areInsultsEnabled;
    tts.setVolume(newAreInsultsEnabled ? 1 : 0);
    emit(
      state.copyWith(
        areInsultsEnabled: newAreInsultsEnabled,
      ),
    );
  }

  void _resetGame(ResetGameEvent event, Emitter<ScoreboardState> emit) {
    emit(
      state.copyWith(
        game: initialScoreboardState.game.copyWith(
          gamePointParams: state.game.gamePointParams,
        ),
        insults: state.insults,
      ),
    );
  }

  void _deleteInsult(DeleteInsultEvent event, Emitter<ScoreboardState> emit) {
    final insults = List<String>.from(state.insults)..remove(event.insult);
    emit(
      state.copyWith(insults: insults),
    );
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
