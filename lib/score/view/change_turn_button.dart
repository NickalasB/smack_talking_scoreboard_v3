import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/score.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';

class ChangeTurnButton extends StatefulWidget {
  const ChangeTurnButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback? onTap;

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
    return CircularButton(
      onTap: () {
        context.readScoreboard.add(
          NextTurnEvent(context.readApp.state.insults),
        );

        _checkIfGameHasWinner();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.onTap != null
              ? Colors.green
              : Theme.of(context).disabledColor,
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            r'#$%!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
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
