import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/product.dart';

final productProvider = StateNotifierProvider<ProductsNotifier, List<Product>>(
  (ref) => ProductsNotifier(FirebaseFirestore.instance),
);

class ProductsNotifier extends StateNotifier<List<Product>> {
  final FirebaseFirestore db;

  ProductsNotifier(this.db) : super([]);

  Future<void> getAllProducts() async {
    final query = db
        .collection('products')
        .withConverter<Product>(
          fromFirestore: Product.fromFirestore,
          toFirestore: (product, _) => product.toFirestore(),
        )
        .where('status', isEqualTo: 'active');

    final snapshot = await query.get();
    state = snapshot.docs.map((d) => d.data()).toList();
  }
}
