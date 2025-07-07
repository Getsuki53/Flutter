import 'persona_modelo.dart';

class Usuario extends Persona {
  late int? id;
  late String nombre;
  late String apellido;
  late String foto;

  Usuario({
    this.id,
    required String correo,
    required String contrasena,
    required this.nombre,
    required this.apellido,
    required this.foto,
  }) : super(
          correo: correo,
          contrasena: contrasena,
        );

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int?,
      correo: json['correo'] as String,
      contrasena: json['contrasena'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      foto: json['foto'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson(); // Incluye correo y contrasena
    data['id'] = id;
    data['nombre'] = nombre;
    data['apellido'] = apellido;
    data['foto'] = foto;
    return data;
  }
}