import 'package:flutter/material.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/services/deseados/api_deseados_x_usuario.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';

class WishedPage extends StatelessWidget {
  final int usuarioId;
  const WishedPage({super.key, required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista de deseados")),
      body: FutureBuilder<List<Producto>>(
        future:
            APIObtenerListaDeseadosPorUsuario.obtenerListaDeseadosPorUsuario(
              usuarioId,
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
                          // Aquí deberías llamar a la API para quitar de deseados
                          // y luego actualizar el estado (si usas StatefulWidget)
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
