import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:regina_app/presentation/providers/user_orders_provider.dart';
import 'package:regina_app/presentation/providers/image_path_provider.dart';

class PurchaseDetailScreen extends ConsumerWidget {
  final String orderId;

  const PurchaseDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersProvider);

    return ordersAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (e, _) => Scaffold(body: Center(child: Text('Error al cargar: $e'))),
      data: (orders) {
        final order = orders.firstWhere(
          (o) => o.id == orderId,
          orElse: () => throw Exception('Orden no encontrada'),
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Resumen de compra'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orden #${order.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Estado: ${order.status}'),
                const SizedBox(height: 8),
                Text('Total: \$${order.totalPrice.toStringAsFixed(2)}'),
                const SizedBox(height: 8),
                Text(
                  'Fecha: ${order.createdAt?.toLocal().toString().split(' ').first ?? ''}',
                ),
                const Divider(height: 24),
                const Text(
                  'Productos:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      final imageAsync = ref.watch(
                        imagePathProvider((
                          'products',
                          item.product.imagePath ?? '',
                        )),
                      );

                      return ListTile(
                        leading: imageAsync.when(
                          data:
                              (url) => Image.network(
                                url,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                          loading:
                              () => const SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          error: (_, __) => const Icon(Icons.image),
                        ),
                        title: Text(item.product.name),
                        subtitle: Text('Cantidad: ${item.quantity}'),
                        trailing: Text(
                          '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
