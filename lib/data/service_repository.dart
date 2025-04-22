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
    availableSlots: [
      DateTime(2024, 4, 26, 13, 0),
      DateTime(2024, 4, 26, 14, 0),
      DateTime(2024, 4, 27, 12, 0),
    ],
  ),
  Service(
    id: '2',
    name: 'Masaje descontracturante',
    price: 5000,
    times: '1 hora',
    description: 'Masaje terapéutico para aliviar tensiones musculares.',
    imageUrl:
        'https://cdn0.uncomo.com/es/posts/7/9/5/como_es_el_masaje_balines_41597_600.jpg',
    availableSlots: [
      DateTime(2024, 4, 25, 10),
      DateTime(2024, 4, 25, 14),
      DateTime(2024, 4, 26, 11),
    ],
  ),
  Service(
    id: '3',
    name: 'Manicura semipermanente',
    price: 3000,
    times: '40 minutos',
    description: 'Esmaltado profesional y cuidado de uñas.',
    imageUrl:
        'https://hips.hearstapps.com/hmg-prod/images/unas-bb-cream-67bdfe72d0d58.jpg?resize=980:*',
    availableSlots: [
      DateTime(2024, 4, 26, 9),
      DateTime(2024, 4, 27, 15),
    ],
  ),
];
