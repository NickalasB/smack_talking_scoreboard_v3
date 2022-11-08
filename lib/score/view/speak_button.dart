import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';

class SpeakButton extends StatelessWidget {
  const SpeakButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularButton(
      // TODO(nibradshaw): implement this
      onTap: () {}, // coverage:ignore-line
      child: const DecoratedBox(
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
    );
  }
}
