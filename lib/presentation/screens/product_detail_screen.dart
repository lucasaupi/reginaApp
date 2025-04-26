import 'package:flutter/material.dart';
import 'package:regina_app/data/product_repository.dart';
import 'package:regina_app/domain/product.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key, required this.productId});

  String productId;
  List<Product> products = productRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del producto')),
      body: _ProductDetailView(
        product: products.firstWhere((product) => product.id == productId),
      ),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (product.imageUrl != null)
            Image.network(product.imageUrl!, height: 400),
          const SizedBox(height: 16),
          Text(product.name, style: textStyle.titleLarge),
          Text(product.description, style: textStyle.bodyLarge),
          Text(product.price.toString()),
        ],
      ),
    );
  }
}
