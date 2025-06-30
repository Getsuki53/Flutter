import 'tipocategoria.dart';
import 'tienda.dart';

class Producto {
  final int id;
  final String nomprod;
  final String descripcionProd;
  final int stock;
  final String? fotoProd;
  final double precio;
  final String tipoCategoria; // Ahora es String
  final bool estado;
  final DateTime fechaPub;
  final int tienda; // Ahora es int

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
      tipoCategoria: json['tipoCategoria'] ?? '',
      estado: json['Estado'] ?? false,
      fechaPub: DateTime.parse(json['FechaPub']),
      tienda: json['tienda'] is int
          ? json['tienda']
          : int.tryParse(json['tienda'].toString()) ?? 0,
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
      'tipoCategoria': tipoCategoria,
      'Estado': estado,
      'FechaPub': fechaPub.toIso8601String(),
      'tienda': tienda,
    };
  }

  @override
  String toString() {
    return nomprod;
  }
}
