import 'package:equatable/equatable.dart';

class ScoreboardState extends Equatable {
  const ScoreboardState(this.score);
  final int score;

  @override
  List<Object?> get props => [score];
}
