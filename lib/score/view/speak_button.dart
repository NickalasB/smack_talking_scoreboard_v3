import 'package:flutter/material.dart';

class SpeakButton extends StatelessWidget {
  const SpeakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 64,
      icon: const DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            r'#$%!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
      color: Colors.green,
      splashColor: Colors.greenAccent,
      // TODO(nibradshaw): implement this
      onPressed: () {}, // coverage:ignore-line
    );
  }
}
