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

  ProductoDeseado({this.id, required this.usuario, required this.producto});

  factory ProductoDeseado.fromJson(Map<String, dynamic> json) {
    // Manejar usuario como ID o como objeto
    Usuario usuario;
    if (json['usuario'] is int) {
      // Si es un ID, crear un Usuario básico con solo el ID
      usuario = Usuario(
        id: json['usuario'],
        correo: '',
        contrasena: '',
        nombre: '',
        apellido: '',
        foto: '',
      );
    } else {
      // Si es un objeto, usar fromJson normal
      usuario = Usuario.fromJson(json['usuario']);
    }

    // Manejar producto como ID o como objeto
    Producto producto;
    if (json['producto'] is int) {
      // Si es un ID, crear un Producto básico con solo el ID
      producto = Producto(
        id: json['producto'],
        nomprod: '',
        descripcionProd: '',
        stock: 0,
        precio: 0.0,
        tipoCategoria: '',
      );
    } else {
      // Si es un objeto, usar fromJson normal
      producto = Producto.fromJson(json['producto']);
    }

    return ProductoDeseado(
      id: json['id'] as int?,
      usuario: usuario,
      producto: producto,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['usuario'] = usuario.toJson();
    data['producto'] = producto.toJson();
    return data;
  }
}
