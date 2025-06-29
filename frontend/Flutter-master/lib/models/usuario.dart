class Usuario {
  final int id;
  final String correo;
  final String contraseña;
  final String nombre;
  final String apellido;
  final String? foto;
  final String? token;

  Usuario({
    required this.id,
    required this.correo,
    required this.contraseña,
    required this.nombre,
    required this.apellido,
    this.foto,
    this.token,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      correo: json['correo'] ?? '',
      contraseña: json['contraseña'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      foto: json['foto'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correo': correo,
      'contraseña': contraseña,
      'nombre': nombre,
      'apellido': apellido,
      'foto': foto,
      'token': token,
    };
  }
}
