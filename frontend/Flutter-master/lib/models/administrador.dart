class Administrador {
  final int id;
  final String correo;
  final String contraseña;

  Administrador({
    required this.id,
    required this.correo,
    required this.contraseña,
  });

  factory Administrador.fromJson(Map<String, dynamic> json) {
    return Administrador(
      id: json['id'],
      correo: json['correo'] ?? '',
      contraseña: json['contraseña'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correo': correo,
      'contraseña': contraseña,
    };
  }

  @override
  String toString() {
    return correo;
  }
}
