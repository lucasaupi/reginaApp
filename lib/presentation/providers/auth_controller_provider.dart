import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<void> {
  final _auth = FirebaseAuth.instance;

  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> register(
    String email,
    String password,
    String nombre,
    String apellido,
  ) async {
    state = const AsyncLoading();
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'nombre': nombre,
          'apellido': apellido,
          'role': 'client',
          'status': 'active',
          'deletedAt': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        state = AsyncError('El correo ya está registrado', StackTrace.current);
      } else {
        state = AsyncError(
          e.message ?? 'Error desconocido',
          StackTrace.current,
        );
      }
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e.message ?? 'Error desconocido', StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await _auth.signOut();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncLoading();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = const AsyncData(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncError(e.message ?? 'Error desconocido', StackTrace.current);
    }
  }
}
