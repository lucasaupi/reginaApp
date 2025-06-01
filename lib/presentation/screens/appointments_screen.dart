import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/presentation/providers/appointment_provider.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentProvider);
    final notifier = ref.read(appointmentProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Turnos'),
        actions: [
          if (appointments.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Borrar todos',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Eliminar todos los turnos'),
                    content: const Text('¿Querés eliminar todos los turnos agendados?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                    ],
                  ),
                );
                if (confirm == true) {
                  await notifier.clear();
                }
              },
            ),
        ],
      ),
      body: appointments.isEmpty
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
  }
}
