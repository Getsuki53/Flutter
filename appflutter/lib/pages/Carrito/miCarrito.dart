import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appflutter/services/productos/api_productos_x_carrito.dart';

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
        backgroundColor: Colors.blue,
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

          print('🔍 Usuario ID para carrito: $userId'); // Debug

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: APIObtenerProductosCarrito.obtenerProductosCarrito(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final cartItems = snapshot.data ?? [];

              print('🔍 Items en carrito: ${cartItems.length}'); // Debug

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
                        color: Colors.blue,
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
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.shopping_bag, color: Colors.blue),
                            ),
                            title: Text(
                              "Producto ID: ${item['producto']}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Unidades: ${item['unidades']}"),
                                Text("Valor total: \$${item['valortotal']}"),
                                Text("Item ID: ${item['id']}", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    // TODO: Implementar reducir cantidad
                                    print("Reducir cantidad del item ${item['id']}");
                                  },
                                ),
                                Text(
                                  "${item['unidades']}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    // TODO: Implementar aumentar cantidad
                                    print("Aumentar cantidad del item ${item['id']}");
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              // TODO: Navegar a detalle del producto
                              print("Ver detalle del producto ${item['producto']}");
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
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implementar checkout
                          print("Proceder al checkout");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "Proceder al Pago (${cartItems.length} items)",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
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