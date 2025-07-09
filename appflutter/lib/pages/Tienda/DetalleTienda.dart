import 'package:flutter/material.dart';
import 'package:appflutter/models/tienda_modelo.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/services/tienda/api_detalle_tienda.dart';
import 'package:appflutter/services/productos/api_productos_x_tienda.dart';
import 'package:appflutter/services/seguimiento/api_verificar_seguimiento.dart';
import 'package:appflutter/services/seguimiento/api_nuevo_seguimiento.dart';
import 'package:appflutter/services/seguimiento/api_eliminar_seguimiento.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';
import 'package:appflutter/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetalleTienda extends StatefulWidget {
  final int tiendaId;
  const DetalleTienda({super.key, required this.tiendaId});

  @override
  State<DetalleTienda> createState() => _DetalleTiendaState();
}

class _DetalleTiendaState extends State<DetalleTienda> {
  int? usuarioId;
  bool esSeguida = false;
  bool isLoadingSeguimiento = true;

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
      await _verificarSeguimiento();
    }
  }

  Future<void> _verificarSeguimiento() async {
    if (usuarioId == null) return;

    try {
      final seguida = await APIVerificarSeguimiento.verificarSeguimiento(
        usuarioId!,
        widget.tiendaId,
      );
      setState(() {
        esSeguida = seguida;
        isLoadingSeguimiento = false;
      });
    } catch (e) {
      print('Error al verificar seguimiento: $e');
      setState(() {
        isLoadingSeguimiento = false;
      });
    }
  }

  Future<void> _toggleSeguimiento() async {
    if (usuarioId == null) return;

    setState(() {
      isLoadingSeguimiento = true;
    });

    try {
      String? resultado;
      if (esSeguida) {
        print(
          '🔍 DETALLE TIENDA - Intentando dejar de seguir tienda ID: ${widget.tiendaId}',
        );
        resultado = await APIDejarDeSeguir.eliminarSeguimiento(
          usuarioId!,
          widget.tiendaId,
        );
      } else {
        print(
          '🔍 DETALLE TIENDA - Intentando seguir tienda ID: ${widget.tiendaId}',
        );
        resultado = await APINuevoSeguimiento.nuevoSeguimiento(
          usuarioId!,
          widget.tiendaId,
        );
      }

      print('🔍 DETALLE TIENDA - Resultado: $resultado');

      if (resultado != null) {
        setState(() {
          esSeguida = !esSeguida;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(resultado)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: No se recibió respuesta del servidor. Revisa los logs de debug.',
            ),
          ),
        );
      }
    } catch (e) {
      print('🚨 DETALLE TIENDA - Error al cambiar seguimiento: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
    } finally {
      setState(() {
        isLoadingSeguimiento = false;
      });
    }
  }

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1e2a),
      appBar: AppBar(title: const Text('Perfil de la Tienda',
        style: TextStyle(color: Colors.white),),
      backgroundColor: const Color(0xff383758)),
      body: FutureBuilder<Tienda?>(
        future: APIDetalleTienda.detalleTienda(widget.tiendaId),
        builder: (context, tiendaSnapshot) {
          if (tiendaSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (tiendaSnapshot.hasError) {
            return Center(child: Text('Error: ${tiendaSnapshot.error}'));
          }
          final tienda = tiendaSnapshot.data;
          if (tienda == null) {
            return const Center(child: Text('No se pudo cargar la tienda.'));
          }

          return FutureBuilder<List<Producto>>(
            future:
                APIObtenerListaProductosPorTienda.obtenerListaTiendasProductosPorTienda(
                  widget.tiendaId,
                ),
            builder: (context, productosSnapshot) {
              if (productosSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (productosSnapshot.hasError) {
                return Center(child: Text('Error: ${productosSnapshot.error}'));
              }
              final productos = productosSnapshot.data ?? [];

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage:
                              (tienda.logo != null && tienda.logo!.isNotEmpty)
                                  ? NetworkImage(
                                    tienda.logo!.startsWith('http')
                                        ? tienda.logo!
                                        : Config.buildImageUrl(tienda.logo!),
                                  )
                                  : null,
                          child:
                              (tienda.logo == null || tienda.logo!.isEmpty)
                                  ? const Icon(
                                    Icons.store,
                                    size: 45,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tienda.nomTienda ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(tienda.descripcionTienda ?? '', style: TextStyle(color: Colors.white),),
                              Text("Productos: ${tienda.cantProductos ?? 0}", style: TextStyle(color: Colors.white)),
                              Text("Seguidores: ${tienda.cantSeguidores ?? 0}", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Botón de seguir/dejar de seguir
                    if (usuarioId != null)
                      Center(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: esSeguida
                                  ? [Color(0xffe8d0f8), Color(0xffae92f2), Color(0xff9dd5f3)]
                                  : [Color(0xff3344aa), Color(0xff9dd5f3), Color(0xff3344aa)], 
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: isLoadingSeguimiento ? null : _toggleSeguimiento,
                              child: Center(
                                child: isLoadingSeguimiento
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            esSeguida ? Icons.favorite : Icons.favorite_border,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            esSeguida ? 'Siguiendo' : 'Seguir',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    const Text(
                      'Productos publicados:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child:
                          productos.isEmpty
                              ? const Center(
                                child: Text('No hay productos publicados.', 
                                  style: TextStyle(color: Colors.white)),
                              )
                              : GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                                          builder:
                                              (_) => DetalleProducto(
                                                id: producto.id!,
                                                nombre: producto.nomprod,
                                                descripcion:
                                                    producto.descripcionProd,
                                                precio:
                                                    double.tryParse(
                                                      producto.precio
                                                          .toString(),
                                                    ) ??
                                                    0.0,
                                                imagen: producto.fotoProd,
                                                stock:
                                                    int.tryParse(
                                                      producto.stock.toString(),
                                                    ) ??
                                                    0,
                                                categoria:
                                                    producto.tipoCategoria
                                                        .toString(),
                                              ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Image.network(
                                          producto.fotoProd,
                                          height: 70,
                                          width: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              height: 70,
                                              width: 70,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          producto.nomprod,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
