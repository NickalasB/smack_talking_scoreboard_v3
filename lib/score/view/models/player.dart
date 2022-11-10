import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player extends Equatable {
  const Player({
    required this.playerId,
    this.score = 0,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  Player copyWith({
    int? playerId,
    int? score,
  }) {
    return Player(
      playerId: playerId ?? this.playerId,
      score: score ?? this.score,
    );
  }

  final int playerId;
  final int score;

  @override
  List<Object?> get props => [playerId, score];
}
