import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData appTheme({
  Brightness brightness = Brightness.light,
}) {
  final appColorScheme = colorScheme(brightness);
  return ThemeData(
    colorScheme: appColorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      elevation: 4,
      color: appColorScheme.surfaceVariant,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: appColorScheme.surfaceTint,
      ),
    ),
  );
}

ColorScheme colorScheme(Brightness brightness) => ColorScheme.fromSeed(
      seedColor: brightness == Brightness.dark
          ? const Color(0xff6692b2)
          : const Color(0xff00497e),
      brightness: brightness,
    );
