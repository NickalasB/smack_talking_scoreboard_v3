import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    super.key,
    required this.onTap,
    required this.icon,
    this.color = Colors.grey,
  });

  final Color color;
  final Icon icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: const [BoxShadow(blurRadius: 8)],
        ),
        child: icon,
      ),
      iconSize: 64,
      color: Colors.white,
      splashColor: Colors.greenAccent,
      onPressed: onTap,
    );
  }
}
