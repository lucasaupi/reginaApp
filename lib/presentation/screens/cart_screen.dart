import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/product.dart';
import 'package:regina_app/presentation/providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    

    
    final total = ref.watch(cartProvider.notifier).total;

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: Column(
        children: [
          Expanded(
            child:
                cart.isEmpty
                    ? const Center(child: Text('Tu carrito está vacío.'))
                    : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                          final item = cart[index];
                        final product = item.product;
                        final quantity = item.quantity;

                        return item_cart_card(product: product,
                         quantity: quantity,
                          cartNotifier: cartNotifier
                          );
                      },
                    ),
          ),

          // RESUMEN DEL PEDIDO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Envío:', style: TextStyle(fontSize: 16)),
                    Text('Retiro por local', style: TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '📍 Retiro de la compra:\nSolo con retiro en el local.\n\n🕒 Horarios:\nLunes a viernes de 9 a 18 hs.\nSábados de 9 a 13 hs.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class item_cart_card extends StatelessWidget {
  const item_cart_card({
    super.key,
    required this.product,
    required this.quantity,
    required this.cartNotifier,
  });

  final Product product;
  final int quantity;
  final CartNotifier cartNotifier;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        leading:
            product.imageUrl != null
                ? Image.network(
                  product.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                : const Icon(
                  Icons.image_not_supported,
                  size: 50,
                ),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Precio: \$${product.price.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 4),
            Text(
              'Subtotal: \$${(product.price * quantity).toStringAsFixed(2)}',
            ),
          ],
        ),
        trailing: SizedBox(
          height: 60, // ajustá según tu gusto
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              
              Text(
                'Cantidad: $quantity',
                style: const TextStyle(fontSize: 12),
              ),
              IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                cartNotifier.removeOneFromCart(product);}
            ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                iconSize: 20, // opcional: más chico
                padding:
                    EdgeInsets
                        .zero, // elimina padding innecesario
                constraints:
                    const BoxConstraints(), // elimina restricciones extra
                onPressed: () {
                  cartNotifier.removeAllOf(product);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
