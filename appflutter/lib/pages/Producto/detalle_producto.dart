import 'package:flutter/material.dart';

class DetalleProducto extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final int stock;
  final String? categoria;

  const DetalleProducto({
    super.key,
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
              child:
                  widget.imagen.isNotEmpty
                      ? Image.network(
                        widget.imagen,
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          print(
                            '🚨 ERROR detalle - No se pudo cargar imagen: ${widget.imagen}',
                          );
                          print('🚨 ERROR detalle - Error: $error');
                          return Container(
                            height: 180,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                      : Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.grey,
                        ),
                      ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.descripcion),
            const SizedBox(height: 16),
            Text(
              'Precio: \$${widget.precio}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
