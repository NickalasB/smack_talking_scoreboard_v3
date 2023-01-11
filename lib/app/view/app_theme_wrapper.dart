import 'package:flutter/material.dart';

class AppThemeWrapper extends StatelessWidget {
  const AppThemeWrapper({super.key, required this.builder});
  final Widget Function({
    required ThemeData lightTheme,
    required ThemeData darkTheme,
  }) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      lightTheme: Theme.of(context).copyWith(
        errorColor: Colors.blue,
      ),
      darkTheme: Theme.of(context).copyWith(
        errorColor: Colors.yellow,
      ),
    );
  }
}
