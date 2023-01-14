import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme({
    required bool isInDarkMode,
  }) : _isInDarkMode = isInDarkMode;

  final bool _isInDarkMode;
}

ThemeData appLightTheme(BuildContext context) => Theme.of(context).copyWith(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        color: Color(0xFF13B9FF),
      ),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: const Color(0xFF13B9FF),
      ),
    );

ThemeData appDarkTheme(BuildContext context) => Theme.of(context).copyWith(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        color: Colors.red,
      ),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: const Color(0xFF13B9FF),
      ),
    );
