import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton._({
    super.key,
    this.onPressed,
    required this.label,
    required bool isFilled,
    this.minWidth = 64,
  }) : _isFilled = isFilled;

  factory PrimaryButton.filled({
    Key? key,
    VoidCallback? onPressed,
    required String label,
    double minWidth = 64,
  }) {
    return PrimaryButton._(
      key: key,
      onPressed: onPressed,
      label: label,
      isFilled: true,
      minWidth: minWidth,
    );
  }

  factory PrimaryButton.outlined({
    Key? key,
    VoidCallback? onPressed,
    required String label,
    double minWidth = 64,
  }) {
    return PrimaryButton._(
      key: key,
      onPressed: onPressed,
      label: label,
      isFilled: false,
      minWidth: minWidth,
    );
  }

  final VoidCallback? onPressed;
  final String label;
  final bool _isFilled;
  final double minWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filledStyle = ButtonStyle(
      minimumSize:
          MaterialStatePropertyAll(Size(minWidth, kMinInteractiveDimension)),
      backgroundColor: MaterialStatePropertyAll(theme.colorScheme.primary),
      foregroundColor: MaterialStatePropertyAll(theme.colorScheme.surface),
    );

    final outlinedStyle = ButtonStyle(
      minimumSize:
          MaterialStatePropertyAll(Size(minWidth, kMinInteractiveDimension)),
      foregroundColor: MaterialStatePropertyAll(theme.colorScheme.primary),
    );
    final onPressed = this.onPressed;
    final child = Text(label);

    return _isFilled
        ? ElevatedButton(
            style: filledStyle,
            onPressed: onPressed,
            child: child,
          )
        : OutlinedButton(
            style: outlinedStyle,
            onPressed: onPressed,
            child: child,
          );
  }
}
