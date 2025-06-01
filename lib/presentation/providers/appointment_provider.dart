import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regina_app/domain/appointment.dart';
import 'package:regina_app/presentation/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentNotifier extends StateNotifier<List<Appointment>> {
  AppointmentNotifier(this.ref) : super([]) {
    // Escuchar cambios en el usuario y cargar turnos
    ref.listen<AsyncValue<User?>>(userProvider, (previous, next) async {
      final user = next.value;
      if (user == null) {
        // Si se cerró sesión, limpiar los turnos
        state = [];
      } else {
        await _loadAppointments(user.uid);
      }
    }, fireImmediately: true);
  }

  final Ref ref;

  Future<void> _loadAppointments(String userId) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: userId)
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
