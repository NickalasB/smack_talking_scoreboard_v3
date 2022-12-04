import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

class GameWinnerDialog extends StatefulWidget {
  const GameWinnerDialog(this.winningPlayer)
      : super(key: const Key('game_winner_dialog'));

  final Player winningPlayer;

  @override
  State<GameWinnerDialog> createState() => _GameWinnerDialogState();
}

class _GameWinnerDialogState extends State<GameWinnerDialog> {
  final confettiController =
      ConfettiController(duration: const Duration(milliseconds: 1500));

  @override
  void initState() {
    super.initState();
    confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    final losingPlayer = context.selectScoreboard.state.game.players
        .firstWhere((element) => element != widget.winningPlayer);

    return ConfettiWidget(
      confettiController: confettiController,
      blastDirectionality: BlastDirectionality.explosive,
      numberOfParticles: 100,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          children: [
            Text(
              '${widget.winningPlayer.playerName} WINS!!',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(fontSize: 32),
            ),
            const Divider(thickness: 2),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Wanna go again, but actually try this time, ${losingPlayer.playerName}?',
            style: textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          PrimaryButton(
            onPressed: () {
              context.addScoreboardEvent(ResetGameEvent());
              Navigator.of(context).pop();
            },
            label: strings.yes,
          ),
          PrimaryButton(
            onPressed: () {
              context.addScoreboardEvent(ResetGameEvent());
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            label: strings.no,
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: const EdgeInsets.only(bottom: 16),
      ),
    );
  }
}
