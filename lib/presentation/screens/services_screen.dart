import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:regina_app/data/service_repository.dart';
import 'package:regina_app/domain/service.dart';

class ServicesScreen extends StatelessWidget {
  ServicesScreen({super.key});

  final List<Service> services = serviceRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: _ServiceListView(services: services),
    );
  }
}

class _ServiceListView extends StatelessWidget {
  const _ServiceListView({super.key, required this.services});

  final List<Service> services;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _ServiceItemView(
          service: services[index],
        );
      },
    );
  }
}

class _ServiceItemView extends StatelessWidget {
  const _ServiceItemView({super.key, required this.service});

  final Service service;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/service_detail/${service.id}'),
      child: Card(
        child: ListTile(
          trailing: const Icon(Icons.chevron_right),
          leading: service.imageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    service.imageUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              : const SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(Icons.calendar_today),
                ),
          title: Text(service.name),
          subtitle: Text(service.description),
        ),
      ),
    );
  }
}
