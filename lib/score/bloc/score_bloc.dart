// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';

import '../view/models/player.dart';

class ScoreboardBloc extends Bloc<ScoreboardEvent, ScoreboardState> {
  ScoreboardBloc() : super(initialScoreboardState) {
    on<IncreaseScoreEvent>(_increaseScore);

    on<DecreaseScoreEvent>((event, emit) {
      final players = List<Player>.from(state.game.players);

      final currentPlayer =
          players.singleWhereOrNull((p) => p.playerId == event.playerId);

      final otherPlayers = players..remove(currentPlayer);

      if (currentPlayer != null && currentPlayer.score >= 1) {
        final currentScore = currentPlayer.score;
        return emit(
          ScoreboardState(
            state.game.copyWith(
              players: [
                ...otherPlayers,
                currentPlayer.copyWith(score: currentScore - 1),
              ],
            ),
          ),
        );
      }
    });
  }

  void _increaseScore(IncreaseScoreEvent event, Emitter<ScoreboardState> emit) {
    final players = List<Player>.from(state.game.players);

    final currentPlayer =
        players.singleWhereOrNull((p) => p.playerId == event.playerId);

    final otherPlayers = players..remove(currentPlayer);

    if (currentPlayer != null) {
      final currentScore = currentPlayer.score;
      return emit(
        ScoreboardState(
          state.game.copyWith(
            players: [
              currentPlayer.copyWith(score: currentScore + 1),
              ...otherPlayers,
            ],
          ),
        ),
      );
    }
  }
}
