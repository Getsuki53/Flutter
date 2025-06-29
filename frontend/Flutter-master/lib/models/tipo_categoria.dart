class TipoCategoria {
  final String nomCat;

  TipoCategoria({
    required this.nomCat,
  });

  factory TipoCategoria.fromJson(Map<String, dynamic> json) {
    return TipoCategoria(
      nomCat: json['NomCat'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NomCat': nomCat,
    };
  }

  @override
  String toString() {
    return nomCat;
  }
}
