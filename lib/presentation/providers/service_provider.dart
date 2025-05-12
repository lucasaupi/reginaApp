import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regina_app/domain/service.dart';

final serviceProvider = StateNotifierProvider<ServicesNotifier, List<Service>>(
  (ref) => ServicesNotifier(FirebaseFirestore.instance),
);

class ServicesNotifier extends StateNotifier<List<Service>> {
  final FirebaseFirestore db;

  ServicesNotifier(this.db) : super([]);

  Future<void> getAllServices() async {
    final query = db
        .collection('services')
        .withConverter<Service>(
          fromFirestore: Service.fromFirestore,
          toFirestore: (service, _) => service.toFirestore(),
        )
        .where('status', isEqualTo: 'active');

    final snapshot = await query.get();
    state = snapshot.docs.map((d) => d.data()).toList();
  }
}
