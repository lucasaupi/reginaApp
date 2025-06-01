import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regina_app/domain/appointment.dart';
import 'package:regina_app/presentation/providers/user_provider.dart';

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  AppointmentNotifier(this.ref) : super([]) {
    _loadAppointments();
  }

  final Ref ref;

  Future<void> _loadAppointments() async {
    final user = ref.read(userProvider).value;
    if (user == null) return;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: user.uid)
            .orderBy('date')
            .get();

    state = snapshot.docs.map((doc) => Appointment.fromFirestore(doc)).toList();
  }

  Future<void> add(Appointment appointment) async {
    final docRef = await FirebaseFirestore.instance
        .collection('appointments')
        .add(appointment.toMap());

    final addedAppointment = appointment.copyWith(id: docRef.id);
    state = [...state, addedAppointment];
  }

  Future<void> remove(String id) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(id)
        .delete();
    state = state.where((appt) => appt.id != id).toList();
  }

  Future<void> clear() async {
    for (var appt in state) {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appt.id)
          .delete();
    }
    state = [];
  }

  int get total => state.length;
}

final appointmentProvider =
    StateNotifierProvider<AppointmentNotifier, List<Appointment>>((ref) {
      return AppointmentNotifier(ref);
    });
