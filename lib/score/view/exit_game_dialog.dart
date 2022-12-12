import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/app/view/app.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

class ExitGameDialog extends StatelessWidget {
  const ExitGameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      title: Column(
        children: [
          Text(
            strings.exitGame,
            textAlign: TextAlign.center,
            style: textTheme.titleLarge?.copyWith(fontSize: 32),
          ),
          const Divider(thickness: 2),
        ],
      ),
      actions: [
        PrimaryButton(
          key: const Key('exit_game_yes_button'),
          onPressed: () {
            context.addScoreboardEvent(ResetGameEvent(shouldKeepNames: false));
            Navigator.of(context).popAndPushNamed(homeRouteName, result: true);
          },
          label: strings.yes,
        ),
        PrimaryButton(
          key: const Key('exit_game_no_button'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          label: strings.no,
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.only(bottom: 16),
    );
  }
}
