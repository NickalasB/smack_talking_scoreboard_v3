// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/view/exit_game_dialog.dart';

//ignore:one_member_abstracts
abstract class ScoreboardPageDependenciesData {
  Future<bool?> launchExitGameDialog(
    BuildContext context, {
    required ScoreboardBloc scoreboardBloc,
  });
}

class ScoreboardPageDependencies extends InheritedWidget {
  const ScoreboardPageDependencies({
    super.key,
    required this.data,
    required super.child,
  });

  final ScoreboardPageDependenciesData data;

  static ScoreboardPageDependencies? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ScoreboardPageDependencies>();
  }

  @override
  bool updateShouldNotify(covariant ScoreboardPageDependencies oldWidget) {
    return data != oldWidget.data;
  }
}

mixin NavigationMixin implements ScoreboardPageDependenciesData {
  @override
  Future<bool?> launchExitGameDialog(
    BuildContext context, {
    required ScoreboardBloc scoreboardBloc,
  }) async {
    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider.value(
          value: scoreboardBloc,
          child: const ExitGameDialog(),
        );
      },
    );
  }
}
