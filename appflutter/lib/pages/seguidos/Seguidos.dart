import 'package:appflutter/pages/Tienda/DetalleTienda.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appflutter/models/tienda_modelo.dart';
import 'package:appflutter/services/seguimiento/api_seg_tienda_x_usuario.dart';
import 'package:appflutter/services/tienda/api_detalle_tienda.dart';
import 'package:appflutter/services/seguimiento/api_eliminar_seguimiento.dart';

class FollowedPage extends StatefulWidget {
  const FollowedPage({super.key});

  @override
  State<FollowedPage> createState() => _FollowedPageState();
}

class _FollowedPageState extends State<FollowedPage> {
  int? usuarioId;
  List<Tienda> tiendas = [];
  bool isLoading = false;

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
    if (usuarioId != null) {
      _cargarTiendasSeguidas();
    }
  }

  Future<void> _cargarTiendasSeguidas() async {
    debugPrint('🔍 Cargando tiendas seguidas para usuario: $usuarioId');
    setState(() {
      isLoading = true;
    });

    try {
      // 1. Obtiene la lista de tiendas seguidas (solo trae el id)
      final seguidas =
          await APIObtenerListaTiendasSeguidasPorUsuario.obtenerListaTiendasSeguidasPorUsuario(
            usuarioId!,
          );
      debugPrint('🔍 Tiendas seguidas obtenidas: ${seguidas.length}');

      // 2. Por cada tienda, consulta su detalle
      final detalles = await Future.wait(
        seguidas.map((t) => APIDetalleTienda.detalleTienda(t.id ?? 0)),
      );

      // 3. Filtra las que no se pudieron cargar
      final tiendasValidas = detalles.whereType<Tienda>().toList();
      debugPrint('🔍 Detalles de tiendas cargados: ${tiendasValidas.length}');

      if (mounted) {
        setState(() {
          tiendas = tiendasValidas;
        });
      }
    } catch (e) {
      debugPrint('❌ Error al cargar tiendas seguidas: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar tiendas seguidas: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _dejarDeSeguirTienda(Tienda tienda, int index) async {
    try {
      final mensaje = await APIDejarDeSeguir.eliminarSeguimiento(
        usuarioId!,
        tienda.id!,
      );

      if (mensaje != null) {
        if (mounted) {
          setState(() {
            tiendas.removeAt(index);
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(mensaje)));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al dejar de seguir la tienda')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (usuarioId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color(0xff1f1e2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff383758),
        title: const Text("Tiendas seguidas",
          style: TextStyle(
            color: Colors.white,
            ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarTiendasSeguidas,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : tiendas.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text("No sigues ninguna tienda", style: TextStyle(color: Colors.white),),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _cargarTiendasSeguidas,
                      child: const Text("Recargar", style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _cargarTiendasSeguidas,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: tiendas.length,
                  itemBuilder: (context, index) {
                    final tienda = tiendas[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xfffcf6ff),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Logo de la tienda
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child:
                                  tienda.logo != null && tienda.logo!.isNotEmpty
                                      ? Image.network(
                                        tienda.logo!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return const Icon(
                                            Icons.store,
                                            size: 60,
                                            color: Colors.grey,
                                          );
                                        },
                                      )
                                      : const Icon(
                                        Icons.store,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            DetalleTienda(tiendaId: tienda.id!),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tienda.nomTienda ?? 'Sin nombre',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (tienda.descripcionTienda != null)
                                    Text(
                                      tienda.descripcionTienda!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: OutlinedButton(
                              onPressed: () {
                                _dejarDeSeguirTienda(tienda, index);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Color(0xffae92f2),
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Color(0xffae92f2)),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
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
                ),
              ),
    );
  }
}
