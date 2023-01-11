import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/models/player.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

class GameWinnerDialog extends StatefulWidget {
  const GameWinnerDialog(
    this.winningPlayer, {
    this.shouldPlayAtLaunch = true,
  }) : super(key: const Key('game_winner_dialog'));

  final Player winningPlayer;
  // need this for Golden tests
  @visibleForTesting
  final bool shouldPlayAtLaunch;

  @override
  State<GameWinnerDialog> createState() => _GameWinnerDialogState();
}

class _GameWinnerDialogState extends State<GameWinnerDialog> {
  final confettiController =
      ConfettiController(duration: const Duration(milliseconds: 1500));

  @override
  void initState() {
    super.initState();
    if (widget.shouldPlayAtLaunch) {
      confettiController.play();
    }
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    final losingPlayer = context.selectScoreboard.state.game.players
        .firstWhere((element) => element != widget.winningPlayer);

    return WillPopScope(
      onWillPop: () async => false,
      child: ConfettiWidget(
        confettiController: confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        numberOfParticles: 100,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          title: Column(
            children: [
              Text(
                strings.playerWins(widget.winningPlayer.playerName),
                textAlign: TextAlign.center,
                style: textTheme.titleLarge?.copyWith(fontSize: 32),
              ),
              const Divider(thickness: 2),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              strings.winnerDialogBody(losingPlayer.playerName),
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            PrimaryButton(
              key: const Key('game_winner_yes_button'),
              onPressed: () {
                context
                    .addScoreboardEvent(ResetGameEvent(shouldKeepNames: true));
                Navigator.of(context).pop();
              },
              label: strings.yes,
            ),
            PrimaryButton(
              key: const Key('game_winner_no_button'),
              onPressed: () {
                context.addScoreboardEvent(
                  ResetGameEvent(shouldKeepNames: false),
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              label: strings.no,
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: const EdgeInsets.only(bottom: 16),
        ),
      ),
    );
  }
}
