import 'package:equatable/equatable.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

class Game extends Equatable {
  const Game({this.players = const {}});

  final Map<int, Player> players;

  Game copyWith({
    Map<int, Player>? players,
  }) {
    return Game(
      players: players ?? this.players,
    );
  }

  @override
  List<Object?> get props => [players];
}
