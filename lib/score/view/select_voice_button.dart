import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_events.dart';
import 'package:smack_talking_scoreboard_v3/app/bloc/app_state.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/bottom_sheet_header.dart';
import 'package:smack_talking_scoreboard_v3/text_to_speech/tts.dart';

class SelectVoicesButton extends StatelessWidget {
  const SelectVoicesButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final availableVoices = context.watchApp.state.availableVoices;
    return availableVoices.isEmpty
        ? const SizedBox.shrink(key: Key('empty_voices_shrink_box'))
        : IconButton(
            key: const Key('select_voice_button'),
            onPressed: () async {
              await showSelectVoiceDialog(context, availableVoices);
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
}

Future<void> showSelectVoiceDialog(
  BuildContext context,
  List<Voice> availableVoices,
) async {
  final scrollController = ScrollController();

  final selectedVoice = context.readApp.state.selectedVoice;
  if (selectedVoice != null) {
    const tileHeight = 56; // height info is from ListTile documentation
    final offset = tileHeight * availableVoices.indexOf(selectedVoice);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(
        offset.toDouble(),
        duration: kThemeAnimationDuration,
        curve: Curves.easeIn,
      );
    });
  }

  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => _DialogContent(availableVoices, scrollController),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
  );
}

class _DialogContent extends StatelessWidget {
  const _DialogContent(this.availableVoices, this.scrollController);

  final List<Voice> availableVoices;

  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      key: const Key('select_voices_bottom_sheet'),
      heightFactor: .75,
      child: Column(
        children: [
          BottomSheetHeader(
            title: context.l10n.pickVoice,
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: ListView.separated(
                shrinkWrap: true,
                controller: scrollController,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(
                      context.l10n.voiceNumber(index + 1),
                    ),
                    selected: availableVoices[index] ==
                        context.watchApp.state.selectedVoice,
                    selectedTileColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onTap: () {
                      context.readApp.add(
                        SetVoiceEvent(
                          availableVoices[index],
                          sampleInsult: context.l10n.satVoiceInsult,
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (_, index) {
                  return const Divider(
                    thickness: 2,
                    height: 2,
                  );
                },
                itemCount: availableVoices.length,
              ),
            ),
          ),
        ],
      ),
      // child: SelectVoiceDialogContent(availableVoices),
    );
  }
}
