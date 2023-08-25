import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/score.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

class ChangeTurnButton extends StatefulWidget {
  const ChangeTurnButton({super.key});

  @override
  State<ChangeTurnButton> createState() => _ChangeTurnButtonState();
}

class _ChangeTurnButtonState extends State<ChangeTurnButton> {
  @override
  void initState() {
    super.initState();
    _checkIfGameHasWinner();
  }

  @override
  Widget build(BuildContext context) {
    final next = context.l10n.next;

    final isGameOver = context.isGameOver;
    return PrimaryButton.filled(
      key: const Key('change_turn_button'),
      onPressed: isGameOver
          ? null
          : () {
              context.readScoreboard.add(
                NextTurnEvent(
                  context.readApp.state.insults,
                  tieInsults: context.readApp.state.tieInsults,
                ),
              );

              _checkIfGameHasWinner();
            },
      label: next,
      textStyle: Theme.of(context).textTheme.headlineSmall,
    );
  }

  void _checkIfGameHasWinner() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final scoreboardBloc = context.readScoreboard;

      final gameWinner = scoreboardBloc.state.game.gameWinner;
      if (gameWinner != null) {
        ScoreboardPageDependencies.of(context)?.data.launchGameWinnerDialog(
              context,
              gameWinner,
              scoreboardBloc: scoreboardBloc,
            );
      }
    });
  }
}
