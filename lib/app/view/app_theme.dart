import 'package:flutter/material.dart';

ThemeData appTheme({
  Brightness brightness = Brightness.light,
}) =>
    ThemeData(
      colorScheme:
          brightness == Brightness.light ? _lightColorScheme : _darkColorScheme,
      useMaterial3: true,
    );

final _lightColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xff00497e),
);
final _darkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xff6692b2),
  brightness: Brightness.dark,
);
