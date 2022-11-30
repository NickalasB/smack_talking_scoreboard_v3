import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_point_params.g.dart';

@JsonSerializable()
class GamePointParams extends Equatable {
  const GamePointParams({
    required this.winningScore,
    this.pointsPerScore = 1,
    this.winByMargin = 1,
  });

  factory GamePointParams.fromJson(Map<String, dynamic> json) =>
      _$GamePointParamsFromJson(json);

  Map<String, dynamic> toJson() => _$GamePointParamsToJson(this);

  GamePointParams copyWith({
    int? winningScore,
    int? pointsPerScore,
    int? winByMargin,
  }) {
    return GamePointParams(
      winningScore: winningScore ?? this.winningScore,
      pointsPerScore: pointsPerScore ?? this.pointsPerScore,
      winByMargin: winByMargin ?? this.winByMargin,
    );
  }

  final int winningScore;
  final int pointsPerScore;
  final int winByMargin;

  @override
  List<Object?> get props => [
        winningScore,
        pointsPerScore,
        winByMargin,
      ];
}
