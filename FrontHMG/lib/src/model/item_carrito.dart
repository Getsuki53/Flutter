import 'carrito.dart';
import 'producto.dart';

class ItemCarrito {
  final int id;
  final Carrito carrito;
  final Producto producto;
  final int unidades;
  final double subtotal;

  ItemCarrito({
    required this.id,
    required this.carrito,
    required this.producto,
    required this.unidades,
    required this.subtotal,
  });

  factory ItemCarrito.fromJson(Map<String, dynamic> json) {
    return ItemCarrito(
      id: json['id'],
      carrito: Carrito.fromJson(json['carrito']),
      producto: Producto.fromJson(json['producto']),
      unidades: json['unidades'] ?? 1,
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carrito': carrito.toJson(),
      'producto': producto.toJson(),
      'unidades': unidades,
      'subtotal': subtotal,
    };
  }

  @override
  String toString() {
    return '$unidades x ${producto.nomprod}';
  }
}
