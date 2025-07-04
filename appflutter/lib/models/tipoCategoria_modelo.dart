import 'dart:convert';

class TipoCategoria {
  late int? id;
  late String? NomCat;

  TipoCategoria({
    this.id,
    this.NomCat,
  });

  factory TipoCategoria.fromJson(Map<String, dynamic> json) {
    return TipoCategoria(
      id: json['id'] as int?,
      NomCat: json['NomCat'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['NomCat'] = NomCat;
    return data;
  }
}