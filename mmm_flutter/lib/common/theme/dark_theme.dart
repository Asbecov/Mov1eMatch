import 'package:flutter/material.dart';

const String kFontFamily = 'Montserrat';

final ThemeData theme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF181818),
    surface: Color(0xFF232326),
    onSurface: Color(0xFF181818),
    secondary: Color(0xFF353338),
    onSecondary: Color(0xFF4F4D53),
    error: Color(0xFFFF0000),
    onError: Color(0xFF181818),
  ),
  textTheme: const TextTheme(
    labelMedium: TextStyle(
      fontFamily: kFontFamily,
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: Color(0xFFFFFFFF),
    ),
    titleLarge: TextStyle(
      fontFamily: kFontFamily,
      fontSize: 96,
      color: Color(0xFFFFFFFF),
    ),
    labelSmall: TextStyle(
      fontFamily: kFontFamily,
      fontSize: 24,
      color: Color(0x80FFFFFF),
    ),
  ),
);
