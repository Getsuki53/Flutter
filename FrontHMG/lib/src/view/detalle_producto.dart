import 'package:flutter/material.dart';
import 'package:Flutter/src/model/producto.dart';

class DetalleProducto extends StatefulWidget {
  final Producto producto;

  const DetalleProducto({super.key, required this.producto});

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}


class _DetalleProductoState extends State<DetalleProducto> {
  int cantidad = 1;

  void aumentarCantidad() {
    if (cantidad < widget.producto.stock) {
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

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return Scaffold(
      appBar: AppBar(title: Text(producto.nomprod)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: producto.fotoProd != null && producto.fotoProd!.isNotEmpty
                  ? Image.network(producto.fotoProd!, height: 180, fit: BoxFit.contain)
                  : const Icon(Icons.image_not_supported, size: 100),
            ),
            const SizedBox(height: 16),
            const Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(producto.descripcionProd),
            const SizedBox(height: 16),
            Text('Precio: \$${producto.precio}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Stock disponible: ${producto.stock}'),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Agregado $cantidad al carrito')),
                  );
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