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
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 124),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(theme.colorScheme.primary),
          foregroundColor: MaterialStatePropertyAll(theme.colorScheme.surface),
          textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 24)),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
