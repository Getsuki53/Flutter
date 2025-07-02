import 'detalle_producto.dart';
import 'package:flutter/material.dart';
import 'package:Flutter/src/model/producto.dart';
import 'package:Flutter/src/model/item_carrito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Flutter/src/provider/CartProvider.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Carrito")),
        body: Center(child: Text("Tu carrito está vacío")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Carrito")),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (_, index) {
          final item = cartItems[index];
          final product = item.producto;

          return ListTile(
            leading: (product.fotoProd != null && product.fotoProd!.isNotEmpty)
                ? Image.network(product.fotoProd!, width: 60, fit: BoxFit.cover)
                : const Icon(Icons.image_not_supported, size: 60),
            title: Text(product.nomprod),
            subtitle: Text("\$${product.precio} x ${item.unidades}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(cartProvider.notifier).removeFromCart(product.id);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalleProducto(producto: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
