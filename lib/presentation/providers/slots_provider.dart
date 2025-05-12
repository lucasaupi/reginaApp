import 'package:flutter_riverpod/flutter_riverpod.dart';

final slotsProvider = FutureProvider.family<List<DateTime>, String>((ref, serviceId) async {
  // Simula un pequeño retraso como si fuera de red
  await Future.delayed(const Duration(milliseconds: 300));

  final now = DateTime.now();
  final List<DateTime> slots = [];

  // Generamos turnos genéricos para los próximos 7 días
  for (int i = 0; i < 7; i++) {
    final day = now.add(Duration(days: i));
    for (int hour = 9; hour <= 17; hour += 2) {
      slots.add(DateTime(day.year, day.month, day.day, hour));
    }
  }

  return slots;
});
