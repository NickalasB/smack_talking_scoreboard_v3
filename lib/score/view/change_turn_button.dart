import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';

class ChangeTurnButton extends StatelessWidget {
  const ChangeTurnButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return CircularButton(
      onTap: onTap,
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
