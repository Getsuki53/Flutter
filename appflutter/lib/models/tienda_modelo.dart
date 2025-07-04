import 'dart:convert';
import 'usuario_modelo.dart';

class Tienda {
  late int? id;
  late Usuario? propietario;
  late String? nomTienda;
  late String? logo;
  late String? descripcionTienda;
  late int? cantProductos;
  late int? cantSeguidores;

  Tienda({
    this.id,
    this.propietario,
    this.nomTienda,
    this.logo,
    this.descripcionTienda,
    this.cantProductos,
    this.cantSeguidores,
  });

  factory Tienda.fromJson(Map<String, dynamic> json) {
    return Tienda(
      id: json['id'] as int?,
      propietario: json['propietario'] != null
          ? Usuario.fromJson(json['propietario'])
          : null,
      nomTienda: json['nomTienda'] as String?,
      logo: json['logo'] as String?,
      descripcionTienda: json['descripcionTienda'] as String?,
      cantProductos: json['cantProductos'] as int?,
      cantSeguidores: json['cantSeguidores'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['propietario'] = propietario?.toJson();
    data['nomTienda'] = nomTienda;
    data['logo'] = logo;
    data['descripcionTienda'] = descripcionTienda;
    data['cantProductos'] = cantProductos;
    data['cantSeguidores'] = cantSeguidores;
    return data;
  }
}