import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';

class VolumeButton extends StatelessWidget {
  const VolumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(nibradshaw): fix this once volume is added
    // final bool isVolumeOn = false;
    // final volumeIcon =
    //     isVolumeOn ? const Icon(Icons.volume_up) : const Icon(Icons.volume_off);
    return CircularButton(
      // TODO(nibradshaw): implement this
      onTap: () {}, // coverage:ignore-line
      child: const Icon(Icons.volume_off),
    );
  }
}
