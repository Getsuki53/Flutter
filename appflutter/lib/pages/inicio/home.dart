import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';
import 'package:appflutter/pages/Producto/producto_propietario.dart';
import 'package:appflutter/services/productos/api_productos.dart';
import 'package:appflutter/services/deseados/api_agregar_producto_deseado.dart';
import 'package:appflutter/services/deseados/api_eliminar_producto_deseado.dart';
import 'package:appflutter/services/deseados/api_verificar_producto_deseado.dart';
import 'package:appflutter/services/tienda/api_verificar_propietario_producto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'barra_superior.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
         controller: searchController,
        //onCartPressed: _onCartPressed,
      ),
      body: ProductList(),
      backgroundColor: Colors.white,
    );
  }
}

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Producto>>(
      future: APIProductos.obtenerProductos(),
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
  bool isLoading = false;
  int? usuarioId;

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
    if (usuarioId != null && widget.product.id != null) {
      _verificarEstadoFavorito();
    }
  }

  Future<void> _verificarEstadoFavorito() async {
    try {
      bool esFavorito =
          await APIVerificarProductoDeseado.verificarProductoDeseadoConCache(
        usuarioId!,
        widget.product.id!,
      );
      setState(() {
        isFavorite = esFavorito;
      });
      print(
        '🔍 Producto ${widget.product.nomprod} ${esFavorito ? "SÍ" : "NO"} está en favoritos',
      );
    } catch (e) {
      print('❌ Error al verificar estado de favorito: $e');
    }
  }

  Future<void> toggleFavorite() async {
    if (usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Usuario no identificado')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String? mensaje;
      if (isFavorite) {
        mensaje = await APIEliminarProductoDeseado.eliminarProductoDeseado(
          usuarioId!,
          widget.product.id!,
        );
      } else {
        mensaje = await APIAgregarProductoDeseado.agregarProductoDeseado(
          usuarioId!,
          widget.product.id!,
        );
      }

      if (mensaje != null) {
        setState(() {
          isFavorite = !isFavorite;
        });
        APIVerificarProductoDeseado.limpiarCache();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensaje)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite
                  ? 'Error al quitar de favoritos'
                  : 'Error al agregar a favoritos',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _navegarADetalleProducto() async {
    if (usuarioId == null || widget.product.id == null) {
      // Si no hay usuario logueado, ir a detalle normal
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleProducto(
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
      return;
    }

    // Mostrar indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Verificar si el usuario es propietario del producto
      bool esPropietario = await APIVerificarPropietarioProducto.verificarPropietario(
        widget.product.id!,
        usuarioId!,
      );

      // Cerrar indicador de carga
      Navigator.of(context).pop();

      if (esPropietario) {
        // Es propietario: ir a vista de propietario
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductoPropietario(
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
      } else {
        // No es propietario: ir a detalle normal
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleProducto(
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
      }
    } catch (e) {
      // Cerrar indicador de carga si hay error
      Navigator.of(context).pop();
      
      print('❌ Error al verificar propietario: $e');
      
      // En caso de error, ir a detalle normal
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleProducto(
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _navegarADetalleProducto,
      child: Container(
        height: size.height,
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                // Solo comprobamos si la cadena no está vacía
                (widget.product.fotoProd).isNotEmpty
                    ? Image.network(
                        widget.product.fotoProd,
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
                    onTap: isLoading ? null : toggleFavorite,
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
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                              ),
                            )
                          : Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
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
