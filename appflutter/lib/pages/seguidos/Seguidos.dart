import 'package:appflutter/pages/Tienda/DetalleTienda.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appflutter/models/tienda_modelo.dart';
import 'package:appflutter/services/seguimiento/api_seg_tienda_x_usuario.dart';
import 'package:appflutter/services/tienda/api_detalle_tienda.dart';

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

  // Nueva función para obtener los detalles de todas las tiendas seguidas
  Future<List<Tienda>> _obtenerDetallesTiendasSeguidas(int usuarioId) async {
    // 1. Obtiene la lista de tiendas seguidas (solo trae el id)
    final seguidas = await APIObtenerListaTiendasSeguidasPorUsuario.obtenerListaTiendasSeguidasPorUsuario(usuarioId);
    // 2. Por cada tienda, consulta su detalle
    final detalles = await Future.wait(
      seguidas.map((t) => APIDetalleTienda.detalleTienda(t.id ?? t.id ?? 0))
    );
    // 3. Filtra las que no se pudieron cargar
    return detalles.whereType<Tienda>().toList();
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
        future: _obtenerDetallesTiendasSeguidas(usuarioId!),
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
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleTienda(tiendaId: tienda.id!),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
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
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14), // <-- más padding
                            ),
                            child: const Text(
                              'Dejar de seguir',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Borde inferior entre elementos
                  if (index < tiendas.length - 1)
                    const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}