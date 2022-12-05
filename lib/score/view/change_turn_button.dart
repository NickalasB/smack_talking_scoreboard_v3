import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/score/view/ui_components/circular_button.dart';

class ChangeTurnButton extends StatelessWidget {
  const ChangeTurnButton({
    super.key,
    required this.onTap,
  });

  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return CircularButton(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: onTap != null ? Colors.green : Theme.of(context).disabledColor,
          shape: BoxShape.circle,
        ),
        child: const Center(
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
