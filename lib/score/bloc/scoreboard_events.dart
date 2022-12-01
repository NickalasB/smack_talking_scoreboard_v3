import 'package:equatable/equatable.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

abstract class ScoreboardEvent extends Equatable {}

class LoadDefaultInsultsEvent extends ScoreboardEvent {
  LoadDefaultInsultsEvent({
    required this.defaultInsults,
  });

  final List<String> defaultInsults;

  @override
  List<Object?> get props => [defaultInsults];
}

class StartGameEvent extends ScoreboardEvent {
  StartGameEvent({
    required this.player1,
    required this.player2,
  });
  final Player player1;
  final Player player2;

  StartGameEvent copyWith({
    Player? player1,
    Player? player2,
  }) {
    return StartGameEvent(
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
    );
  }

  @override
  List<Object?> get props => [
        player1,
        player2,
      ];
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

class ResetGameEvent extends ScoreboardEvent {
  ResetGameEvent();

  @override
  List<Object?> get props => [];
}

class DeleteInsultEvent extends ScoreboardEvent {
  DeleteInsultEvent(this.insult);

  final String insult;
  @override
  List<Object?> get props => [insult];
}
