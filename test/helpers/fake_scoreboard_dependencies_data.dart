import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page_dependencies.dart';

mixin FakeScoreboardDependenciesData implements ScoreboardPageDependenciesData {
  final exitGameCompleters = <Completer<bool>>[];

  @override
  Future<bool?> launchExitGameDialog(
    BuildContext context, {
    required ScoreboardBloc scoreboardBloc,
  }) async {
    final completer = Completer<bool>();

    exitGameCompleters.add(completer);

    return completer.future;
  }
}
