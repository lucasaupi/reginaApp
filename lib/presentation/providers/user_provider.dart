import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
final userNameProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(userProvider).value;
  if (user == null) return null;

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  if (doc.exists) {
    return doc.data()?['nombre'] as String?;
  }
  return null;
});
