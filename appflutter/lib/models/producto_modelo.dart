import 'dart:convert';
import 'tienda_modelo.dart';

class Producto {
  final int? id;
  final String nomprod;
  final String descripcionProd;
  final int stock;
  final String fotoProd;
  final double precio;
  final String tipoCategoria;
  final bool? estado;
  final DateTime? fechaPub;
  final Tienda? tienda;

  Producto({
    this.id,
    required this.nomprod,
    required this.descripcionProd,
    required this.stock,
    required this.fotoProd,
    required this.precio,
    required this.tipoCategoria,
    this.estado,
    this.fechaPub,
    this.tienda,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int?,
      nomprod: json['nomprod'] as String,
      descripcionProd: json['descripcionProd'] as String,
      stock: json['stock'] as int,
      fotoProd: json['fotoProd'] as String,
      precio: (json['precio'] as num).toDouble(),
      tipoCategoria: json['tipoCategoria'] as String,
      estado: json['estado'] as bool?,
      fechaPub: json['fechaPub'] != null
          ? DateTime.parse(json['fechaPub'])
          : null,
      tienda: json['tienda'] != null
          ? Tienda.fromJson(json['tienda'])
          : null, 
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['nomprod'] = nomprod;
    data['descripcionProd'] = descripcionProd;
    data['stock'] = stock;
    data['fotoProd'] = fotoProd;
    data['precio'] = precio;
    data['tipoCategoria'] = tipoCategoria;
    data['estado'] = estado;
    data['fechaPub'] = fechaPub?.toIso8601String();
    if (tienda != null) {
      data['tienda'] = tienda!.toJson();
    }
    return data;
  }
}