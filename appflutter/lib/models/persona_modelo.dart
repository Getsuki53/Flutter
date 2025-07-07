class Persona {
  late String? correo;
  late String? contrasena;
  
  Persona({
    this.correo,
    this.contrasena,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      correo: json['correo'] as String?,
      contrasena: json['contrasena'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['correo'] = correo;
    data['contrasena'] = contrasena;
    return data;
  }
}