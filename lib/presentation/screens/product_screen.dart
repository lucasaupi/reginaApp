import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:regina_app/domain/cart_item.dart';
import 'package:regina_app/domain/product.dart';
import 'package:regina_app/presentation/providers/cart_provider.dart';
import 'package:regina_app/presentation/providers/image_path_provider.dart';
import 'package:regina_app/presentation/providers/quantity_provider.dart';
import 'package:regina_app/presentation/providers/search_provider.dart';
import 'package:regina_app/presentation/providers/product_provider.dart';
import 'package:regina_app/presentation/providers/storage_provider.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  void initState() {
    super.initState();

    // Escucha manual del carrito para sincronizar cantidades
    ref.listenManual<List<CartItem>>(cartProvider, (previous, next) {
      final quantityNotifier = ref.read(quantityProvider.notifier);
      quantityNotifier.resetAll();
      for (final item in next) {
        quantityNotifier.setQuantity(item.product.id, item.quantity);
      }
    });

    // Carga inicial de productos
    Future.microtask(() => ref.read(productProvider.notifier).getAllProducts());
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    final filteredProducts = ref.watch(filteredProductsProvider);
    final searchByName = ref.watch(searchByNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(searchByName ? Icons.description : Icons.text_fields),
            tooltip:
                searchByName ? 'Buscar por descripción' : 'Buscar por nombre',
            onPressed: () {
              ref.read(searchByNameProvider.notifier).state = !searchByName;
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText:
                    searchByName
                        ? 'Buscar por nombre...'
                        : 'Buscar por descripción...',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 100, 100, 100),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged:
                  (value) =>
                      ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
        ),
      ),
      body:
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _ProductListView(products: filteredProducts),
    );
  }
}

class _ProductListView extends StatelessWidget {
  const _ProductListView({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductItemView(product: products[index]);
      },
    );
  }
}
class _ProductItemView extends ConsumerWidget {
  const _ProductItemView({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final quantityMap = ref.watch(quantityProvider);
    final quantity = quantityMap[product.id] ?? 0;

    final imageAsync = ref.watch(
      imagePathProvider(('products', product.imagePath ?? '')),
    );

    return Card(
      child: ListTile(
        onTap: () => context.push('/product_detail/${product.id}'),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageAsync.when(
            data: (url) => Image.network(
              url,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            loading: () => const SizedBox(
              width: 50,
              height: 50,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => const SizedBox(
              width: 50,
              height: 50,
              child: Icon(Icons.list_alt_rounded),
            ),
          ),
        ),
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: quantity == 0
            ? IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  ref.read(quantityProvider.notifier).increment(product.id);
                  cartNotifier.addToCart(product, quantity: 1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} agregado al carrito'),
                    ),
                  );
                },
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (quantity == 1) {
                        ref.read(quantityProvider.notifier).reset(product.id);
                      } else {
                        ref.read(quantityProvider.notifier).decrement(product.id);
                      }
                      cartNotifier.removeOneFromCart(product);
                    },
                  ),
                  Text('$quantity'),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      ref.read(quantityProvider.notifier).increment(product.id);
                      cartNotifier.addToCart(product, quantity: 1);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
