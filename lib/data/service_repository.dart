import 'package:regina_app/domain/service.dart';

final List<Service> serviceRepository = [
  Service(
    id: '1',
    name: 'Limpieza facial',
    price: 3500,
    times: '45 minutos',
    description:
        'Limpieza profunda con productos naturales. Ideal para piel grasa o mixta.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBQnsgvxA0Ogc333pmhJZ7VvTmgAKHT0JRWA&s',
    availableSlots: generateSlots(),
  ),
  Service(
    id: '2',
    name: 'Masaje descontracturante',
    price: 5000,
    times: '1 hora',
    description: 'Masaje terapéutico para aliviar tensiones musculares.',
    imageUrl:
        'https://cdn0.uncomo.com/es/posts/7/9/5/como_es_el_masaje_balines_41597_600.jpg',
    availableSlots: generateSlots(),
  ),
  Service(
    id: '3',
    name: 'Manicura semipermanente',
    price: 3000,
    times: '40 minutos',
    description: 'Esmaltado profesional y cuidado de uñas.',
    imageUrl:
        'https://hips.hearstapps.com/hmg-prod/images/unas-bb-cream-67bdfe72d0d58.jpg?resize=980:*',
    availableSlots: generateSlots(),
  ),
];

List<DateTime> generateSlots({
  int days = 7,
  int startHour = 10,
  int endHour = 18,
  Duration interval = const Duration(hours: 1),
}) {
  final now = DateTime.now();
  final List<DateTime> slots = [];

  for (int d = 0; d < days; d++) {
    final date = now.add(Duration(days: d));

    // Solo de lunes a viernes
    if (date.weekday >= 6) continue;

    for (int h = startHour; h < endHour; h += interval.inHours) {
      slots.add(DateTime(date.year, date.month, date.day, h));
    }
  }

  return slots;
}
