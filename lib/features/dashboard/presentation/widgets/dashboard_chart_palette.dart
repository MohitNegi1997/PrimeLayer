import 'package:flutter/material.dart';

abstract final class DashboardChartPalette {
  static List<Color> status(ColorScheme scheme) {
    return [
      scheme.primary,
      scheme.secondary,
      scheme.tertiary,
      scheme.primary.withValues(alpha: 0.45),
      scheme.error,
    ];
  }

  static Color queued(ColorScheme scheme) => scheme.tertiary;

  static Color printing(ColorScheme scheme) => scheme.secondary;

  static Color failed(ColorScheme scheme) => scheme.error;
}
