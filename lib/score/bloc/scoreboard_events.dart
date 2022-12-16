import 'package:equatable/equatable.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game_point_params.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

abstract class ScoreboardEvent extends Equatable {}

class StartGameEvent extends ScoreboardEvent {
  StartGameEvent({
    required this.player1,
    required this.player2,
    required this.gamePointParams,
  });
  final Player player1;
  final Player player2;
  final GamePointParams gamePointParams;

  StartGameEvent copyWith({
    Player? player1,
    Player? player2,
    GamePointParams? gamePointParams,
  }) {
    return StartGameEvent(
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      gamePointParams: gamePointParams ?? this.gamePointParams,
    );
  }

  @override
  List<Object?> get props => [
        player1,
        player2,
        gamePointParams,
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

class NextTurnEvent extends ScoreboardEvent {
  NextTurnEvent(this.insults);

  final List<String> insults;

  @override
  List<Object?> get props => [insults];
}

class ResetGameEvent extends ScoreboardEvent {
  ResetGameEvent({required this.shouldKeepNames});
  final bool shouldKeepNames;

  @override
  List<Object?> get props => [shouldKeepNames];
}

class ToggleInsultVolumeEvent extends ScoreboardEvent {
  ToggleInsultVolumeEvent();

  @override
  List<Object?> get props => [];
}
