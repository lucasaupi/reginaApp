import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/presentation/providers/auth_controller_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    final currentContext = context;

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ScaffoldMessenger.of(currentContext).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden.')),
      );
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
        );

    final state = ref.read(authControllerProvider);

    if (!currentContext.mounted) return;

    if (!state.hasError) {
      ScaffoldMessenger.of(
        currentContext,
      ).showSnackBar(const SnackBar(content: Text('Registro exitoso')));
      Navigator.pop(currentContext);
    } else {
      final errorMsg = state.error?.toString();

      String finalMessage = 'Error desconocido';

      if (errorMsg != null && errorMsg.contains('correo ya está registrado')) {
        finalMessage = 'El correo ingresado ya está registrado';
      } else if (errorMsg != null) {
        finalMessage = errorMsg;
      }

      ScaffoldMessenger.of(
        currentContext,
      ).showSnackBar(SnackBar(content: Text(finalMessage)));
    }
  }

  String? validateName(String? value, String label) {
    final nameRegExp = RegExp(r"^[a-zA-ZÁÉÍÓÚáéíóúñÑ\s]{1,30}$");

    if (value == null || value.trim().isEmpty) {
      return 'Ingrese su $label';
    } else if (!nameRegExp.hasMatch(value.trim())) {
      return '$label inválido. Solo letras y máximo 30 caracteres.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => validateName(val, 'Nombre'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => validateName(val, 'Apellido'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Ingrese su correo' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) =>
                        val != null && val.length < 6
                            ? 'Mínimo 6 caracteres'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (val) =>
                        val != _passwordController.text
                            ? 'Las contraseñas no coinciden'
                            : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : _register,
                  child:
                      authState.isLoading
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.indigo,
                            ),
                          )
                          : const Text('Registrarse'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
