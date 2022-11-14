import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

part 'game.g.dart';

@JsonSerializable()
class Game extends Equatable {
  const Game({
    this.players = const [],
    this.round = const Round(),
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  Map<String, dynamic> toJson() => _$GameToJson(this);

  Game copyWith({
    List<Player>? players,
    Round? round,
  }) {
    return Game(
      players: players ?? this.players,
      round: round ?? this.round,
    );
  }

  final List<Player> players;
  final Round round;

  @override
  List<Object?> get props => [players, round];

  @override
  bool? get stringify => true;
}

class Round extends Equatable {
  const Round({
    this.roundCount = 1,
    this.roundWinner,
  });

  final int roundCount;
  final Player? roundWinner;

  Round copyWith({
    int? roundCount,
    Player? roundWinner,
  }) {
    return Round(
      roundCount: roundCount ?? this.roundCount,
      roundWinner: roundWinner ?? this.roundWinner,
    );
  }

  @override
  List<Object?> get props => [roundCount, roundWinner];
}
