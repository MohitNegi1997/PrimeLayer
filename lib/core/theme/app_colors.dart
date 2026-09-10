import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF1E3A5F);
  static const Color secondary = Color(0xFF527A9E);
  static const Color accent = Color(0xFFB0CAD9);
  static const Color outline = Color(0xFFC8DBE9);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color backgroundLight = Color(0xFFF4F7FB);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEDF1FA);

  static const Color backgroundDark = Color(0xFF132843);
  static const Color surfaceDark = Color(0xFF1E3A5F);
  static const Color primaryDark = Color(0xFFB0CAD9);
  static const Color secondaryDark = Color(0xFF7BA3C4);
  static const Color onDark = Color(0xFFEDF1FA);

  static const Color warningSoft = Color(0xFFF3E6C4);
  static const Color successSoft = Color(0xFFD5E8DC);
  static const Color dangerSoft = Color(0xFFF0D6D8);
  static const Color infoSoft = Color(0xFFD5E3F0);
  static const Color warningSoftDark = Color(0xFF3F3A28);
  static const Color successSoftDark = Color(0xFF274038);
  static const Color dangerSoftDark = Color(0xFF3F2C32);
  static const Color infoSoftDark = Color(0xFF2A3C52);

  static const ColorScheme lightScheme = ColorScheme.light(
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: onSecondary,
    tertiary: accent,
    surface: surfaceLight,
    onSurface: primary,
    outline: outline,
  );

  static const ColorScheme darkScheme = ColorScheme.dark(
    primary: primaryDark,
    onPrimary: backgroundDark,
    secondary: secondaryDark,
    onSecondary: backgroundDark,
    tertiary: accent,
    surface: surfaceDark,
    onSurface: onDark,
    outline: secondary,
  );
}
