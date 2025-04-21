import 'package:flutter/material.dart';
import 'package:regina_app/data/service_repository.dart';
import 'package:regina_app/domain/service.dart';

class ServiceDetailScreen extends StatelessWidget {
  ServiceDetailScreen({super.key, required this.serviceId});

  final String serviceId;
  final List<Service> services = serviceRepository;

  @override
  Widget build(BuildContext context) {
    final service = services.firstWhere((s) => s.id == serviceId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del servicio')),
      body: _ServiceDetailView(service: service),
    );
  }
}

class _ServiceDetailView extends StatelessWidget {
  const _ServiceDetailView({super.key, required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (service.imageUrl != null)
            Image.network(service.imageUrl!, height: 400),
          const SizedBox(height: 16),
          Text(service.name, style: textStyle.titleLarge),
          Text(service.description, style: textStyle.bodyLarge),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // futura navegación a pantalla de reserva
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrir pantalla de reservas')),
              );
            },
            child: const Text('Reservar turno'),
          ),
        ],
      ),
    );
  }
}
