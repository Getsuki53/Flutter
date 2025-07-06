import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appflutter/models/tienda_modelo.dart';
import 'package:appflutter/services/seguimiento/api_seg_tienda_x_usuario.dart';

class FollowedPage extends StatefulWidget {
  const FollowedPage({super.key});

  @override
  State<FollowedPage> createState() => _FollowedPageState();
}

class _FollowedPageState extends State<FollowedPage> {
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
    if (usuarioId == null) {
      return const Scaffold(
        // appBar: AppBar(title: Text("Tiendas seguidas")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Tiendas seguidas")),
      body: FutureBuilder<List<Tienda>>(
        future: APIObtenerListaTiendasSeguidasPorUsuario.obtenerListaTiendasSeguidasPorUsuario(usuarioId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final tiendas = snapshot.data ?? [];
          if (tiendas.isEmpty) {
            return const Center(child: Text("No sigues ninguna tienda"));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: tiendas.length,
            itemBuilder: (context, index) {
              final tienda = tiendas[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 241, 249, 255),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: tienda.logo != null && tienda.logo!.isNotEmpty
                          ? NetworkImage(tienda.logo!)
                          : const AssetImage('lib/imagenes/logo.png') as ImageProvider,
                      radius: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        tienda.nomTienda ?? 'Sin nombre',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        // Aquí puedes implementar dejar de seguir tienda
                        // y refrescar la lista si lo deseas
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Dejar de seguir',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}