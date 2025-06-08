import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String userId;
  final String serviceName;
  final DateTime date;
  final String status; // "active", "cancelled"
  final DateTime createdAt;
  final DateTime? deletedAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.serviceName,
    required this.date,
    this.status = 'active',
    required this.createdAt,
    this.deletedAt,
  });

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      id: doc.id,
      userId: data['userId'],
      serviceName: data['serviceName'],
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deletedAt:
          data['deletedAt'] != null
              ? (data['deletedAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'serviceName': serviceName,
      'date': Timestamp.fromDate(date),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'deletedAt': deletedAt != null ? Timestamp.fromDate(deletedAt!) : null,
    };
  }

  Appointment copyWith({
    String? id,
    String? userId,
    String? serviceName,
    DateTime? date,
    String? status,
    DateTime? createdAt,
    DateTime? deletedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceName: serviceName ?? this.serviceName,
      date: date ?? this.date,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
