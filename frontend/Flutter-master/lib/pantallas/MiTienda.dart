import 'package:flutter/material.dart';
import 'PublicarProducto.dart';
import 'DetalleProducto.dart';

class MiTienda extends StatelessWidget {
  const MiTienda({super.key});

  final List<Map<String, dynamic>> productos = const [
    {
      'nombre': 'Peluche patricio',
      'descripcion': 'Un peluche de patricio cute.',
      'precio': 2990,
      'stock': 12,
      'categoria': 'Lana',
      'imagen': 'lib/imagenes/pati.png',
    },
    {
      'nombre': 'Elefante de Lana',
      'descripcion': 'Elefante tejida a mano.',
      'precio': 1500,
      'stock': 5,
      'categoria': 'Lana',
      'imagen': 'lib/imagenes/elefante.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nombre de la tienda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('lib/imagenes/vicho.png'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nombre de la tienda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Correo'),
                      Text('Teléfono'),
                      Text('Descripción de la tienda'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                debugPrint('Navegando a PublicarProducto');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PublicarProducto()),
                );
              },
              child: const Text('Publicar producto'),
            ),
            const SizedBox(height: 24),
            const Text('Productos publicados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Flexible(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  return GestureDetector(
                    onTap: () {
                      debugPrint('Producto ${producto['nombre']} seleccionado');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleProducto(
                            nombre: producto['nombre'],
                            descripcion: producto['descripcion'],
                            precio: producto['precio'],
                            imagen: producto['imagen'],
                            stock: producto['stock'],
                            categoria: producto['categoria'],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                producto['imagen'],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(producto['nombre'], style: const TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
