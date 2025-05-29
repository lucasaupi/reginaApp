import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:regina_app/presentation/widgets/cart_icon_button.dart';
import 'package:regina_app/presentation/widgets/theme_button.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final bool showCartButton;

  const MainScaffold({
    super.key,
    required this.child,
    this.showCartButton = false,
  });

  static const tabs = ['/', '/products', '/services', '/login'];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = tabs.indexWhere((t) => location == t);
    if (currentIndex == -1) currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Regina App',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 29,
            letterSpacing: 1.1,
            fontStyle: FontStyle.italic,
            color: Colors.black,
            shadows: [
              Shadow(
                offset: Offset(0, 1.5),
                blurRadius: 2,
                color: Colors.black26,
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [ThemeToggleButton(), CartIconButton()],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) => context.go(tabs[index]),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Productos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Turnos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Ingresar',
          ),
        ],
      ),
    );
  }
}
