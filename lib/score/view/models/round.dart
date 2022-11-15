import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

part 'round.g.dart';

@JsonSerializable()
class Round extends Equatable {
  const Round({
    this.roundCount = 1,
    this.roundWinner,
  });

  factory Round.fromJson(Map<String, dynamic> json) => _$RoundFromJson(json);

  Map<String, dynamic> toJson() => _$RoundToJson(this);

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
