import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game.dart';

extension ScoreboardContext on BuildContext {
  ScoreboardBloc get readScoreboard => read<ScoreboardBloc>();
  void addScoreboardEvent(ScoreboardEvent event) => readScoreboard.add(event);
}

class ScoreboardState extends Equatable {
  const ScoreboardState(this.game);
  final Game game;

  @override
  List<Object?> get props => [game];
}
