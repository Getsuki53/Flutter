import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'MiTienda.dart';
import 'Seguidos.dart';
import 'Deseados.dart';

class MiPerfil extends StatelessWidget {
  const MiPerfil({super.key});

  Future<Map<String, dynamic>?> cargarDatosUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuario_id');
    if (usuarioId == null) return null;

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/usuario/$usuarioId/'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      // Maneja el error
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: cargarDatosUsuario(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No se pudieron cargar los datos'));
          }

          final usuario = snapshot.data!;
          final nombre = usuario['nombre'] ?? 'Sin nombre';
          final correo = usuario['correo'] ?? 'Sin correo';
          final fotoUrl = usuario['foto'] ?? null; // Ajusta el nombre del campo según tu modelo

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: fotoUrl != null
                        ? NetworkImage(fotoUrl)
                        : AssetImage('lib/imagenes/vicho.png') as ImageProvider,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nombre, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(correo),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MiTienda()),
                    );
                  },
                  child: const Text('Mi Tienda'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FollowedPage()),
                    );
                  },
                  child: const Text('Tiendas Seguidas'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WishedPage()),
                    );
                  },
                  child: const Text('Lista de deseos'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}