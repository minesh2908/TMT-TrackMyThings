import 'package:flutter/material.dart';

const primaryColor = Color(0xFF546FFF);

final lightColorScheme = ColorScheme.fromSeed(
  seedColor: primaryColor,
  primary: const Color(0xFF546FFF),
  onPrimary: const Color(0xFF546FFF),
  surface: const Color(0xFFFCFCFC),
  onSurface: const Color.fromARGB(255, 233, 233, 233),
  secondary: const Color(0xFF23262F),
  tertiary: const Color(0xFF292D32),
  error: Colors.red,
);

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  primary: const Color(0xFF121212),
  onPrimary: const Color(0xFF696969),
  seedColor: primaryColor,
  surface: const Color.fromARGB(255, 227, 229, 240),
  onSurface: const Color(0xFFe9e9e9),
  secondary: const Color(0xFF23262F),
  tertiary: const Color.fromARGB(255, 0, 115, 255),
  error: Colors.red,
);
