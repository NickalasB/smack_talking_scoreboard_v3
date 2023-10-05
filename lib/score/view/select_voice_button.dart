import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_bloc.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';

class SelectVoicesButton extends StatelessWidget {
  const SelectVoicesButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = context.readApp;
    final availableVoices = appBloc.state.availableVoices;
    return availableVoices.isEmpty
        ? const SizedBox.shrink(key: Key('empty_voices_shrink_box'))
        : IconButton(
            key: const Key('select_voice_button'),
            onPressed: () async {
              await showSelectVoiceDialog(context, appBloc);
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

  Future<void> showSelectVoiceDialog(
    BuildContext context,
    AppBloc appBloc,
  ) async {
    return showModalBottomSheet<void>(
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final availableVoices = appBloc.state.availableVoices;
        return SingleChildScrollView(
          key: const Key('select_voices_bottom_sheet'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: availableVoices.map(
              (v) {
                return ListTile(
                  title: Text(
                    context.l10n.voiceNumber(availableVoices.indexOf(v)),
                  ),
                  selected: v == appBloc.state.selectedVoice,
                  onTap: () {
                    appBloc.add(
                      SetVoiceEvent(
                        v,
                        sampleInsult: context.l10n.satVoiceInsult,
                      ),
                    );
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
