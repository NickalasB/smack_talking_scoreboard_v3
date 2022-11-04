import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';

class FtwButton extends StatelessWidget {
  const FtwButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircularIconButton(
      key: const Key('settings_button'),
      onTap: () {
        showModalBottomSheet<String?>(
          context: context,
          useRootNavigator: true,
          builder: (context) => SizedBox(
            height: 260,
            child: Column(
              children: const [
                BottomSheetHeader(
                  key: Key('settings_bottom_sheet'),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
      },
      icon: const Icon(Icons.settings),
    );
  }
}

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
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
