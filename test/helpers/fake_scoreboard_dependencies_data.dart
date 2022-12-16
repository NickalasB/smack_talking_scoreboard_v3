import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/scoreboard_page_dependencies.dart';

mixin FakeScoreboardDependenciesData implements NavigationMixin {
  final exitGameCompleters = <Completer<bool>>[];
  final launchGameWinnerDialogCompleters = <Completer<Player>>[];

  @override
  Future<Player> launchGameWinnerDialog(
    BuildContext context,
    Player winningPlayer, {
    required ScoreboardBloc scoreboardBloc,
  }) async {
    final completer = Completer<Player>();

    launchGameWinnerDialogCompleters.add(completer);

    return completer.future;
  }

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
