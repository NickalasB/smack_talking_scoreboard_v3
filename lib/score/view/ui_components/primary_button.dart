import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isFilled = true,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialButton(
      height: kMinInteractiveDimension,
      onPressed: onPressed,
      disabledColor: theme.disabledColor,
      color: isFilled ? theme.primaryColor : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: onPressed != null ? theme.primaryColor : theme.disabledColor,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.titleLarge?.copyWith(
          color: isFilled ? theme.canvasColor : theme.primaryColor,
        ),
      ),
    );
  }
}
