import 'dart:convert';
import 'usuario_modelo.dart';
import 'producto_modelo.dart';

List<Carrito> carritoFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Carrito>((json) => Carrito.fromJson(json)).toList();
}

class Carrito {
  late Usuario usuario;
  late Producto producto;
  late int unidades;
  late double valortotal;

  Carrito({
    required this.usuario,
    required this.producto,
    required this.unidades,
    required this.valortotal,
  });

  factory Carrito.fromJson(Map<String, dynamic> json) {
    return Carrito(
      usuario: Usuario.fromJson(json['usuario']),
      producto: Producto.fromJson(json['producto']),
      unidades: json['unidades'] as int,
      valortotal: (json['valortotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['usuario'] = usuario.toJson();
    data['producto'] = producto.toJson();
    data['unidades'] = unidades;
    data['valortotal'] = valortotal;
    return data;
  }
}