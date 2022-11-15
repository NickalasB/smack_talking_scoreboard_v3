import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player extends Equatable {
  const Player({
    required this.playerId,
    this.score = 0,
    this.roundScore = 0,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  Player copyWith({
    int? playerId,
    int? score,
    int? roundScore,
  }) {
    return Player(
      playerId: playerId ?? this.playerId,
      score: score ?? this.score,
      roundScore: roundScore ?? this.roundScore,
    );
  }

  final int playerId;
  final int score;
  final int roundScore;

  @override
  List<Object?> get props => [
        playerId,
        score,
        roundScore,
      ];
}
