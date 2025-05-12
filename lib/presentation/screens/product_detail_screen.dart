import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/product.dart';
import 'package:regina_app/presentation/providers/product_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);
    final product = products.firstWhere(
      (p) => p.id == productId,
      orElse: () => Product(
        id: '',
        name: 'Producto no encontrado',
        description: '',
        price: 0,
      ),
    );

    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del producto')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (product.imageUrl != null)
              Image.network(
                product.imageUrl!,
                height: 300,
              ),
            const SizedBox(height: 16),
            Text(product.name, style: textStyle.titleLarge),
            Text(product.description, style: textStyle.bodyLarge),
            Text('\$${product.price}', style: textStyle.bodyMedium),
          ],
        ),
      ),
    );
  }
}
