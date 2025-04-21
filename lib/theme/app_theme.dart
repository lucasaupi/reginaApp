import 'package:flutter/material.dart';

final colors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.purple,
  Colors.pink,
  Colors.cyan,
  Colors.indigo
];

class AppTheme {
  int selectedColor;
  bool isDarkMode;

  AppTheme({required this.selectedColor, required this.isDarkMode});

  ThemeData getThemeData() {
    return ThemeData(
      colorSchemeSeed: colors[selectedColor],
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );
  }
}
