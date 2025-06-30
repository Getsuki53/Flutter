import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'PublicarProducto.dart';
import 'DetalleProducto.dart';

class MiTienda extends StatelessWidget {
  const MiTienda({super.key});

  Future<Map<String, dynamic>?> cargarDatosTienda() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuario_id');
    if (usuarioId == null) return null;

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/tienda/ObtenerTiendaPorPropietario/?propietario_id=$usuarioId'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      // Maneja el error
    }
    return null;
  }

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
      body: FutureBuilder<Map<String, dynamic>?>(
        future: cargarDatosTienda(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No se pudieron cargar los datos'));
          }

          final tienda = snapshot.data!;
          final nombre = tienda['NomTienda'] ?? 'Sin nombre';
          final descTienda = tienda['DescripcionTienda'] ?? 'Sin correo';
          final cantProd = tienda['Cant_productos'] ?? 'Sin correo';
          final cantSeg = tienda['Cant_seguidores'] ?? 'Sin correo';
          final logoUrl = tienda['foto'] ?? null;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: logoUrl != null
                        ? NetworkImage(logoUrl)
                        : AssetImage('lib/imagenes/vicho.png') as ImageProvider,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nombre, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(descTienda),
                        Text(cantProd.toString()),
                        Text(cantSeg.toString()),
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
          );
        },
      ),
    );
  }
}
