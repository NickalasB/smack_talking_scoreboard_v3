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
    on<StartGameEvent>(_startGame);

    on<IncreaseScoreEvent>(_increaseScore);

    on<DecreaseScoreEvent>(_decreaseScore);

    on<SaveInsultEvent>(_saveInsult);

    on<NextTurnEvent>(_changeToNextTurn);

    on<ResetGameEvent>(_resetGame);

    on<DeleteInsultEvent>(_deleteInsult);
  }
  final Tts tts;

  void _startGame(StartGameEvent event, Emitter<ScoreboardState> emit) {
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
        game: state.game.copyWith(players: [event.player1, event.player2]),
        insults: [
          ...userAddedInsultsOnly,
          ...correctDefaultInsultsToUse,
        ],
      ),
    );
  }

  void _increaseScore(IncreaseScoreEvent event, Emitter<ScoreboardState> emit) {
    final players = List<Player>.from(state.game.players);

    final currentPlayer =
        players.singleWhereOrNull((p) => p.playerId == event.playerId);

    final otherPlayers = players..remove(currentPlayer);

    if (currentPlayer != null) {
      final currentScore = currentPlayer.score;
      return emit(
        state.copyWith(
          game: state.game.copyWith(
            players: [
              currentPlayer.copyWith(
                score: currentScore + 1,
                roundScore: currentPlayer.roundScore + 1,
              ),
              ...otherPlayers,
            ],
          ),
        ),
      );
    }
  }

  void _decreaseScore(DecreaseScoreEvent event, Emitter<ScoreboardState> emit) {
    final players = List<Player>.from(state.game.players);

    final currentPlayer =
        players.singleWhereOrNull((p) => p.playerId == event.playerId);

    final otherPlayers = players..remove(currentPlayer);

    if (currentPlayer != null && currentPlayer.score >= 1) {
      final currentScore = currentPlayer.score;
      return emit(
        state.copyWith(
          game: state.game.copyWith(
            players: [
              ...otherPlayers,
              currentPlayer.copyWith(
                score: currentScore - 1,
                roundScore: currentPlayer.roundScore - 1,
              ),
            ],
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

    emit(
      state.copyWith(
        game: game.copyWith(
          players: playersWithResetRoundScores,
          round: game.round.copyWith(
            roundWinner: winningPlayer,
            roundCount: game.round.roundCount + 1,
          ),
        ),
      ),
    );
  }

  void _resetGame(ResetGameEvent event, Emitter<ScoreboardState> emit) {
    emit(
      state.copyWith(
        game: initialScoreboardState.game,
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
