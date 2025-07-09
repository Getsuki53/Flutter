import 'package:flutter/material.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/services/productos/api_productos_x_nombre.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';
import 'package:appflutter/pages/Producto/producto_propietario.dart';
import 'package:appflutter/services/tienda/api_verificar_propietario_producto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';

class ResultadosBusquedaPage extends StatefulWidget {
  final String query;

  const ResultadosBusquedaPage({
    super.key,
    required this.query,
  });

  @override
  State<ResultadosBusquedaPage> createState() => _ResultadosBusquedaPageState();
}

class _ResultadosBusquedaPageState extends State<ResultadosBusquedaPage> {
  List<Producto> productos = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  int? usuarioId;

  @override
  void initState() {
    super.initState();
    _loadUsuarioId();
    _buscarProductos();
  }

  Future<void> _loadUsuarioId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usuarioId = prefs.getInt('usuario_id');
    });
  }

  Future<void> _buscarProductos() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final resultados = await APIObtenerListaProductosPorNombre.obtenerProductosPorNombre(widget.query);
      setState(() {
        productos = resultados;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Función para construir la URL completa de la imagen
  String _buildImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    if (imagePath.startsWith('http')) return imagePath;
    // Construir URL completa usando la configuración
    return 'http://${Config.apiURL}$imagePath';
  }

  Future<void> _navegarADetalleProducto(Producto producto) async {
    // Construir la URL completa de la imagen antes de navegar
    final imageUrlCompleta = _buildImageUrl(producto.fotoProd);
    
    if (usuarioId == null || producto.id == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleProducto(
            id: producto.id!,
            nombre: producto.nomprod,
            descripcion: producto.descripcionProd,
            precio: producto.precio,
            imagen: imageUrlCompleta, // Pasar URL completa
            stock: producto.stock,
            categoria: producto.tipoCategoria,
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      bool esPropietario = await APIVerificarPropietarioProducto.verificarPropietario(
        producto.id!,
        usuarioId!,
      );

      Navigator.of(context).pop();

      if (esPropietario) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductoPropietario(
              id: producto.id!,
              nombre: producto.nomprod,
              descripcion: producto.descripcionProd,
              precio: producto.precio,
              imagen: imageUrlCompleta, // Pasar URL completa
              stock: producto.stock,
              categoria: producto.tipoCategoria,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleProducto(
              id: producto.id!,
              nombre: producto.nomprod,
              descripcion: producto.descripcionProd,
              precio: producto.precio,
              imagen: imageUrlCompleta, // Pasar URL completa
              stock: producto.stock,
              categoria: producto.tipoCategoria,
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleProducto(
            id: producto.id!,
            nombre: producto.nomprod,
            descripcion: producto.descripcionProd,
            precio: producto.precio,
            imagen: imageUrlCompleta, // Pasar URL completa
            stock: producto.stock,
            categoria: producto.tipoCategoria,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados: "${widget.query}"'),
        backgroundColor: const Color(0xff383758),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error al buscar productos',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(errorMessage),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _buscarProductos,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : productos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron productos',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text('Intenta con otro término de búsqueda'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        final producto = productos[index];
                        final imageUrl = _buildImageUrl(producto.fotoProd);
                        
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            leading: imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: const Center(
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        print('❌ Error cargando imagen: $imageUrl - $error');
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.image_not_supported),
                                        );
                                      },
                                    ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.image),
                                  ),
                            title: Text(
                              producto.nomprod,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  producto.descripcionProd,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${producto.precio}',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => _navegarADetalleProducto(producto),
                          ),
                        );
                      },
                    ),
    );
  }
}