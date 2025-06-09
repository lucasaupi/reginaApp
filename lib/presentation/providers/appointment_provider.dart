import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regina_app/domain/appointment.dart';
import 'package:regina_app/presentation/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final appointmentFinishedProvider = StateProvider<Appointment?>((ref) => null);

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  AppointmentNotifier(this.ref) : super([]) {
    ref.listen<AsyncValue<User?>>(userProvider, (previous, next) async {
      final user = next.value;
      if (user == null) {
        state = [];
      } else {
        await _loadAppointments(user.uid);
      }
    }, fireImmediately: true);
  }

  final Ref ref;

  Future<void> _loadAppointments(String userId) async {
    final now = DateTime.now();
    final snapshot =
        await FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 'active')
            .orderBy('date', descending: false)
            .get();

    final newState = <Appointment>[];

    for (final doc in snapshot.docs) {
      final appt = Appointment.fromFirestore(doc);

      if (appt.date.isBefore(now)) {
        await FirebaseFirestore.instance
            .collection('appointments')
            .doc(appt.id)
            .update({'status': 'completed'});

        ref.read(appointmentFinishedProvider.notifier).state =
            appt.copyWith(status: 'completed');
      } else {
        newState.add(appt);
      }
    }
    state = newState;
  }

  Future<void> add(Appointment appointment) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .where('serviceName', isEqualTo: appointment.serviceName)
        .where('date', isEqualTo: Timestamp.fromDate(appointment.date))
        .where('status', isEqualTo: 'active')
        .get();

    final docRef = await FirebaseFirestore.instance
        .collection('appointments')
        .add({
          ...appointment.toMap(),
          'createdAt': Timestamp.now(),
          'deletedAt': null,
        });

    final addedAppointment = appointment.copyWith(
      id: docRef.id,
      status: 'active',
      createdAt: DateTime.now(),
      deletedAt: null,
    );

    state = [...state, addedAppointment];
  }

  Future<void> cancel(String id) async {
    await FirebaseFirestore.instance.collection('appointments').doc(id).update({
      'status': 'cancelled',
      'deletedAt': Timestamp.now(),
    });

    state = state.where((appt) => appt.id != id).toList();
  }
  int get total => state.length;
}

final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, List<Appointment>>((ref) {
      return AppointmentNotifier(ref);
    });
