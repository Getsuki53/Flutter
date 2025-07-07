import 'usuario_modelo.dart';

class Tienda {
  late int? id;
  late String? nomTienda;
  late String? logo;
  late String? descripcionTienda;
  late int? cantProductos;
  late int? cantSeguidores;
  late Usuario? propietario;

  Tienda({
  this.id,
  this.nomTienda,
  this.logo,
  this.descripcionTienda,
  this.cantProductos,
  this.cantSeguidores,
  this.propietario,
  });

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      id: json['id'] as int?,
      nomTienda: json['NomTienda'] as String?,
      logo: json['Logo'] as String?,
      descripcionTienda: json['DescripcionTienda'] as String?,
      cantProductos: json['Cant_productos'] as int?,
      cantSeguidores: json['Cant_seguidores'] as int?,
      propietario: json['Propietario'] is Map<String, dynamic>
    ? Usuario.fromJson(json['Propietario'])
    : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['NomTienda'] = nomTienda;
    data['Logo'] = logo;
    data['DescripcionTienda'] = descripcionTienda;
    data['CantProductos'] = cantProductos;
    data['CantSeguidores'] = cantSeguidores;
    data['Propietario'] = propietario?.toJson();
    return data;
  }
}