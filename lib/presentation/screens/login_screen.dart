import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _login(BuildContext context, String username, String password) {
    // ++++ logica del login ++++  //

    const String validUsername = 'lucas@ort.com';
    const String validPassword = 'lucas1234';
    if (username == validUsername && password == validPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('¡Bienvenido!')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/regina_app_logo.png',
              width: 350,
              height: 350,
            ),
            const SizedBox(height: 32),
            const TextField(
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _login(context, 'lucas@ort.com', 'lucas1234'),
              child: const Text("Iniciar sesión"),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Página Principal")),
      body: const Center(child: Text("Bienvenido a Regina App")),
    );
  }
}
