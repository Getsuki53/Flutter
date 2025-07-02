import 'usuario.dart';

class Carrito {
  final int id;
  final Usuario usuario;
  final DateTime creadoEn;
  final DateTime actualizadoEn;
  final double total;

  Carrito({
    required this.id,
    required this.usuario,
    required this.creadoEn,
    required this.actualizadoEn,
    required this.total,
  });

  factory Carrito.fromJson(Map<String, dynamic> json) {
    return Carrito(
      id: json['id'],
      usuario: Usuario.fromJson(json['usuario']),
      creadoEn: DateTime.parse(json['creado_en']),
      actualizadoEn: DateTime.parse(json['actualizado_en']),
      total: double.tryParse(json['total'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario.toJson(),
      'creado_en': creadoEn.toIso8601String(),
      'actualizado_en': actualizadoEn.toIso8601String(),
      'total': total,
    };
  }

  @override
  String toString() {
    return 'Carrito de ${usuario.nombre}';
  }
}
