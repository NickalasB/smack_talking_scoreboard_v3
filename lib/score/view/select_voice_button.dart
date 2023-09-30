import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';

class SelectVoicesButton extends StatelessWidget {
  const SelectVoicesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return context.readApp.state.availableVoices.isEmpty
        ? const SizedBox.shrink(key: Key('empty_voices_shrink_box'))
        : IconButton(
            key: const Key('select_voice_button'),
            onPressed: () async {
              await showSelectVoiceDialog(context);
            },
            icon: SvgPicture.asset(
              'assets/voice_selection.svg',
              width: 36,
              height: 36,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurfaceVariant,
                BlendMode.srcIn,
              ),
            ),
          );
  }

  Future<void> showSelectVoiceDialog(BuildContext context) async {
    return showModalBottomSheet<void>(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          key: const Key('select_voices_bottom_sheet'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: context.readApp.state.availableVoices
                .where((element) => element.locale.contains('en'))
                .map(
              (v) {
                return ListTile(
                  title: Text(
                    v.name,
                  ),
                  onTap: () {
                    context.readApp.add(SetVoiceEvent(v));
                  },
                );
              },
            ).toList(),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
