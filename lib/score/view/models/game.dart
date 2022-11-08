import 'package:equatable/equatable.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

class Game extends Equatable {
  const Game({
    this.players = const [],
  });

  final List<Player> players;

  Game copyWith({
    List<Player>? players,
  }) {
    return Game(
      players: players ?? this.players,
    );
  }

  @override
  List<Object?> get props => [players];
}
