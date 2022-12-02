import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

class ResetGameDialog extends StatelessWidget {
  const ResetGameDialog() : super(key: const Key('reset_score_dialog'));

  @override
  Widget build(BuildContext context) {
    final strings = context.l10n;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      title: Center(
        child: Text(
          strings.resetGame,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 32),
        ),
      ),
      content: const SizedBox(height: 24),
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
            Navigator.of(context).pop();
          },
          label: strings.no,
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actionsPadding: const EdgeInsets.only(bottom: 16),
    );
  }
}
