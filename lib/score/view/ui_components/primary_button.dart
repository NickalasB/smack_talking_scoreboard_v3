import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isFilled = true,
  });

  final VoidCallback onPressed;
  final String label;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      height: kMinInteractiveDimension,
      onPressed: onPressed,
      color: isFilled ? theme.primaryColor : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: theme.primaryColor),
      ),
      child: Text(
        label,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.canvasColor,
        ),
      ),
    );
  }
}
