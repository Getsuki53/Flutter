class Administrador {
  final int id;
  final String correo;
  final String contrasena;

  Administrador({
    required this.id,
    required this.correo,
    required this.contrasena,
  });

  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      id: json['id'],
      correo: json['correo'] ?? '',
      contrasena: json['contraseña'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correo': correo,
      'contraseña': contrasena,
    };
  }

  @override
  String toString() {
    return correo;
  }
}
