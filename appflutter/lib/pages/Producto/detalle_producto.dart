import 'package:flutter/material.dart';
import 'package:appflutter/services/carrito/api_agregar_al_carrito.dart';
import 'package:appflutter/services/tienda/api_imgnom_tienda_x_producto.dart';
import 'package:appflutter/pages/Tienda/DetalleTienda.dart';
import 'package:appflutter/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetalleProducto extends StatefulWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final int stock;
  final String? categoria;

  const DetalleProducto({
    super.key,
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
    required this.stock,
    required this.categoria,
  });

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  int cantidad = 1;
  Map<String, dynamic>? tiendaInfo;
  bool isLoadingTienda = true;

  @override
  void initState() {
    super.initState();
    _cargarInfoTienda();
  }

  Future<void> _cargarInfoTienda() async {
    print(
      '🔍 Iniciando carga de info de tienda para producto ID: ${widget.id}',
    );
    try {
      final tiendaData =
          await APIImgNomTiendaXProducto.obtenerImgNomTiendaPorProducto(
            widget.id,
          );
      print('🔍 Datos de tienda obtenidos: $tiendaData');
      setState(() {
        tiendaInfo = tiendaData;
        isLoadingTienda = false;
      });
      print(
        '🔍 Estado actualizado - isLoadingTienda: $isLoadingTienda, tiendaInfo: $tiendaInfo',
      );
    } catch (e) {
      print('❌ Error al cargar info de tienda: $e');
      setState(() {
        isLoadingTienda = false;
      });
    }
  }

  void aumentarCantidad() {
    if (cantidad < widget.stock) {
      setState(() {
        cantidad++;
      });
    }
  }

  void disminuirCantidad() {
    if (cantidad > 1) {
      setState(() {
        cantidad--;
      });
    }
  }

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> agregarAlCarrito() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? usuarioId = prefs.getInt('usuario_id');

    try {
      final mensaje = await APIAgregarAlCarrito.agregarAlCarrito(
        usuarioId!,
        widget.id,
        cantidad,
      );
      if (mensaje != null) {
        if (cantidad > 1) {
          showSnackbar("$cantidad productos agregados al carrito");
        } else {
          showSnackbar("$cantidad producto agregado al carrito");
        }
      } else {
        showSnackbar("Error al agregar al carrito $mensaje");
      }
    } catch (e) {
      showSnackbar("Error de conexión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1e2a),
      appBar: AppBar(title: Text(widget.nombre, style: const TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff383758),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.imagen,
                height: 350,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
           
            const SizedBox(height: 8),
            // Logo y nombre de la tienda
            if (isLoadingTienda)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Cargando información de la tienda...'),
                  ],
                ),
              )
            else if (tiendaInfo != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: InkWell(
                  onTap: () async {
                    // Ya tenemos la tienda completa, podemos navegar directamente
                    if (tiendaInfo?['tienda_id'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => DetalleTienda(
                                tiendaId: tiendaInfo!['tienda_id'],
                              ),
                        ),
                      );
                    } else {
                      showSnackbar(
                        'Error: No se pudo obtener el ID de la tienda',
                      );
                    }
                  },
                  child: Row(
                    children: [
                      // Logo de la tienda
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            Config.buildImageUrl(tiendaInfo!['imagen'] ?? ''),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.store,
                                size: 20,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Información de la tienda
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tiendaInfo!['nombre'] ?? 'Tienda',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Ver tienda',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No se pudo cargar la información de la tienda',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(widget.descripcion, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Text(
              'Precio: \$${widget.precio}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text('Stock disponible: ${widget.stock}', 
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: disminuirCantidad,
                  icon: const Icon(Icons.remove, color: Colors.white,),
                ),
                Text('$cantidad', style: const TextStyle(fontSize: 18)),
                IconButton(
                  onPressed: aumentarCantidad,
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffe8d0f8), Color(0xffae92f2), Color(0xff9dd5f3)],
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
                      agregarAlCarrito();
                    },
                    child: const Center(
                      child: Text(
                        'Agregar al carrito',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
