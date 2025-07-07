import 'package:flutter/material.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/services/deseados/api_deseados_x_usuario.dart';
import 'package:appflutter/services/deseados/api_eliminar_producto_deseado.dart';
import 'package:appflutter/services/deseados/api_verificar_producto_deseado.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';

class WishedPage extends StatefulWidget {
  final int usuario_id;
  const WishedPage({super.key, required this.usuario_id});

  @override
  State<WishedPage> createState() => _WishedPageState();
}

class _WishedPageState extends State<WishedPage> {
  List<Producto> deseados = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDeseados();
  }

  Future<void> _cargarDeseados() async {
    print('🔍 Cargando deseados para usuario: ${widget.usuario_id}');
    setState(() {
      isLoading = true;
    });

    try {
      final productos =
          await APIObtenerListaDeseadosPorUsuario.obtenerListaDeseadosPorUsuario(
            widget.usuario_id,
          );
      print('🔍 Productos deseados obtenidos: ${productos.length}');
      for (var producto in productos) {
        print('🔍 - ${producto.nomprod} (ID: ${producto.id})');
      }
      setState(() {
        deseados = productos;
      });
    } catch (e) {
      print('❌ Error al cargar deseados: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar deseados: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _quitarDeDeseados(Producto producto, int index) async {
    try {
      final mensaje = await APIEliminarProductoDeseado.eliminarProductoDeseado(
        widget.usuario_id,
        producto.id!,
      );

      if (mensaje != null) {
        setState(() {
          deseados.removeAt(index);
        });
        // Limpiar cache para que se actualice en la página principal
        APIVerificarProductoDeseado.limpiarCache();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mensaje)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al quitar de deseados')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de deseados"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _cargarDeseados,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : deseados.isEmpty
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
                    const Text("No tienes productos deseados"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _cargarDeseados,
                      child: const Text("Recargar"),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _cargarDeseados,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: deseados.length,
                  itemBuilder: (context, index) {
                    final producto = deseados[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 241, 249, 255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          // Imagen del producto
                          Container(
                            width: 60,
                            height: 60,
                            margin: const EdgeInsets.only(right: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                producto.fotoProd ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    size: 60,
                                  );
                                },
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
                                        (_) => DetalleProducto(
                                          id: producto.id!,
                                          nombre: producto.nomprod,
                                          descripcion: producto.descripcionProd,
                                          precio: producto.precio,
                                          imagen: producto.fotoProd ?? '',
                                          stock: producto.stock,
                                          categoria: producto.tipoCategoria,
                                        ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    producto.nomprod,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$${producto.precio}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: OutlinedButton(
                              onPressed: () {
                                _quitarDeDeseados(producto, index);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.red),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: const Text(
                                'Quitar',
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
