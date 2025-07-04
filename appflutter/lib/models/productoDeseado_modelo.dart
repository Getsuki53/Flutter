import 'dart:convert';
import 'producto_modelo.dart';
import 'usuario_modelo.dart';

List<ProductoDeseado> productosDeseadosFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ProductoDeseado>((json) => ProductoDeseado.fromJson(json))
      .toList();
}

class ProductoDeseado {
  late int? id;
  late Usuario usuario;
  late Producto producto;

  ProductoDeseado({
    this.id,
    required this.usuario,
    required this.producto,
  });

  factory ProductoDeseado.fromJson(Map<String, dynamic> json) {
    return ProductoDeseado(
      id: json['id'] as int?,
      usuario: Usuario.fromJson(json['usuario']),
      producto: Producto.fromJson(json['productoDeseado']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['usuario'] = usuario.toJson();
    data['productoDeseado'] = producto.toJson();
    return data;
  }
}
