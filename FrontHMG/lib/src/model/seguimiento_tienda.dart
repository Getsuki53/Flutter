import 'usuario.dart';
import 'tienda.dart';

class SeguimientoTienda {
  final int id;
  final Usuario usuario;
  final Tienda tienda;

  SeguimientoTienda({
    required this.id,
    required this.usuario,
    required this.tienda,
  });

  factory SeguimientoTienda.fromJson(Map<String, dynamic> json) {
    return SeguimientoTienda(
      id: json['id'],
      usuario: Usuario.fromJson(json['usuario']),
      tienda: Tienda.fromJson(json['tienda']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario.toJson(),
      'tienda': tienda.toJson(),
    };
  }

  @override
  String toString() {
    return '${usuario.nombre} sigue a ${tienda.nomTienda}';
  }
}
