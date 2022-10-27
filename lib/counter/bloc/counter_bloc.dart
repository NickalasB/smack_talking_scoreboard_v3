// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterState(0)) {
    on<IncreaseScoreEvent>((event, emit) {
      return emit(CounterState(state.score + 1));
    });

    on<DecreaseScoreEvent>((event, emit) {
      if (state.score >= 1) {
        return emit(CounterState(state.score - 1));
      }
    });
  }
}

class CounterState extends Equatable {
  const CounterState(this.score);
  final int score;

  @override
  List<Object?> get props => [score];
}

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
