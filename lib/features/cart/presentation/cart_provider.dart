import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shop/domain/product.dart';

// 1. We use a Notifier to manage the complex state of the cart
class CartNotifier extends Notifier<Map<Product, int>> {
  @override
  Map<Product, int> build() {
    // The initial state of the cart is an empty Map
    return {};
  }

  // 2. Method to add a product
  void addProduct(Product product) {
    // If the product is already in the cart, increase the quantity
    if (state.containsKey(product)) {
      state = {
        ...state,
        product: state[product]! + 1,
      };
    } else {
      // If it's not in the cart, add it with a quantity of 1
      state = {
        ...state,
        product: 1,
      };
    }
  }

  // 3. Method to remove a single unit of a product
  void removeProduct(Product product) {
    if (!state.containsKey(product)) return;

    if (state[product] == 1) {
      // If quantity is 1, completely remove the item from the map
      final newState = Map<Product, int>.from(state);
      newState.remove(product);
      state = newState;
    } else {
      // Otherwise, just decrease the quantity
      state = {
        ...state,
        product: state[product]! - 1,
      };
    }
  }

  // 4. Helper method to get the total number of items in the cart
  int get totalItems {
    return state.values.fold(0, (total, quantity) => total + quantity);
  }
}

// 5. The provider that makes this accessible globally
final cartProvider = NotifierProvider<CartNotifier, Map<Product, int>>(() {
  return CartNotifier();
});