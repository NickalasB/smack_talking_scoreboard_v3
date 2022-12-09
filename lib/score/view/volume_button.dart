import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';

class VolumeButton extends StatelessWidget {
  const VolumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isVolumeOn = context.selectScoreboard.state.areInsultsEnabled;
    final volumeIcon =
        isVolumeOn ? const Icon(Icons.volume_up) : const Icon(Icons.volume_off);
    return CircularButton(
      key: const Key('volume_button'),
      onTap: () {
        context.addScoreboardEvent(ToggleInsultVolumeEvent());
      },
      child: volumeIcon,
    );
  }
}
