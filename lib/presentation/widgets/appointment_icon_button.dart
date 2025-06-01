import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/presentation/providers/appointment_provider.dart';
import 'package:go_router/go_router.dart';

class AppointmentIconButton extends ConsumerWidget {
  const AppointmentIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(appointmentProvider).length;

    return Stack(
      alignment: Alignment.topRight,
      children: [
        IconButton(
          icon: const Icon(Icons.event_note),
          onPressed: () => context.push('/appointments'),
        ),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.blue,
              child: Text(
                '$count',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
