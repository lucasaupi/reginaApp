import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/presentation/providers/appointment_provider.dart';
import 'package:regina_app/presentation/providers/user_provider.dart';
import 'package:go_router/go_router.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Mis Turnos')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Debes iniciar sesión para ver tus turnos.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/login'),
                    child: const Text('Iniciar sesión'),
                  ),
                ],
              ),
            ),
          );
        }

        final appointments = ref.watch(appointmentProvider);
        final notifier = ref.read(appointmentProvider.notifier);

        return Scaffold(
          appBar: AppBar(title: const Text('Mis Turnos')),
          body:
              appointments.isEmpty
                  ? const Center(child: Text('No hay turnos agendados.'))
                  : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appt = appointments[index];
                      return ListTile(
                        title: Text(appt.serviceName),
                        subtitle: Text('${appt.date}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => notifier.remove(appt.id),
                        ),
                      );
                    },
                  ),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
