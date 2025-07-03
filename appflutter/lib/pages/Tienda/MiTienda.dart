import 'detalle_producto.dart';
import 'PublicarProducto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Flutter/src/provider/products_provider.dart';

class MiTienda extends ConsumerWidget {
  const MiTienda({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productosAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Tienda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: productosAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (productos) {
            if (productos.isEmpty) {
              return const Center(child: Text('No hay productos publicados.'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: AssetImage('lib/assets/minimalist-landscape-to-1920x1080.jpg'),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('AndyDays', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Correo'),
                          Text('Teléfono'),
                          Text('Me gusta hacer stickers y dibujos, puedes pedirme cosas personalizadas!!'),
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
                      MaterialPageRoute(builder: (_) => const PublicarProducto()),
                    );
                  },
                  child: const Text('Publicar producto'),
                ),
                const SizedBox(height: 24),
                const Text('Productos publicados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Flexible(
                  child: GridView.builder(
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
                              builder: (_) => DetalleProducto(producto: producto),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.network(
                              producto.thumbnail,
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              producto.title,
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
            );
          },
        ),
      ),
    );
  }
}
