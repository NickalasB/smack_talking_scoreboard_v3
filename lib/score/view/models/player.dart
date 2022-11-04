import 'package:equatable/equatable.dart';

class Player extends Equatable {
  const Player({
    required this.playerId,
    this.score = 0,
  });

  final int playerId;
  final int score;

  @override
  List<Object?> get props => [playerId, score];
}
