import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/score_bloc.dart';
import 'package:smack_talking_scoreboard_v3/score/view/exit_game_dialog.dart';
import 'package:smack_talking_scoreboard_v3/score/view/game_winner_dialog.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';

abstract class ScoreboardPageDependenciesData {
  Future<bool?> launchExitGameDialog(
    BuildContext context, {
    required ScoreboardBloc scoreboardBloc,
  });

  Future<void> launchGameWinnerDialog(
    BuildContext context,
    Player winningPlayer, {
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
  ///
  /// These two functions ARE covered in tests inside scoreboard_page_dependencies_test.dart
  /// but code-coverage won't pick it up for some reason
  /// This issue is closed but it seems related https://github.com/flutter/flutter/issues/31856
  ///

  // coverage:ignore-start
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
  // coverage:ignore-end

  // coverage:ignore-start
  @override
  Future<void> launchGameWinnerDialog(
    BuildContext context,
    Player winningPlayer, {
    required ScoreboardBloc scoreboardBloc,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocProvider.value(
          value: scoreboardBloc,
          child: GameWinnerDialog(winningPlayer),
        );
      },
    );
  }
// coverage:ignore-end
}
