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

  Future<List<dynamic>?> cargarProductosTienda(tiendaId) async {
  try {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/producto/ObtenerProductosPorTienda/?tienda_id=$tiendaId'),
    );
    if (response.statusCode == 200) {
      // Si tu API retorna una lista de productos:
      return json.decode(response.body);
      // Si retorna un objeto con una clave 'productos', usa:
      // return json.decode(response.body)['productos'];
    }
  } catch (e) {
    // Maneja el error si lo deseas
    print("ELPEPE");
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
          final logoUrl = tienda['Logo'] ?? null;
          final tiendaId = tienda['id'];
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                          Text('Productos: $cantProd'),
                          Text('Seguidores: $cantSeg'),
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
                  child: FutureBuilder<List<dynamic>?>(
                    future: cargarProductosTienda(tiendaId),
                    builder: (context, prodSnapshot) {
                      if (prodSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!prodSnapshot.hasData || prodSnapshot.data == null || prodSnapshot.data!.isEmpty) {
                        return const Center(child: Text('No hay productos publicados'));
                      }
                      final productos = prodSnapshot.data!;
                      return GridView.builder(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalleProducto(
                                    nombre: producto['Nomprod'] ?? '',
                                    descripcion: producto['DescripcionProd'] ?? '',
                                    precio: double.tryParse(producto['Precio'].toString()) ?? 0.0,
                                    imagen: producto['FotoProd'] ?? '',
                                    stock: int.tryParse(producto['Stock'].toString()) ?? 0,
                                    categoria: producto['tipoCategoria']?.toString(),
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
                                      child: producto['FotoProd'] != null
                                          ? (producto['FotoProd'].toString().startsWith('http')
                                              ? Image.network(
                                                  producto['FotoProd'],
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.asset(
                                                  producto['FotoProd'],
                                                  fit: BoxFit.contain,
                                                ))
                                          : const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(producto['Nomprod'] ?? 'Sin nombre', style: const TextStyle(fontSize: 16)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
