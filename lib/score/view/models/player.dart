import 'package:equatable/equatable.dart';

class Player extends Equatable {
  const Player({
    required this.playerId,
    this.score = 0,
  });

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
