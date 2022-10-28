// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.
import 'package:bloc/bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';

class ScoreBloc extends Bloc<CounterEvent, ScoreboardState> {
  ScoreBloc() : super(const ScoreboardState(0)) {
    on<IncreaseScoreEvent>((event, emit) {
      return emit(ScoreboardState(state.score + 1));
    });

    on<DecreaseScoreEvent>((event, emit) {
      if (state.score >= 1) {
        return emit(ScoreboardState(state.score - 1));
      }
    });
  }
}
