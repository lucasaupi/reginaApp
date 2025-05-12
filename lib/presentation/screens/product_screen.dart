import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:regina_app/domain/product.dart';
import 'package:regina_app/presentation/providers/product_provider.dart';

class ProductScreen extends ConsumerWidget {
  ProductScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);

   // Future.microtask(() => ref.read(productProvider.notifier).getAllProducts());

    return Scaffold(
      appBar: AppBar(title: Text('Productos')),
      body:
          products.isEmpty
              ? const Center(child: Text("No hay productos"))
              : _ProductListView(products: products),
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

class _ProductItemView extends StatelessWidget {
  const _ProductItemView({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product_detail/${product.id}'),
      child: Card(
        child: ListTile(
          trailing: const Icon(Icons.chevron_right),
          leading:
              product.imageUrl != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                  : const SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.list_alt_rounded),
                  ),
          title: Text(product.name),
          subtitle: Text(product.description),
        ),
      ),
    );
  }
}
