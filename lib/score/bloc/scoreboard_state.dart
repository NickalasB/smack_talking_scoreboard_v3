import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game_point_params.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

part 'scoreboard_state.g.dart';

extension ScoreboardContext on BuildContext {
  ScoreboardBloc get readScoreboard => read<ScoreboardBloc>();
  void addScoreboardEvent(ScoreboardEvent event) => readScoreboard.add(event);

  ScoreboardBloc get selectScoreboard =>
      BlocProvider.of<ScoreboardBloc>(this, listen: true);
}

@JsonSerializable()
class ScoreboardState extends Equatable {
  const ScoreboardState(this.game, {this.insults = const []});

  factory ScoreboardState.fromJson(Map<String, dynamic> json) {
    return _$ScoreboardStateFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ScoreboardStateToJson(this);

  ScoreboardState copyWith({
    Game? game,
    List<String>? insults,
  }) {
    return ScoreboardState(
      game ?? this.game,
      insults: insults ?? this.insults,
    );
  }

  final Game game;
  final List<String> insults;

  @override
  List<Object?> get props => [game, insults];
}

ScoreboardState get initialScoreboardState => const ScoreboardState(
      Game(
        players: [
          Player(playerId: 1, playerName: 'Player 1'),
          Player(playerId: 2, playerName: 'Player 2'),
        ],
        gamePointParams: GamePointParams(
          winningScore: 21,
        ),
      ),
    );
