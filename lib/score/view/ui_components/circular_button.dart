import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key,
    required this.onTap,
    required this.child,
    this.color = Colors.grey,
  });

  final Color color;
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              blurStyle: BlurStyle.outer,
              color: color,
            ),
          ],
        ),
        child: child,
      ),
      iconSize: 64,
      color: Colors.white,
      onPressed: onTap,
    );
  }
}
