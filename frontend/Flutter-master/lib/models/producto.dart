import 'tipocategoria.dart';
import 'tienda.dart';

class Producto {
  final int id;
  final String nomprod;
  final String descripcionProd;
  final int stock;
  final String? fotoProd;
  final double precio;
  final TipoCategoria tipoCategoria;
  final bool estado;
  final DateTime fechaPub;
  final Tienda tienda;

  Producto({
    required this.id,
    required this.nomprod,
    required this.descripcionProd,
    required this.stock,
    this.fotoProd,
    required this.precio,
    required this.tipoCategoria,
    required this.estado,
    required this.fechaPub,
    required this.tienda,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nomprod: json['Nomprod'] ?? '',
      descripcionProd: json['DescripcionProd'] ?? '',
      stock: json['Stock'] ?? 0,
      fotoProd: json['FotoProd'],
      precio: double.tryParse(json['Precio'].toString()) ?? 0.0,
      tipoCategoria: TipoCategoria.fromJson(json['tipoCategoria']),
      estado: json['Estado'] ?? false,
      fechaPub: DateTime.parse(json['FechaPub']),
      tienda: Tienda.fromJson(json['tienda']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Nomprod': nomprod,
      'DescripcionProd': descripcionProd,
      'Stock': stock,
      'FotoProd': fotoProd,
      'Precio': precio,
      'tipoCategoria': tipoCategoria.toJson(),
      'Estado': estado,
      'FechaPub': fechaPub.toIso8601String(),
      'tienda': tienda.toJson(),
    };
  }

  @override
  String toString() {
    return nomprod;
  }
}
