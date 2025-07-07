import 'producto_modelo.dart';

class CarritoItemDetallado {
  final int id;
  final int unidades;
  final double valortotal;
  final int usuarioId;
  final int productoId;
  final Producto? producto; // Información completa del producto

  CarritoItemDetallado({
    required this.id,
    required this.unidades,
    required this.valortotal,
    required this.usuarioId,
    required this.productoId,
    this.producto,
  });

  factory CarritoItemDetallado.fromCarritoItem(Map<String, dynamic> carritoItem, Producto? producto) {
    return CarritoItemDetallado(
      id: carritoItem['id'] as int,
      unidades: carritoItem['unidades'] as int,
      valortotal: double.parse(carritoItem['valortotal'].toString()),
      usuarioId: carritoItem['usuario'] as int,
      productoId: carritoItem['producto'] as int,
      producto: producto,
    );
  }
}