import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/score.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

class ChangeTurnButton extends StatefulWidget {
  const ChangeTurnButton({
    super.key,
    this.isLandscape = false,
  });
  final bool isLandscape;

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
    final theme = Theme.of(context);
    final next = context.l10n.next;

    final horizontalNext = Column(
      mainAxisSize: MainAxisSize.min,
      children: next.characters
          .map(
            (s) => Text(
              s,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.canvasColor,
              ),
            ),
          )
          .toList(),
    );

    final isGameOver = context.isGameOver;
    return PrimaryButton.filled(
      key: const Key('change_turn_button'),
      onPressed: isGameOver
          ? null
          : () {
              context.readScoreboard.add(
                NextTurnEvent(context.readApp.state.insults),
              );

              _checkIfGameHasWinner();
            },
      label: widget.isLandscape ? null : next,
      textStyle: Theme.of(context).textTheme.headlineSmall,
      child: widget.isLandscape ? horizontalNext : null,
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
