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

class ScoreboardBloc extends HydratedBloc<ScoreboardEvent, ScoreboardState> {
  ScoreboardBloc() : super(initialScoreboardState) {
    on<IncreaseScoreEvent>(_increaseScore);

    on<DecreaseScoreEvent>(_decreaseScore);

    on<SaveInsultEvent>(_saveInsult);
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
              currentPlayer.copyWith(score: currentScore + 1),
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
              currentPlayer.copyWith(score: currentScore - 1),
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

  // TODO(me): figure out why this fails in tests but works in production
  // coverage:ignore-start
  @override
  ScoreboardState? fromJson(Map<String, dynamic> json) {
    return ScoreboardState.fromJson(json);
  }
  // coverage:ignore-end

  @override
  Map<String, dynamic>? toJson(ScoreboardState state) {
    return state.toJson();
  }
}
