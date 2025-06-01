import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String userId;
  final String serviceName;
  final DateTime date;

  Appointment({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.date,
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      userId: data['userId'],
      serviceName: data['serviceName'],
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'serviceName': serviceName,
      'date': Timestamp.fromDate(date),
    };
  }

  Appointment copyWith({
    String? id,
    String? userId,
    String? serviceName,
    DateTime? date,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceName: serviceName ?? this.serviceName,
      date: date ?? this.date,
    );
  }

}
