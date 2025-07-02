class TipoCategoria {
  final int id;
  final String nomCat;

  TipoCategoria({required this.id, required this.nomCat});

  factory TipoCategoria.fromJson(Map<String, dynamic> json) {
    return TipoCategoria(
      id: json['id'],
      nomCat: json['nomCat'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomCat': nomCat,
    };
  }

  @override
  String toString() {
    return nomCat;
  }
}
