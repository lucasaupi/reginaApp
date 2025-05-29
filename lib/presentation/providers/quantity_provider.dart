import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuantityNotifier extends StateNotifier<Map<String, int>> {
  QuantityNotifier() : super({});

  void increment(String productId) {
    final current = state[productId] ?? 1;
    state = {...state, productId: current + 1};
  }

  void decrement(String productId) {
    final current = state[productId] ?? 1;
    if (current > 1) {
      state = {...state, productId: current - 1};
    }
  }

  void reset(String productId) {
    final newState = Map<String, int>.from(state);
    newState.remove(productId);
    state = newState;
  }
}

final quantityProvider =
    StateNotifierProvider<QuantityNotifier, Map<String, int>>(
      (ref) => QuantityNotifier(),
    );
