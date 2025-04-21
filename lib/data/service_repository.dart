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
      'Lunes 10:00',
      'Lunes 15:00',
      'Miércoles 11:00',
      'Viernes 14:00',
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
    availableSlots: ['Martes 09:00', 'Jueves 13:00', 'Viernes 16:00'],
  ),
  Service(
    id: '3',
    name: 'Manicura semipermanente',
    price: 3000,
    times: '40 minutos',
    description: 'Esmaltado profesional y cuidado de uñas.',
    imageUrl:
        'https://hips.hearstapps.com/hmg-prod/images/unas-bb-cream-67bdfe72d0d58.jpg?resize=980:*',
    availableSlots: ['Lunes 17:00', 'Miércoles 09:00', 'Sábado 10:00'],
  ),
];
