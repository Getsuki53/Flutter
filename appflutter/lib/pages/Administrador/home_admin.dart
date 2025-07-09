import 'package:flutter/material.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/pages/Administrador/detalle_producto_admin.dart';
import 'package:appflutter/services/administrador/api_productos_admin.dart';

class HomeAdminView extends StatefulWidget {
  const HomeAdminView({super.key});

  @override
  State<HomeAdminView> createState() => _HomeAdminViewState();
}

class _HomeAdminViewState extends State<HomeAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Productos')),
      body: ProductAdminList(
        onRefresh: () {
          // Refrescar la pantalla
          setState(() {});
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}

class ProductAdminList extends StatelessWidget {
  const ProductAdminList({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Producto>>(
      future: APIProductosAdmin.obtenerProductosPendientes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        final products = snapshot.data;
        if (products == null || products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
                SizedBox(height: 16),
                Text(
                  "¡Excelente!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "No hay productos pendientes de aprobación",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        return PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductAdminListTile(
              product: products[index],
              onRefresh: onRefresh,
            );
          },
        );
      },
    );
  }
}

class ProductAdminListTile extends StatefulWidget {
  const ProductAdminListTile({
    super.key,
    required this.product,
    required this.onRefresh,
  });
  final Producto product;
  final VoidCallback onRefresh;

  @override
  State<ProductAdminListTile> createState() => _ProductAdminListTileState();
}

class _ProductAdminListTileState extends State<ProductAdminListTile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () async {
        // Navegar a detalles y esperar el resultado
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => DetalleProductoAdmin(
                  id: widget.product.id!,
                  nombre: widget.product.nomprod,
                  descripcion: widget.product.descripcionProd,
                  precio: widget.product.precio,
                  imagen: widget.product.fotoProd,
                  stock: widget.product.stock,
                  categoria: widget.product.tipoCategoria,
                ),
          ),
        );

        // Si se eliminó o aprobó el producto, refrescar la lista
        if (result == true) {
          widget.onRefresh();
        }
      },
      child: Container(
        height: size.height,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Solo la imagen del producto, sin botón de favoritos
            (widget.product.fotoProd.isNotEmpty)
                ? Image.network(
                  widget.product.fotoProd,
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Reemplazamos print con debugPrint para desarrollo
                    debugPrint(
                      '🚨 ERROR homeAdmin - No se pudo cargar imagen: ${widget.product.fotoProd}',
                    );
                    debugPrint('🚨 ERROR homeAdmin - Error: $error');
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
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
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
            const SizedBox(height: 10),
            // Indicador de estado del producto
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color:
                    widget.product.estado == true
                        ? Colors.green
                        : widget.product.estado == false
                        ? Colors.red
                        : Colors.orange,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                widget.product.estado == true
                    ? 'APROBADO'
                    : widget.product.estado == false
                    ? 'PENDIENTE'
                    : 'PENDIENTE',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
