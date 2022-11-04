import 'package:flutter/material.dart';

class VolumeButton extends StatelessWidget {
  const VolumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(nibradshaw): fix this once volume is added
    // final bool isVolumeOn = false;
    // final volumeIcon =
    //     isVolumeOn ? const Icon(Icons.volume_up) : const Icon(Icons.volume_off);
    return IconButton(
      icon: const DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: Icon(Icons.volume_off),
      ),
      iconSize: 64,
      color: Colors.white,
      splashColor: Colors.greenAccent,
      // TODO(nibradshaw): implement me
      onPressed: () {}, // coverage:ignore-line
    );
  }
}
