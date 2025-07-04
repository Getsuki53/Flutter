import 'dart:convert';
import 'persona_modelo.dart';

class Administrador {
  late int? id;
  late String correo;
  late String contrasena;

  Administrador({
    this.id,
    required this.correo,
    required this.contrasena,
  });

  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      id: json['id'] as int?,
      correo: json['correo'] as String,
      contrasena: json['contrasena'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['correo'] = correo;
    data['contrasena'] = contrasena;
    return data;
  }
}