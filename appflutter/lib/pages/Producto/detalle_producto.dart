import 'package:flutter/material.dart';
import 'package:appflutter/services/carrito/api_agregar_al_carrito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetalleProducto extends StatefulWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final int stock;
  final String? categoria;

  const DetalleProducto({
    super.key,
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.stock,
    required this.categoria,
  });

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  int cantidad = 1;

  void aumentarCantidad() {
    if (cantidad < widget.stock) {
      setState(() {
        cantidad++;
      });
    }
  }

  void disminuirCantidad() {
    if (cantidad > 1) {
      setState(() {
        cantidad--;
      });
    }
  }

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> agregarAlCarrito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuario_id');

    try {
      final mensaje = await APIAgregarAlCarrito.agregarAlCarrito(
        usuarioId!,
        widget.id,
        cantidad,
      );
      if (mensaje != null) {
        if (cantidad > 1) {
          showSnackbar("$cantidad productos agregados al carrito");
        } else {
          showSnackbar("$cantidad producto agregado al carrito");
        }
      } else {
        showSnackbar("Error al agregar al carrito $mensaje");
      }
    } catch (e) {
      showSnackbar("Error de conexión: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.imagen,
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.descripcion),
            const SizedBox(height: 16),
            Text('Precio: \$${widget.precio}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Stock disponible: ${widget.stock}'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: disminuirCantidad,
                  icon: const Icon(Icons.remove),
                ),
                Text('$cantidad', style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: aumentarCantidad,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Acción para agregar al carrito
                  agregarAlCarrito();
                },
                child: const Text('Agregar al carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}