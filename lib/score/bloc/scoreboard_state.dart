import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';

extension ScoreboardContext on BuildContext {
  ScoreBloc get readScoreboard => read<ScoreBloc>();
  void addScoreboardEvent(ScoreboardEvent event) => readScoreboard.add(event);
}

class ScoreboardState extends Equatable {
  const ScoreboardState(this.score);
  final int score;

  @override
  List<Object?> get props => [score];
}
