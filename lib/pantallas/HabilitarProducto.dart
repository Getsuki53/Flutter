import 'package:flutter/material.dart';

class HabilitarProducto extends StatefulWidget {
  const HabilitarProducto({super.key});

  @override
  State<HabilitarProducto> createState() => _HabilitarProductoPageState();
}

class _HabilitarProductoPageState extends State<HabilitarProducto> {
  // Datos simulados del producto
  final Map<String, dynamic> producto = {
    'nombre': 'Peluche Elefante de Lana',
    'categoria': 'Lana',
    'descripcion': 'Un peluche de minion cute.',
    'stock': 12,
    'precio': 2990,
    'imagenes': 'lib/imagenes/elefante.png', 
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(producto['nombre'] as String)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen principal (placeholder)
            Image.asset(
              producto['imagenes'],
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),

            Text('Categoría: ${producto['categoria']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),

            Text(producto['descripcion'] as String, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),

            Text('Stock disponible: ${producto['stock']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),

            Text('Precio: \$${producto['precio']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción para eliminar el producto
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Producto eliminado')),
                    );
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Acción para habilitar el producto
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Producto habilitado')),
                    );
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Habilitar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
