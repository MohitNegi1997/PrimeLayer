import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppFonts {
  static String? get family => GoogleFonts.jost().fontFamily;

  static TextTheme textTheme([TextTheme? base]) {
    final themed = GoogleFonts.jostTextTheme(base);
    return themed.copyWith(
      headlineLarge: themed.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: 0.4,
      ),
      headlineMedium: themed.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
      ),
      headlineSmall: themed.headlineSmall?.copyWith(
        fontWeight: FontWeight.w800,
      ),
      titleLarge: themed.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      titleMedium: themed.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: themed.titleSmall?.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: 2.4,
      ),
      labelLarge: themed.labelLarge?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2,
      ),
      labelMedium: themed.labelMedium?.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: 1.6,
      ),
      labelSmall: themed.labelSmall?.copyWith(
        fontWeight: FontWeight.w400,
        letterSpacing: 1.8,
      ),
    );
  }
}
