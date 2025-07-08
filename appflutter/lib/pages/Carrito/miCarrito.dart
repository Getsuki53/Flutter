import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appflutter/services/productos/api_productos_x_carrito.dart';
import 'package:appflutter/models/carrito_item_detallado.dart';

class CartView extends StatelessWidget {
  final int? usuarioId;

  const CartView({super.key, this.usuarioId});

  Future<int?> _getUserId() async {
    if (usuarioId != null) return usuarioId;
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuario_id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito"),
        backgroundColor: const Color(0xff383758),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<int?>(
        future: _getUserId(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userId = userSnapshot.data;
          if (userId == null) {
            return const Center(child: Text("Usuario no identificado"));
          }

          print('🔍 Usuario ID para carrito: $userId');

          return FutureBuilder<List<CarritoItemDetallado>>(
            future: APIObtenerProductosCarrito.obtenerProductosCarritoDetallado(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final cartItems = snapshot.data ?? [];

              print('🔍 Items detallados en carrito: ${cartItems.length}');

              if (cartItems.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text("Tu carrito está vacío", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Header con conteo de items
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.blue.shade50,
                    child: Text(
                      "${cartItems.length} item(s) en tu carrito",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffae92f2),
                      ),
                    ),
                  ),
                  // Lista de productos
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: cartItems.length,
                      itemBuilder: (_, index) {
                        final item = cartItems[index];
                        final producto = item.producto;
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey.shade200,
                              ),
                              child: producto?.fotoProd != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        producto!.fotoProd,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.image_not_supported, color: Colors.grey);
                                        },
                                      ),
                                    )
                                  : const Icon(Icons.shopping_bag, color: Colors.grey),
                            ),
                            title: Text(
                              producto?.nomprod ?? "Producto #${item.productoId}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text("Cantidad: ${item.unidades}"),
                                Text(
                                  "Precio unitario: \$${producto?.precio ?? 'N/A'}",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Total: \$${(producto?.precio ?? 0) * item.unidades}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:  Color(0xff383758),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    print("Reducir cantidad del item ${item.id}");
                                  },
                                ),
                                Text(
                                  "${item.unidades}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    print("Aumentar cantidad del item ${item.id}");
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              if (producto != null) {
                                print("Ver detalle del producto ${producto.nomprod}");
                                // TODO: Navegar a detalle del producto
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  // Botón de checkout
                  if (cartItems.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Total general
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total:",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "\$${cartItems.fold(0.0, (sum, item) => sum + ((item.producto?.precio ?? 0) * item.unidades)).toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffae92f2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () {
                              print("Proceder al checkout");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffae92f2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              "Proceder al Pago (${cartItems.length} items)",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// Ejemplo de cómo llamar al widget desde otra pantalla:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => const CartView(), // Sin pasar userId, lo obtendrá de SharedPreferences
//   ),
// );