import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/product.dart';
import 'package:regina_app/presentation/providers/cart_provider.dart';
import 'package:regina_app/presentation/providers/product_provider.dart';
import 'package:regina_app/presentation/providers/quantity_provider.dart';
import 'package:regina_app/presentation/widgets/cart_icon_button.dart';
import 'package:regina_app/presentation/providers/image_path_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);
    final quantityNotifier = ref.watch(quantityProvider.notifier);
    final cartNotifier = ref.read(cartProvider.notifier);

    final product = products.firstWhere(
      (p) => p.id == productId,
      orElse:
          () => Product(
            id: '',
            name: 'Producto no encontrado',
            description: '',
            price: 0,
          ),
    );

    final quantity = ref.watch(quantityProvider)[product.id] ?? 1;
    final textStyle = Theme.of(context).textTheme;
    final imageAsync = ref.watch(
      imagePathProvider(('products', product.imagePath ?? '')),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
        actions: [CartIconButton()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageAsync.when(
              data: (url) => Image.network(url, height: 250),
              loading: () => const SizedBox(
                height: 250,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const SizedBox(
                height: 250,
                child: Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(height: 16),
            Text(product.name, style: textStyle.titleLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    quantityNotifier.decrement(product.id);
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text('$quantity', style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: () {
                    quantityNotifier.increment(product.id);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                cartNotifier.addToCart(product, quantity: quantity);
                quantityNotifier.reset(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} agregado al carrito'),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Agregar al carrito'),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(product.description, style: textStyle.bodyLarge),
            ),
            Text('\$${product.price}', style: textStyle.bodyMedium),
          ],
        ),
      ),
    );
  }
}
