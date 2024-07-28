import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme(
  BuildContext context, {
  required ColorScheme colorScheme,
  required SystemUiOverlayStyle systemUiOverlayStyle,
}) {
  final baseTheme = ThemeData(
    brightness: colorScheme.brightness,
  );
  return ThemeData.from(
    colorScheme: colorScheme,
    useMaterial3: true,
    textTheme: GoogleFonts.ptSansNarrowTextTheme(baseTheme.textTheme),
  ).copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      dialogTheme: DialogTheme(backgroundColor: colorScheme.surface));
}
