import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/primary_button.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularButton(
      key: const Key('settings_button'),
      onTap: () async {
        final scoreboardBloc = context.readScoreboard;
        final addedInsult = await showModalBottomSheet<String?>(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: 340,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  BottomSheetHeader(
                    key: Key('settings_bottom_sheet'),
                  ),
                  Flexible(child: BottomSheetContent()),
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );

        scoreboardBloc.add(SaveInsultEvent(addedInsult));
      },
      child: const Icon(Icons.settings),
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            l10n.addYourOwnSmackTalk,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28),
          ),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10 = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            key: const Key('insult_text_field'),
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            style: theme.textTheme.titleLarge,
          ),
          const Spacer(),
          PrimaryButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            label: l10.done,
          ),
        ],
      ),
    );
  }
}
