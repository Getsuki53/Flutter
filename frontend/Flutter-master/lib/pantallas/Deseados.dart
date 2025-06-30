import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WishedPage extends StatefulWidget {
  const WishedPage({super.key});

  @override
  State<WishedPage> createState() => _WishedPageState();
}

class _WishedPageState extends State<WishedPage> {
  late Future<List<dynamic>> _futureDeseados;

  @override
  void initState() {
    super.initState();
    _futureDeseados = cargarListaDeseados();
  }

  Future<List<dynamic>> cargarListaDeseados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuario_id');
    if (usuarioId == null) return [];

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/productodeseado/ObtenerListaDeseadosPorUsuario/?usuario_id=$usuarioId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // data debe ser una lista de objetos con al menos el campo 'producto'
        if (data is List) return data;
      }
    } catch (e) {}
    return [];
  }

  Future<Map<String, dynamic>?> obtenerDetalleProducto(productoId) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/producto/ObtenerProductoMain/?producto_id=$productoId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map) return Map<String, dynamic>.from(data);
        if (data is List && data.isNotEmpty) return data[0];
      }
    } catch (e) {}
    return null;
  }

  Future<void> eliminarProductoDeseado(int productoId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuario_id');
    if (usuarioId == null) return;

    final url = Uri.parse('http://127.0.0.1:8000/api/productodeseado/EliminarProductoDeseado/');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario_id': usuarioId,
        'producto_id': productoId,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado de deseados')),
      );
      setState(() {
        _futureDeseados = cargarListaDeseados();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo eliminar el producto')),
      );
    }
  }

  void verDetalles(Map<String, dynamic> producto) {
    // Aquí puedes navegar a la pantalla de detalles del producto si lo deseas
    // Navigator.push(context, MaterialPageRoute(builder: (_) => DetalleProducto(...)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de productos deseados")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<dynamic>>(
          future: _futureDeseados,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tienes productos deseados'));
            }
            final deseados = snapshot.data!;
            return ListView.builder(
              itemCount: deseados.length,
              itemBuilder: (context, index) {
                final productoId = deseados[index]['producto'];
                return FutureBuilder<Map<String, dynamic>?>(
                  future: obtenerDetalleProducto(productoId),
                  builder: (context, detalleSnapshot) {
                    if (detalleSnapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        title: Text('Cargando...'),
                        leading: CircularProgressIndicator(),
                      );
                    }
                    if (!detalleSnapshot.hasData || detalleSnapshot.data == null) {
                      return const ListTile(
                        title: Text('No se pudo cargar el producto'),
                      );
                    }
                    final producto = detalleSnapshot.data!;
                    final nombre = producto['Nomprod'] ?? 'Sin nombre';
                    final imagen = producto['FotoProd'];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 249, 255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (imagen != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Image.network(
                                imagen.toString().startsWith('http')
                                    ? imagen
                                    : 'http://127.0.0.1:8000$imagen', // Ajusta la URL base si es necesario
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                              ),
                            ),
                          Expanded(
                            flex: 7,
                            child: InkWell(
                              onTap: () => verDetalles(producto),
                              child: Text(
                                nombre,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: OutlinedButton(
                              onPressed: () => eliminarProductoDeseado(productoId),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.red),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Quitar de deseados',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
