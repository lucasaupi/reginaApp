import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/product.dart';
import 'package:regina_app/presentation/providers/cart_provider.dart';
import 'package:regina_app/presentation/providers/product_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

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
                height: 250,
              ),
            const SizedBox(height: 16),
            Text(product.name, style: textStyle.titleLarge),
            const SizedBox(height: 8),

           //Para un futuro agregar la cantidad de productos
              //    Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     IconButton(
              //               onPressed: (){
                  
              //               },
              //               icon: Icon(Icons.remove),
              //             ),
              //              Text('1',
              //               style: TextStyle(fontSize: 12),
              //                ),
              //                IconButton(
              //                 onPressed: (){

              //                 },
              //                 icon: Icon(Icons.add),
              //                 )
              //                  ],
              // ),
               ElevatedButton.icon(
                onPressed: () {

                  cartNotifier.addToCart(product);
                   ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${product.name} agregado al carrito')),
            );
             },
                icon: Icon(Icons.add_shopping_cart),
                label: Text('Agregar al carrito'),
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
