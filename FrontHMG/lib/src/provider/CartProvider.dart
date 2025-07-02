import 'package:Flutter/src/model/producto.dart';
import 'package:Flutter/src/model/item_carrito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends StateNotifier<List<ItemCarrito>> {
  CartNotifier() : super([]);

  void addToCart(Producto product, {int quantity = 1}) {
    final index = state.indexWhere((item) => item.producto.id == product.id);

    if (index != -1) {
      // Ya está en el carrito → aumentar cantidad
      state[index].unidades += quantity;
      state = [...state];
    } else {
      // Agregar nuevo
      state = [...state, ItemCarrito(producto: product, unidades: quantity)];
    }
  }

  void removeFromCart(int productId) {
    state = state.where((item) => item.producto.id != productId).toList();
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<ItemCarrito>>(
  (ref) => CartNotifier(),
);