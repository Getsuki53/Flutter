import 'dart:convert';

class TipoCategoria {
  late String NomCat;

  TipoCategoria({
    required this.NomCat,
  });

  factory TipoCategoria.fromJson(Map<String, dynamic> json) {
    return TipoCategoria(
      NomCat: json['NomCat'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['NomCat'] = NomCat;
    return data;
  }
}