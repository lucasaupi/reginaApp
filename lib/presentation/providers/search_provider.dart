import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/product.dart';
import 'package:regina_app/presentation/providers/product_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final products = ref.watch(productProvider);

  if (query.isEmpty) return products;

  return products
      .where((product) => product.name.toLowerCase().contains(query))
      .toList();
});
