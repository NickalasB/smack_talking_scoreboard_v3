import 'package:equatable/equatable.dart';

class ScoreboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class IncreaseScoreEvent extends ScoreboardEvent {
  IncreaseScoreEvent({required this.playerId});
  final int playerId;

  @override
  List<Object?> get props => [playerId];
}

class DecreaseScoreEvent extends ScoreboardEvent {
  DecreaseScoreEvent({required this.playerId});
  final int playerId;

  @override
  List<Object?> get props => [playerId];
}
