import 'usuario.dart';
import 'carrito.dart';

class Pago {
  final int id;
  final Usuario usuario;
  final Carrito carrito;
  final String estado;
  final String? preferenceId;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  // Estados disponibles
  static const String PENDIENTE = 'pendiente';
  static const String APROBADO = 'aprobado';
  static const String RECHAZADO = 'rechazado';

  Pago({
    required this.id,
    required this.usuario,
    required this.carrito,
    required this.estado,
    this.preferenceId,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  factory Pago.fromJson(Map<String, dynamic> json) {
    return Pago(
      id: json['id'],
      usuario: Usuario.fromJson(json['usuario']),
      carrito: Carrito.fromJson(json['carrito']),
      estado: json['estado'] ?? PENDIENTE,
      preferenceId: json['preference_id'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaActualizacion: DateTime.parse(json['fecha_actualizacion']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario': usuario.toJson(),
      'carrito': carrito.toJson(),
      'estado': estado,
      'preference_id': preferenceId,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion.toIso8601String(),
    };
  }

  bool get esPendiente => estado == PENDIENTE;
  bool get esAprobado => estado == APROBADO;
  bool get esRechazado => estado == RECHAZADO;

  @override
  String toString() {
    return 'Pago de ${usuario.nombre} ($estado)';
  }
}
