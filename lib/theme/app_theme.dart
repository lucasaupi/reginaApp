import 'package:flutter/material.dart';

final colors = [
  const Color(0xFFFF3B30),
  const Color(0xFF007AFF), 
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.purple,
  Colors.pink,
  Colors.cyan,
  Colors.indigo,
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

  ThemeData getDarkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: Colors.grey[850],
      colorScheme: base.colorScheme.copyWith(
        primary: Colors.blueGrey[300],
        secondary: Colors.blueGrey[200],
        background: Colors.grey[850],
        surface: Colors.grey[800],
        onSurface: Colors.white70,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white70,
      ),
    );
  }
}
