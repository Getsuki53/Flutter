import 'package:flutter/material.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';
import 'package:appflutter/pages/Producto/Publicarproducto.dart';
import 'package:appflutter/services/tienda/api_detalle_tienda.dart';
import 'package:appflutter/services/productos/api_productos_x_tienda.dart';
import 'package:appflutter/services/tienda/api_tienda_por_propietario.dart';
import 'package:appflutter/models/tienda_modelo.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MiTienda extends StatefulWidget {
  const MiTienda({super.key});

  @override
  State<MiTienda> createState() => _MiTiendaState();
}

class _MiTiendaState extends State<MiTienda> {
  int? tiendaId;

  @override
  void initState() {
    super.initState();
    _loadTienda();
  }

  Future<void> _loadTienda() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Suponiendo que tienes guardado el usuario_id en SharedPreferences
    int? usuarioId = prefs.getInt('usuario_id');
    if (usuarioId == null) {
      // Si no hay usuario, podrías redirigir a login o mostrar error
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    // Usar la API para obtener la tienda por propietario
    final tienda = await APIObtenerTiendaPorPropietario.obtenerTiendaPorPropietario(usuarioId);

    if (tienda != null && tienda.id != null) {
      setState(() {
        tiendaId = tienda.id;
      });

    } else {
      // Si no tiene tienda, redirigir a crear tienda
      Navigator.pushReplacementNamed(context, '/crearTienda');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tiendaId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mi Tienda'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xff1f1e2a),
      appBar: AppBar(
        backgroundColor: Color(0xff383758),
        title: const Text('Mi Tienda',
          style: TextStyle(color: Colors.white,),)
      ),
      body: FutureBuilder<Tienda?>(
        future: APIDetalleTienda.detalleTienda(tiendaId!),
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
            future: APIObtenerListaProductosPorTienda.obtenerListaTiendasProductosPorTienda(tiendaId!),
            builder: (context, productosSnapshot) {
              if (productosSnapshot.connectionState == ConnectionState.waiting) {
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
                          backgroundImage: (tienda.logo != null && tienda.logo!.isNotEmpty)
                              ? NetworkImage(tienda.logo!)
                              : const AssetImage('lib/assets/logo.png') as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tienda.nomTienda ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text(tienda.descripcionTienda ?? '', style: const TextStyle(fontSize: 14, color: Colors.white)),
                              Text("Productos: ${tienda.cantProductos ?? 0}", style: const TextStyle(fontSize: 14, color: Colors.white)),
                              Text("Seguidores: ${tienda.cantSeguidores ?? 0}", style: const TextStyle(fontSize: 14, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffe8d0f8),
                            Color(0xffae92f2),
                            Color(0xff9dd5f3),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PublicarProducto()),
                        );
                      },
                          child: Center(
                            child: Text(
                              'Publicar producto',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Productos publicados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    Expanded(
                      child: productos.isEmpty
                          ? const Center(child: Text('No hay productos publicados.'))
                          : GridView.builder(
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
                                          id: producto.id!,
                                          nombre: producto.nomprod,
                                          descripcion: producto.descripcionProd,
                                          precio: double.tryParse(producto.precio.toString()) ?? 0.0,
                                          imagen: producto.fotoProd,
                                          stock: int.tryParse(producto.stock.toString()) ?? 0,
                                          categoria: producto.tipoCategoria.toString(),
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
