import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/game_point_params.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/round.dart';

part 'game.g.dart';

@JsonSerializable()
class Game extends Equatable {
  const Game({
    this.players = const [],
    this.round = const Round(),
    required this.gamePointParams,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  Game copyWith({
    List<Player>? players,
    Round? round,
    GamePointParams? gamePointParams,
  }) {
    return Game(
      players: players ?? this.players,
      round: round ?? this.round,
      gamePointParams: gamePointParams ?? this.gamePointParams,
    );
  }

  final List<Player> players;
  final Round round;
  final GamePointParams gamePointParams;

  @override
  List<Object?> get props => [players, round, gamePointParams];
}
