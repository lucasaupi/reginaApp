import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:regina_app/domain/order.dart';
import 'package:regina_app/presentation/providers/user_orders_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:regina_app/presentation/providers/user_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        ref.read(userOrdersProvider.notifier).loadOrdersForUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myOrders = ref.watch(userOrdersProvider);
    final user = FirebaseAuth.instance.currentUser;
    final userNameAsync = ref.watch(userNameProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Debés iniciar sesión para ver tu perfil')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userNameAsync.when(
              data: (name) {
                final displayName =
                    (name != null && name.isNotEmpty)
                        ? name
                        : (user.email ?? 'Usuario');
                return Text(
                  'Hola, $displayName 👋',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text('Hola, ${user.email ?? 'Usuario'} 👋'),
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFCBDCEB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Mis Compras:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: myOrders.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
                data: (orders) {
                  if (orders.isEmpty) {
                    return const Center(
                      child: Text('No tenés compras realizadas.'),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return purchaseCard(order: order);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Mis Turnos:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class purchaseCard extends StatelessWidget {
  const purchaseCard({super.key, required this.order});

  final PurchaseOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          context.push('/purchase_detail/${order.id}');
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orden #${order.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Estado: ${order.status}'),
                Text('Total: \$${order.totalPrice.toStringAsFixed(2)}'),
                Text(
                  'Fecha: ${order.createdAt?.toLocal().toString().split(' ').first ?? ''}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
