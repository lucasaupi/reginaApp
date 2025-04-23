import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:regina_app/data/service_repository.dart';
import 'package:regina_app/domain/service.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  late final Service service;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime? _selectedSlot;

  @override
  void initState() {
    super.initState();
    service = serviceRepository.firstWhere((s) => s.id == widget.serviceId);
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  List<DateTime> _slotsForSelectedDay() {
    if (_selectedDay == null || service.availableSlots == null) return [];
    return service.availableSlots!
        .where((slot) => isSameDay(slot, _selectedDay))
        .toList();
  }

  void _confirmarReserva() {
    if (_selectedSlot == null) return;

    final hora = DateFormat('HH:mm').format(_selectedSlot!);
    final fecha = DateFormat('EEEE d MMMM', 'es').format(_selectedSlot!);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Reserva confirmada'),
            content: Text('Turno reservado para el $fecha a las $hora.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Aceptar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final slotsDelDia = _slotsForSelectedDay();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del servicio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (service.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(service.imageUrl!, height: 180),
              ),
            const SizedBox(height: 12),
            Text(service.name, style: textTheme.titleLarge),
            Text(service.description, style: textTheme.bodyMedium),
            const SizedBox(height: 20),

            // CALENDARIO
            TableCalendar(
              locale: 'es',
              focusedDay: _focusedDay,
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 30)),
              calendarFormat: CalendarFormat.week,
              selectedDayPredicate:
                  (day) => _selectedDay != null && isSameDay(day, _selectedDay),
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDay = selected;
                  _focusedDay = focused;
                  _selectedSlot = null;
                });
              },
              headerVisible: true,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Horarios disponibles:',
                style: textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),

            if (slotsDelDia.isEmpty)
              const Text('No hay turnos disponibles para este día.')
            else
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: slotsDelDia.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final slot = slotsDelDia[index];
                    final hora = DateFormat('HH:mm').format(slot);
                    return ChoiceChip(
                      label: Text(hora),
                      selected: _selectedSlot == slot,
                      onSelected: (_) {
                        setState(() {
                          _selectedSlot = slot;
                        });
                      },
                    );
                  },
                ),
              ),

            const Spacer(),
            ElevatedButton.icon(
              onPressed: _selectedSlot != null ? _confirmarReserva : null,
              icon: const Icon(Icons.check),
              label: const Text('Confirmar turno'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
