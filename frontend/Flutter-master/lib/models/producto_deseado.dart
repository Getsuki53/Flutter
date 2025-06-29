import 'usuario.dart';
import 'producto.dart';

class ProductoDeseado {
  final int id;
  final Usuario usuario;
  final Producto producto;

  ProductoDeseado({
    required this.id,
    required this.usuario,
    required this.producto,
  });

  factory ProductoDeseado.fromJson(Map<String, dynamic> json) {
    return ProductoDeseado(
      id: json['id'],
      usuario: Usuario.fromJson(json['usuario']),
      producto: Producto.fromJson(json['producto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario.toJson(),
      'producto': producto.toJson(),
    };
  }

  @override
  String toString() {
    return '${usuario.nombre} desea ${producto.nomprod}';
  }
}
