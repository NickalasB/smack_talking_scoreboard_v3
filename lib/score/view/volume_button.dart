import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VolumeButton extends StatelessWidget {
  const VolumeButton({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(nibradshaw): get this off of state;
    final bool isVolumeOn = false;
    return IconButton(
      icon: DecoratedBox(
        child: isVolumeOn ? Icon(Icons.volume_up) : Icon(Icons.volume_off),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
      iconSize: 64,
      color: Colors.white,
      splashColor: Colors.greenAccent,
      onPressed: () {},
    );
  }
}
