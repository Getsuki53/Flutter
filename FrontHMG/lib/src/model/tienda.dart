import 'usuario.dart';

class Tienda {
  final int id;
  final Usuario propietario;
  final String nomTienda;
  final String? logo;
  final String descripcionTienda;
  final int cantProductos;
  final int cantSeguidores;

  Tienda({
    required this.id,
    required this.propietario,
    required this.nomTienda,
    this.logo,
    required this.descripcionTienda,
    required this.cantProductos,
    required this.cantSeguidores,
  });

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      id: json['id'],
      propietario: Usuario.fromJson(json['Propietario']),
      nomTienda: json['NomTienda'] ?? '',
      logo: json['Logo'],
      descripcionTienda: json['DescripcionTienda'] ?? '',
      cantProductos: json['Cant_productos'] ?? 0,
      cantSeguidores: json['Cant_seguidores'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Propietario': propietario.toJson(),
      'NomTienda': nomTienda,
      'Logo': logo,
      'DescripcionTienda': descripcionTienda,
      'Cant_productos': cantProductos,
      'Cant_seguidores': cantSeguidores,
    };
  }

  @override
  String toString() {
    return nomTienda;
  }
}
