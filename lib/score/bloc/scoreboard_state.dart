import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

part 'scoreboard_state.g.dart';

extension ScoreboardContext on BuildContext {
  ScoreboardBloc get readScoreboard => read<ScoreboardBloc>();
  void addScoreboardEvent(ScoreboardEvent event) => readScoreboard.add(event);
}

@JsonSerializable()
class ScoreboardState extends Equatable {
  const ScoreboardState(this.game);

  factory ScoreboardState.fromJson(Map<String, dynamic> json) =>
      _$ScoreboardStateFromJson(json);

  Map<String, dynamic> toJson() => _$ScoreboardStateToJson(this);

  final Game game;

  @override
  List<Object?> get props => [game];
}

ScoreboardState get initialScoreboardState => const ScoreboardState(
      Game(
        players: [
          Player(playerId: 1),
          Player(playerId: 2),
        ],
      ),
    );
