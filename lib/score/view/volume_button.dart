import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_events.dart';
import 'package:smack_talking_scoreboard_v3/score/bloc/scoreboard_state.dart';

class VolumeButton extends StatelessWidget {
  const VolumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('volume_button'),
      onPressed: () {
        context.addScoreboardEvent(ToggleInsultVolumeEvent());
      },
      isSelected: context.selectScoreboard.state.areInsultsEnabled,
      selectedIcon: const Icon(
        Icons.volume_up_outlined,
      ),
      icon: const Icon(
        Icons.volume_off_outlined,
      ),
    );
  }
}
