import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/presentation/providers/theme_provider.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.brightness_6),
      onPressed: () {
        final current = ref.read(themeModeProvider.notifier).state;
        ref.read(themeModeProvider.notifier).state =
            current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      },
    );
  }
}
