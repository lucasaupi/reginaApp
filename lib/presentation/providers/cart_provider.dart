import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:regina_app/domain/cart_item.dart';
import 'package:regina_app/domain/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // Agregar producto al carrito
  void addToCart(Product product, {int quantity = 1}) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final existing = state[index];
      final updated = existing.copyWith(quantity: existing.quantity + quantity);
       final newState = [...state];
      newState[index] = updated;
      state = newState;
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void removeOneFromCart(Product product) {
     final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final current = state[index];
      if (current.quantity > 1) {
        final updated = current.copyWith(quantity: current.quantity - 1);
        final newState = [...state];
        newState[index] = updated;
        state = newState;
      } else {
        removeAllOf(product);
      }
    }
  }
   

  // Eliminar completamente un producto (todas sus unidades)
 void removeAllOf(Product product) {
  state = state.where((item) => item.product.id != product.id).toList();
}

  // Vaciar el carrito completamente
  void clearCart() {
    state = [];
  }

 double get total => state.fold(0,
      (sum, item) => sum + (item.product.price * item.quantity));

  int get totalItems {
  return state.fold(0, (sum, item) => sum + item.quantity);
}
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
