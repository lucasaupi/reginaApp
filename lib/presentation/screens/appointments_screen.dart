import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:regina_app/presentation/providers/appointment_provider.dart';
import 'package:regina_app/presentation/providers/user_provider.dart';
import 'package:go_router/go_router.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final finishedAppt = ref.watch(appointmentFinishedProvider);

    if (finishedAppt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Turno finalizado'),
                content: Text(
                  'Tu turno para ${finishedAppt.serviceName} del ${DateFormat('dd/MM/yyyy').format(finishedAppt.date)} a las ${DateFormat('HH:mm').format(finishedAppt.date)} ha finalizado.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      try {
                        ref.read(appointmentFinishedProvider.notifier).state = null;
                      } catch (_) {}
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              ),
        );
      });
    }

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
                        subtitle: Text(
                          '${DateFormat('EEEE d', 'es').format(appt.date)} de ${DateFormat('MMMM', 'es').format(appt.date)} a las ${DateFormat('HH:mm').format(appt.date)}',
                        ),
                        trailing: TextButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Cancelar turno'),
                                    content: const Text(
                                      '¿Estás seguro de que querés cancelar este turno?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(
                                              context,
                                            ).pop(false),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () =>
                                                Navigator.of(context).pop(true),
                                        child: const Text('Sí, cancelar'),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm == true) {
                              await notifier.cancel(appt.id);
                            }
                          },
                          child: const Text('Cancelar'),
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
