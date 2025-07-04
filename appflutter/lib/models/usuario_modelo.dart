import 'dart:convert';
import 'persona_modelo.dart';

class Usuario extends Persona {
  late int? id;
  late String? correo;
  late String? contrasena;
  late String? nombre;
  late String? apellido;
  late String? foto;
  late String? token;

  Usuario({
    this.id,
    this.correo,
    this.contrasena,
    this.nombre,
    this.apellido,
    this.foto,
    this.token,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int?,
      correo: json['correo'] as String?,
      contrasena: json['contrasena'] as String?,
      nombre: json['nombre'] as String?,
      apellido: json['apellido'] as String?,
      foto: json['foto'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['correo'] = correo;
    data['contrasena'] = contrasena;
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['foto'] = foto;
    data['token'] = token;
    return data;
  }
}