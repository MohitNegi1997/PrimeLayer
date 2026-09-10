import 'package:flutter/material.dart';

abstract final class CategoryIcons {
  static const String category = 'category';
  static const String figurine = 'figurine';
  static const String desk = 'desk';
  static const String keyboard = 'keyboard';
  static const String plant = 'plant';
  static const String game = 'game';
  static const String home = 'home';
  static const String star = 'star';

  static const List<String> keys = [
    category,
    figurine,
    desk,
    keyboard,
    plant,
    game,
    home,
    star,
  ];

  static IconData data(String key) {
    return switch (key) {
      figurine => Icons.smart_toy_outlined,
      desk => Icons.desktop_windows_outlined,
      keyboard => Icons.keyboard_outlined,
      plant => Icons.local_florist_outlined,
      game => Icons.sports_esports_outlined,
      home => Icons.home_outlined,
      star => Icons.star_outline,
      _ => Icons.category_outlined,
    };
  }
}
