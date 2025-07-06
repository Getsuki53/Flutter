import 'package:flutter/material.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';
import 'package:appflutter/pages/Producto/Publicarproducto.dart';
import 'package:appflutter/services/tienda/api_detalle_tienda.dart';
import 'package:appflutter/services/productos/api_productos_x_tienda.dart';
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
    _loadTiendaId();
  }

  Future<void> _loadTiendaId() async {
    // Suponiendo que guardaste el id de la tienda en SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      tiendaId = prefs.getInt('tienda_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tiendaId == null) {
      return const Scaffold(
        // appBar: AppBar(title: Text('Mi Tienda')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Tienda')),
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
            future:
                APIObtenerListaProductosPorTienda.obtenerListaTiendasProductosPorTienda(
                  tiendaId!,
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
                                  ? NetworkImage(tienda.logo!)
                                  : const AssetImage('lib/assets/logo.png')
                                      as ImageProvider,
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
                                ),
                              ),
                              Text(tienda.descripcionTienda ?? ''),
                              Text("Productos: ${tienda.cantProductos ?? 0}"),
                              Text("Seguidores: ${tienda.cantSeguidores ?? 0}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PublicarProducto(),
                          ),
                        );
                      },
                      child: const Text('Publicar producto'),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Productos publicados:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child:
                          productos.isEmpty
                              ? const Center(
                                child: Text('No hay productos publicados.'),
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
                                                nombre: producto.nomprod,
                                                descripcion:
                                                    producto.descripcionProd,
                                                precio:
                                                    double.tryParse(
                                                      producto.precio
                                                          .toString(),
                                                    ) ??
                                                    0.0,
                                                imagen: producto.fotoProd ?? '',
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
                                        producto.fotoProd != null &&
                                                producto.fotoProd!.isNotEmpty
                                            ? Image.network(
                                              producto.fotoProd!,
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
                                                    Icons.image,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            )
                                            : Container(
                                              height: 70,
                                              width: 70,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        const SizedBox(height: 4),
                                        Text(
                                          producto.nomprod,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: const TextStyle(fontSize: 12),
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
