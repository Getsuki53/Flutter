import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FollowedPage extends StatefulWidget {
  const FollowedPage({super.key});

  @override
  State<FollowedPage> createState() => _FollowedPageState();
}

class _FollowedPageState extends State<FollowedPage> {
  late Future<List<dynamic>> _futureSeguidos = cargarListaSeguidos();

  Future<List<dynamic>> cargarListaSeguidos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuario_id');
    if (usuarioId == null) return [];

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/seguimientotienda/ObtenerListaTiendasSeguidasPorUsuario/?usuario_id=$usuarioId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) return data;
      }
    } catch (e) {}
    return [];
  }

  Future<Map<String, dynamic>?> obtenerDetalleProducto(tiendaId) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/tienda/ObtenerDetallesTienda/?tienda_id=$tiendaId'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map) return Map<String, dynamic>.from(data);
        if (data is List && data.isNotEmpty) return Map<String, dynamic>.from(data[0]);
      }
    } catch (e) {}
    return null;
  }

  Future<void> dejarSeguirTienda(int tiendaId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuario_id');
    if (usuarioId == null) return;

    final url = Uri.parse('http://127.0.0.1:8000/api/seguimientotienda/DejarDeSeguirTienda/');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario_id': usuarioId,
        'tienda_id': tiendaId,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Has dejado de seguir la tienda')),
      );
      setState(() {
        _futureSeguidos = cargarListaSeguidos();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo dejar de seguir la tienda')),
      );
    }
  }

  void verDetalles(Map<String, dynamic> tienda) {
    // Aquí puedes navegar a la pantalla de detalles de la tienda si lo deseas
    // Navigator.push(context, MaterialPageRoute(builder: (_) => DetalleTienda(...)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de seguidos")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<dynamic>>(
          future: _futureSeguidos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No sigues ninguna tienda'));
            }
            final seguidos = snapshot.data!;
            return ListView.builder(
              itemCount: seguidos.length,
              itemBuilder: (context, index) {
                final tiendaId = seguidos[index]['tienda'];
                return FutureBuilder<Map<String, dynamic>?>(
                  future: obtenerDetalleProducto(tiendaId),
                  builder: (context, detalleSnapshot) {
                    if (detalleSnapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(
                        title: Text('Cargando...'),
                        leading: CircularProgressIndicator(),
                      );
                    }
                    if (!detalleSnapshot.hasData || detalleSnapshot.data == null) {
                      return const ListTile(
                        title: Text('No se pudo cargar la tienda'),
                      );
                    }
                    final tienda = detalleSnapshot.data!;
                    final nombre = tienda['NomTienda'] ?? 'Sin nombre';
                    final logo = tienda['Logo'];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 249, 255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (logo != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: logo.toString().startsWith('http')
                                  ? Image.network(logo, width: 50, height: 50, fit: BoxFit.cover)
                                  : Image.network('http://127.0.0.1:8000$logo', width: 50, height: 50, fit: BoxFit.cover),
                            ),
                          Expanded(
                            flex: 7,
                            child: InkWell(
                              onTap: () => verDetalles(tienda),
                              child: Text(
                                nombre,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: OutlinedButton(
                              onPressed: () => dejarSeguirTienda(tiendaId),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.red),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: const Text(
                                'Dejar de seguir',
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
