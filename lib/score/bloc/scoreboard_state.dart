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

  bool get isGameOver => selectScoreboard.state.game.gameWinner != null;
}

@JsonSerializable()
class ScoreboardState extends Equatable {
  const ScoreboardState(
    this.game, {
    this.areInsultsEnabled = true,
    this.isGameInProgress = false,
  });

  factory ScoreboardState.fromJson(Map<String, dynamic> json) {
    return _$ScoreboardStateFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ScoreboardStateToJson(this);

  ScoreboardState copyWith({
    Game? game,
    bool? areInsultsEnabled,
    bool? isGameInProgress,
  }) {
    return ScoreboardState(
      game ?? this.game,
      areInsultsEnabled: areInsultsEnabled ?? this.areInsultsEnabled,
      isGameInProgress: isGameInProgress ?? this.isGameInProgress,
    );
  }

  final Game game;
  final bool areInsultsEnabled;
  final bool isGameInProgress;

  @override
  List<Object?> get props => [game, areInsultsEnabled, isGameInProgress];
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
