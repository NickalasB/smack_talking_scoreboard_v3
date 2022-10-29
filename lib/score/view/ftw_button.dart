import 'package:flutter/material.dart';
import 'package:smack_talking_scoreboard_v3/l10n/l10n.dart';

class FtwButton extends StatelessWidget {
  const FtwButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10 = context.l10n;
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.yellow[500],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: TextField(
          showCursor: true,
          maxLength: 3,
          buildCounter: (
            context, {
            required currentLength,
            maxLength,
            required isFocused,
          }) {
            return const SizedBox.shrink();
          },
          onChanged: (text) {
            // TODO(nibradshaw): add an event to the bloc here
          },
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          controller: TextEditingController(),
          decoration: InputDecoration.collapsed(hintText: l10.forTheWin),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
