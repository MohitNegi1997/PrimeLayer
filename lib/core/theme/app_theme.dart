import 'package:flutter/material.dart';
import 'package:primelayer_admin_panel/core/theme/app_colors.dart';
import 'package:primelayer_admin_panel/core/theme/app_fonts.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
        brightness: Brightness.light,
        colorScheme: AppColors.lightScheme,
        textTheme: AppFonts.textTheme(),
        scaffoldBackground: AppColors.backgroundLight,
        appBarBackground: AppColors.primary,
        appBarForeground: AppColors.onPrimary,
        cardColor: AppColors.surfaceLight,
        cardBorder: AppColors.outline,
        buttonBackground: AppColors.primary,
        buttonForeground: AppColors.onPrimary,
        inputFill: AppColors.surfaceLight,
        iconColor: AppColors.secondary,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        colorScheme: AppColors.darkScheme,
        textTheme: AppFonts.textTheme(ThemeData.dark().textTheme),
        scaffoldBackground: AppColors.backgroundDark,
        appBarBackground: AppColors.backgroundDark,
        appBarForeground: AppColors.onDark,
        cardColor: AppColors.surfaceDark,
        cardBorder: AppColors.secondary,
        buttonBackground: AppColors.primaryDark,
        buttonForeground: AppColors.backgroundDark,
        inputFill: AppColors.surfaceDark,
        iconColor: AppColors.accent,
      );

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required Color scaffoldBackground,
    required Color appBarBackground,
    required Color appBarForeground,
    required Color cardColor,
    required Color cardBorder,
    required Color buttonBackground,
    required Color buttonForeground,
    required Color inputFill,
    required Color iconColor,
  }) {
    final themedText = textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: AppFonts.family,
      textTheme: themedText,
      scaffoldBackgroundColor: scaffoldBackground,
      iconTheme: IconThemeData(color: iconColor),
      dividerColor: cardBorder,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: themedText.titleMedium?.copyWith(
          color: appBarForeground,
        ),
        iconTheme: IconThemeData(color: appBarForeground),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: cardBorder),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackground,
          foregroundColor: buttonForeground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.secondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
