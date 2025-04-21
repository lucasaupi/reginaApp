import 'package:flutter/material.dart';
import 'package:regina_app/core/router/app_router.dart';
import 'package:regina_app/theme/app_theme.dart';

void main() => runApp(ReginaApp());

class ReginaApp extends StatelessWidget {
  const ReginaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme(selectedColor: 1, isDarkMode: false).getThemeData(),
    );
  }
}
