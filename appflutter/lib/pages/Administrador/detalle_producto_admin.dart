import 'package:flutter/material.dart';
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/services/administrador/api_admin_detalle_producto.dart';
import 'package:appflutter/services/administrador/api_actualizar_estado_producto.dart';
import 'package:appflutter/services/administrador/api_eliminar_producto.dart';
import 'package:appflutter/config.dart';

class DetalleProductoAdmin extends StatefulWidget {
  final int id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String imagen;
  final int stock;
  final String categoria;

  const DetalleProductoAdmin({
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
  State<DetalleProductoAdmin> createState() => _DetalleProductoAdminState();
}

class _DetalleProductoAdminState extends State<DetalleProductoAdmin> {
  Producto? productoCompleto;
  bool isLoading = true;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _cargarDetalleProducto();
  }

  Future<void> _cargarDetalleProducto() async {
    try {
      Producto? producto = await APIDetalleProducto.detalleProducto(widget.id);
      setState(() {
        productoCompleto = producto;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error al cargar detalle del producto: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _actualizarEstadoProducto() async {
    setState(() {
      isUpdating = true;
    });

    try {
      String? mensaje =
          await APIActualizarEstadoProducto.actualizarEstadoProducto(widget.id);

      if (!mounted) return;

      if (mensaje != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(mensaje)));
        // Recargar los detalles del producto y volver con resultado exitoso
        _cargarDetalleProducto();
        Navigator.of(context).pop(true); // Devolver true para indicar éxito
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar el estado del producto'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  Future<void> _eliminarProducto() async {
    // Mostrar diálogo de confirmación
    bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
            '¿Estás seguro de que deseas eliminar este producto?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      setState(() {
        isUpdating = true;
      });

      try {
        String? mensaje = await APIEliminarProducto.eliminarProducto(widget.id);

        if (!mounted) return;

        if (mensaje != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(mensaje)));
          // Volver a la pantalla anterior con resultado exitoso
          Navigator.of(context).pop(true); // Devolver true para indicar éxito
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al eliminar el producto')),
          );
        }
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        if (mounted) {
          setState(() {
            isUpdating = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombre),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (productoCompleto != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'actualizar') {
                  _actualizarEstadoProducto();
                } else if (value == 'eliminar') {
                  _eliminarProducto();
                }
              },
              itemBuilder:
                  (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'actualizar',
                      child: Row(
                        children: [
                          Icon(
                            productoCompleto!.estado == true
                                ? Icons.check_circle
                                : Icons.cancel,
                            color:
                                productoCompleto!.estado == true
                                    ? Colors.green
                                    : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            productoCompleto!.estado == true
                                ? 'Rechazar'
                                : 'Aprobar',
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'eliminar',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Eliminar'),
                        ],
                      ),
                    ),
                  ],
            ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : productoCompleto == null
              ? const Center(child: Text('No se pudieron cargar los detalles'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen del producto
                    Center(
                      child:
                          widget.imagen.isNotEmpty
                              ? Image.network(
                                Config.buildImageUrl(widget.imagen),
                                height: 300,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 300,
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
                                height: 300,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                    ),
                    const SizedBox(height: 20),

                    // Nombre del producto
                    Text(
                      widget.nombre,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Estado del producto
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            productoCompleto!.estado == true
                                ? Colors.green
                                : Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        productoCompleto!.estado == true
                            ? 'APROBADO'
                            : 'DESHABILITADO',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Precio
                    Text(
                      '\$${widget.precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Stock
                    Row(
                      children: [
                        const Icon(Icons.inventory),
                        const SizedBox(width: 8),
                        Text(
                          'Stock: ${widget.stock}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Categoría
                    Row(
                      children: [
                        const Icon(Icons.category),
                        const SizedBox(width: 8),
                        Text(
                          'Categoría: ${widget.categoria}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Descripción
                    const Text(
                      'Descripción:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.descripcion,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 30),

                    // Botones de acción
                    if (isUpdating)
                      const Center(child: CircularProgressIndicator())
                    else
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _actualizarEstadoProducto,
                              icon: Icon(
                                productoCompleto!.estado == true
                                    ? Icons.cancel
                                    : Icons.check_circle,
                              ),
                              label: Text(
                                productoCompleto!.estado == true
                                    ? 'Rechazar'
                                    : 'Aprobar',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    productoCompleto!.estado == true
                                        ? Colors.red
                                        : Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _eliminarProducto,
                              icon: const Icon(Icons.delete),
                              label: const Text('Eliminar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
    );
  }
}
