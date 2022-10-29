import 'package:equatable/equatable.dart';

class ScoreboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class IncreaseScoreEvent extends ScoreboardEvent {
  IncreaseScoreEvent();
}

class DecreaseScoreEvent extends ScoreboardEvent {
  DecreaseScoreEvent();
}
