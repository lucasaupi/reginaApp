import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/product.dart';
import 'package:regina_app/presentation/providers/product_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchByNameProvider = StateProvider<bool>((ref) => true);

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final products = ref.watch(productProvider);
  final searchByName = ref.watch(searchByNameProvider);

  if (query.isEmpty) return products;

  return products.where((product) {
    if (searchByName) {
      return product.name.toLowerCase().contains(query);
    } else {
      return product.description.toLowerCase().contains(query);
    }
  }).toList();
});
