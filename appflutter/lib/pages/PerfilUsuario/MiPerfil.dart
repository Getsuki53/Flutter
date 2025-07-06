import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Tienda/MiTienda.dart';
import '../Seguidos/Seguidos.dart';
import '../Deseados/Deseados.dart';
import 'package:appflutter/services/usuario/api_perfil.dart';
import 'package:appflutter/models/usuario_modelo.dart';

class MiPerfil extends StatefulWidget {
  const MiPerfil({super.key});

  @override
  State<MiPerfil> createState() => _MiPerfilState();
}

class _MiPerfilState extends State<MiPerfil> {
  int? usuarioId;

  @override
  void initState() {
    super.initState();
    _loadUsuarioId();
  }

  Future<void> _loadUsuarioId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usuarioId = prefs.getInt('usuario_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: usuarioId == null
          ? Center(child: Text("UsuarioID = $usuarioId"))
          : FutureBuilder<Usuario?>(
              future: APIPerfil.obtenerPerfil(usuarioId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                final usuario = snapshot.data;
                if (usuario == null) {
                  return const Center(child: Text("No se pudo cargar el perfil"));
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: (usuario.foto != null && usuario.foto!.isNotEmpty)
                                ? NetworkImage(usuario.foto!)
                                : const AssetImage('lib/imagenes/logo.png') as ImageProvider,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(usuario.nombre, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(usuario.apellido ?? ''),
                              Text(usuario.correo ?? ''),
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
                        onPressed: usuarioId == null
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WishedPage(usuarioId: usuarioId!),
                                  ),
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