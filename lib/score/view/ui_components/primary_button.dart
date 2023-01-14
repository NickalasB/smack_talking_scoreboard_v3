import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton._({
    super.key,
    this.onPressed,
    this.label,
    this.child,
    required bool isFilled,
    this.minWidth = 120,
  })  : assert(
          label != null || child != null,
          'Button must have a label or a child!',
        ),
        _isFilled = isFilled;

  factory PrimaryButton.filled({
    Key? key,
    VoidCallback? onPressed,
    Widget? child,
    String? label,
    double minWidth = 120,
  }) {
    return PrimaryButton._(
      key: key,
      onPressed: onPressed,
      label: label,
      isFilled: true,
      minWidth: minWidth,
      child: child,
    );
  }

  factory PrimaryButton.outlined({
    Key? key,
    VoidCallback? onPressed,
    Widget? child,
    String? label,
    double minWidth = 120,
  }) {
    return PrimaryButton._(
      key: key,
      onPressed: onPressed,
      label: label,
      isFilled: false,
      minWidth: minWidth,
      child: child,
    );
  }

  final VoidCallback? onPressed;
  final String? label;
  final Widget? child;
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
    final buttonChild = label != null ? Text(label!) : child!;

    return _isFilled
        ? ElevatedButton(
            style: filledStyle,
            onPressed: onPressed,
            child: buttonChild,
          )
        : OutlinedButton(
            style: outlinedStyle,
            onPressed: onPressed,
            child: buttonChild,
          );
  }
}
