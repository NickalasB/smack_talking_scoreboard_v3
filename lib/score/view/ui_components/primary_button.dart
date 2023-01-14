import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton._({
    super.key,
    this.onPressed,
    required this.label,
    required bool isFilled,
    this.minWidth = 120,
  }) : _isFilled = isFilled;

  factory PrimaryButton.filled({
    Key? key,
    VoidCallback? onPressed,
    required String label,
    double minWidth = 120,
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
    double minWidth = 120,
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
    final filledStyle = ElevatedButton.styleFrom(
      minimumSize: Size(minWidth, kMinInteractiveDimension),
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.surface,
    );

    final outlinedStyle = OutlinedButton.styleFrom(
      minimumSize: Size(minWidth, kMinInteractiveDimension),
      foregroundColor: theme.colorScheme.primary,
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
