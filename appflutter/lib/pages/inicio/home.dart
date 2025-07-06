import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';
import 'package:appflutter/services/productos/api_productos.dart';

Future<List<Producto>> fetchProductos() async {
  return await APIProductos.obtenerProductos();
}

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: const ProductList(), backgroundColor: Colors.white);
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Producto>>(
      future: fetchProductos(), // Cambia aquí por tu función real
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final products = snapshot.data;
        if (products == null || products.isEmpty) {
          return const Center(child: Text("No hay productos disponibles."));
        }

        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductListTile(product: products[index]);
          },
        );
      },
    );
  }
}

class ProductListTile extends StatefulWidget {
  const ProductListTile({super.key, required this.product});

  final Producto product;

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      // Aquí puedes guardar/eliminar el producto de una lista real
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => DetalleProducto(
                  nombre: widget.product.nomprod,
                  descripcion: widget.product.descripcionProd,
                  precio: widget.product.precio,
                  imagen: widget.product.fotoProd ?? '',
                  stock: widget.product.stock,
                  categoria: widget.product.tipoCategoria,
                ),
          ),
        );
      },
      child: Container(
        height: size.height,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                widget.product.fotoProd != null &&
                        widget.product.fotoProd!.isNotEmpty
                    ? Image.network(
                      widget.product.fotoProd!,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                    : Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: toggleFavorite,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isFavorite ? Colors.red : Colors.white,
                        border: Border.all(
                          color: isFavorite ? Colors.red : Colors.black,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.white : Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.product.nomprod,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "\$${widget.product.precio}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
