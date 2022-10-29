import 'package:flutter/material.dart';

class VolumeButton extends StatelessWidget {
  const VolumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(nibradshaw): get this off of state;
    final bool isVolumeOn = false;
    return IconButton(
      icon: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
        child: isVolumeOn ? Icon(Icons.volume_up) : Icon(Icons.volume_off),
      ),
      iconSize: 64,
      color: Colors.white,
      splashColor: Colors.greenAccent,
      onPressed: () {},
    );
  }
}
