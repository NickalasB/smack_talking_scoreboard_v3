import 'package:equatable/equatable.dart';

abstract class ScoreboardEvent extends Equatable {}

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

class SaveInsultEvent extends ScoreboardEvent {
  SaveInsultEvent(this.insult);
  final String? insult;

  @override
  List<Object?> get props => [insult];
}

class NextTurnEvent extends ScoreboardEvent {
  NextTurnEvent();

  @override
  List<Object?> get props => [];
}
