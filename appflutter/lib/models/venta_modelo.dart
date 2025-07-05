import 'dart:convert';
import 'usuario_modelo.dart';
import 'producto_modelo.dart';

class Venta {
  late int? id;
  late Usuario comprador;
  late Producto productoComprado;
  late int cantidad;
  late DateTime fecha;

  Venta({
    this.id,
    required this.comprador,
    required this.productoComprado,
    required this.cantidad,
    required this.fecha,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      id: json['id'] as int?,
      comprador: Usuario.fromJson(json['comprador']),
      productoComprado: Producto.fromJson(json['productoComprado']),
      cantidad: json['cantidad'] as int,
      fecha: DateTime.parse(json['fecha']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['comprador'] = comprador.toJson();
    data['productoComprado'] = productoComprado.toJson();
    data['cantidad'] = cantidad;
    data['fecha'] = fecha.toIso8601String();
    return data;
  }
}