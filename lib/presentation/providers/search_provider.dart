import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/product.dart';
import 'package:regina_app/domain/service.dart';
import 'package:regina_app/presentation/providers/product_provider.dart';
import 'package:regina_app/presentation/providers/service_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchByNameProvider = StateProvider<bool>((ref) => true);

final filteredServicesProvider = Provider<List<Service>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final services = ref.watch(serviceProvider);

  if (query.isEmpty) return services;

  return services.where((service) {
    final text = service.name;
    return text.toLowerCase().contains(query);
  }).toList();
});

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
