import 'package:flutter/material.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';
import 'package:appflutter/services/productos/api_productos_x_carrito.dart';
import 'package:appflutter/models/producto_modelo.dart';

class CartView extends StatelessWidget {
  final int usuarioId; // Debes pasar el id del usuario al construir este widget

  const CartView({super.key, required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Producto>>(
      future: APIObtenerProductosCarrito.obtenerProductosCarrito(usuarioId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            // appBar: AppBar(title: Text("Carrito")),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Carrito")),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final cartItems = snapshot.data ?? [];

        if (cartItems.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text("Carrito")),
            body: const Center(child: Text("Tu carrito está vacío")),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Carrito")),
          body: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (_, index) {
              final product = cartItems[index];
              return ListTile(
                leading: Image.network(product.fotoProd, width: 60),
                title: Text(product.nomprod),
                subtitle: Text("\$${product.precio}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalleProducto(
                        id: product.id!,
                        nombre: product.nomprod,
                        descripcion: product.descripcionProd,
                        precio: product.precio,
                        imagen: product.fotoProd,
                        stock: product.stock,
                        categoria: product.tipoCategoria,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}