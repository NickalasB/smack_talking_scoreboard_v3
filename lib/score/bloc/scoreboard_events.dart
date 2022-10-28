import 'package:equatable/equatable.dart';

class CounterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class IncreaseScoreEvent extends CounterEvent {
  IncreaseScoreEvent();
}

class DecreaseScoreEvent extends CounterEvent {
  DecreaseScoreEvent();
}
