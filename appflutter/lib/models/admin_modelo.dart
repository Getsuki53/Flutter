import 'persona_modelo.dart';

class Administrador extends Persona {
  late int? id;

  Administrador({
    this.id,
    required String correo,
    required String contrasena,
  }): super(
          correo: correo,
          contrasena: contrasena,
        );


  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      id: json['id'] as int?,
      correo: json['correo'] as String,
      contrasena: json['contrasena'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson(); // Incluye correo y contrasena
    data['id'] = id;
    return data;
  }
}