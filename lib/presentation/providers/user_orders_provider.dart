import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/order.dart';

class UserOrdersNotifier extends StateNotifier<AsyncValue<List<PurchaseOrder>>> {
  UserOrdersNotifier() : super(const AsyncLoading());

  Future<void> loadOrdersForUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      state = const AsyncLoading();

      final snapshot = await FirebaseFirestore.instance
          .collection('purchaseOrders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      final orders = snapshot.docs
          .map((doc) => PurchaseOrder.fromMap(doc.data()))
          .toList();

      state = AsyncValue.data(orders);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

final userOrdersProvider =
    StateNotifierProvider<UserOrdersNotifier, AsyncValue<List<PurchaseOrder>>>(
  (ref) => UserOrdersNotifier(),
);