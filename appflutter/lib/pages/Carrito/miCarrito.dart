import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appflutter/services/productos/api_productos_x_carrito.dart';
import 'package:appflutter/services/carrito/api_actualizar_cantidad_carrito.dart';
import 'package:appflutter/models/carrito_item_detallado.dart';

class CartView extends StatefulWidget {
  final int? usuarioId;

  const CartView({super.key, this.usuarioId});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<CarritoItemDetallado> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<int?> _getUserId() async {
    if (widget.usuarioId != null) return widget.usuarioId;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuario_id');
  }

  Future<void> _loadCartItems() async {
    final userId = await _getUserId();
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final items =
          await APIObtenerProductosCarrito.obtenerProductosCarritoDetallado(
            userId,
          );
      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading cart items: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateQuantity(int productoId, int newQuantity) async {
    final userId = await _getUserId();
    if (userId == null) return;

    try {
      final result = await APIActualizarCantidadCarrito.actualizarCantidad(
        userId,
        productoId,
        newQuantity,
      );

      if (result != null && result['success'] == true) {
        // Recargar todos los items del carrito
        await _loadCartItems();

        // Mostrar mensaje apropiado
        if (result['eliminado'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Producto eliminado del carrito'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Cantidad actualizada'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['error'] ?? 'Error al actualizar cantidad'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _increaseQuantity(CarritoItemDetallado item) {
    final producto = item.producto;
    if (producto != null && item.unidades < producto.stock) {
      _updateQuantity(item.productoId, item.unidades + 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No puedes agregar más. Stock insuficiente.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _decreaseQuantity(CarritoItemDetallado item) {
    // Permitir que la cantidad llegue a 0 para eliminar el producto automáticamente
    _updateQuantity(item.productoId, item.unidades - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1e2a),
      appBar: AppBar(
        title: const Text("Carrito"),
        backgroundColor: const Color(0xff383758),
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildCartContent(),
    );
  }

  Widget _buildCartContent() {
    if (cartItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Tu carrito está vacío",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      );
    }

    print('🔍 Items detallados en carrito: ${cartItems.length}');

    return Column(
      children: [
        // Header con conteo de items
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Color(0xff383758),
          child: ShaderMask(
            shaderCallback:
                (bounds) => const LinearGradient(
                  colors: [
                    Color(0xffe8d0f8),
                    Color(0xffae92f2),
                    Color(0xff9dd5f3),
                    Color(0xffe8d0f8),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
            child: Text(
              "${cartItems.length} item(s) en tu carrito",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                    child:
                        producto?.fotoProd != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                producto!.fotoProd,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            )
                            : const Icon(
                              Icons.shopping_bag,
                              color: Colors.grey,
                            ),
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
                          color: Color(0xff383758),
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _decreaseQuantity(item),
                      ),
                      Text(
                        "${item.unidades}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _increaseQuantity(item),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${cartItems.fold(0.0, (sum, item) => sum + ((item.producto?.precio ?? 0) * item.unidades)).toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Nuevo diseño de botón tipo login
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffe8d0f8),
                        Color(0xffae92f2),
                        Color(0xff9dd5f3),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        print("Proceder al checkout");
                      },
                      child: Center(
                        child: Text(
                          "Proceder al Pago (${cartItems.length} items)",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
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
