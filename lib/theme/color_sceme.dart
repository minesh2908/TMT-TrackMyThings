import 'package:flutter/material.dart';

const primaryColor = Color(0xFF546FFF);

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: primaryColor,
  primary: const Color(0xFF546FFF),
  surface: const Color(0xFFFCFCFC),
  onSurface: const Color(0xFFe9e9e9),
  secondary: const Color(0xFF23262F),
  tertiary: const Color(0xFF292D32),
);

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  primary: const Color(0xFF546FFF),
  seedColor: primaryColor,
  surface: const Color(0xFFFCFCFC),
    onSurface: const Color(0xFFe9e9e9),
  secondary: const Color(0xFF23262F),
  tertiary: const Color(0xFF292D32),
);
