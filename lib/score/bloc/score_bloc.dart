// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'package:bloc/bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

class ScoreboardBloc extends Bloc<ScoreboardEvent, ScoreboardState> {
  ScoreboardBloc()
      : super(
          const ScoreboardState(
            Game(
              players: {
                1: Player(playerId: 1),
                2: Player(playerId: 2),
              },
            ),
          ),
        ) {
    on<IncreaseScoreEvent>(_increaseScore);

    on<DecreaseScoreEvent>((event, emit) {
      final players = state.game.players;
      final player = players[event.playerId];
      if (player != null && player.score >= 1) {
        final otherPlayers = players
          ..entries.where((element) => element.key != event.playerId);

        final currentScore = player.score;
        return emit(
          ScoreboardState(
            state.game.copyWith(
              players: {
                ...otherPlayers,
                event.playerId:
                    Player(playerId: event.playerId, score: currentScore - 1)
              },
            ),
          ),
        );
      }
    });
  }

  void _increaseScore(IncreaseScoreEvent event, Emitter<ScoreboardState> emit) {
    final players = state.game.players;
    final player = players[event.playerId];

    final otherPlayers = players
      ..entries.where((element) => element.key != event.playerId);

    if (player != null) {
      final currentScore = player.score;
      return emit(
        ScoreboardState(
          state.game.copyWith(
            players: {
              ...otherPlayers,
              event.playerId:
                  Player(playerId: event.playerId, score: currentScore + 1)
            },
          ),
        ),
      );
    }
  }
}
