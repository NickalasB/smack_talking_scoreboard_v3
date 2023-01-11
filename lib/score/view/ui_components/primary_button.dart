import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    this.onPressed,
    required this.label,
    this.isFilled = true,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isFilled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize:
            const MaterialStatePropertyAll(Size(124, kMinInteractiveDimension)),
        backgroundColor: MaterialStatePropertyAll(theme.colorScheme.primary),
        foregroundColor: MaterialStatePropertyAll(theme.colorScheme.surface),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
