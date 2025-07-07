import 'package:flutter/material.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/services/deseados/api_deseados_x_usuario.dart';
import 'package:appflutter/services/deseados/api_eliminar_producto_deseado.dart';
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
    setState(() {
      isLoading = true;
    });

    try {
      final productos =
          await APIObtenerListaDeseadosPorUsuario.obtenerListaDeseadosPorUsuario(
            widget.usuario_id,
          );
      setState(() {
        deseados = productos;
      });
    } catch (e) {
      print('Error al cargar deseados: $e');
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
      appBar: AppBar(title: const Text("Lista de deseados")),
      body: FutureBuilder<List<Producto>>(
        future:
            APIObtenerListaDeseadosPorUsuario.obtenerListaDeseadosPorUsuario(
              widget.usuario_id,
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final deseados = snapshot.data ?? [];
          if (deseados.isEmpty) {
            return const Center(child: Text("No tienes productos deseados"));
          }
          return ListView.builder(
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
                        child: Text(
                          producto.nomprod,
                          style: const TextStyle(fontSize: 16),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Quitar de deseados',
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
      ),
    );
  }
}
