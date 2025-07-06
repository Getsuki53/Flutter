import 'dart:convert';

List<ProductoHomeModel> productosHomeFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ProductoHomeModel>((json) => ProductoHomeModel.fromJson(json))
      .toList();
}

class ProductoHomeModel {
  late String nomprod;
  late String fotoProd;
  late double precio;

  ProductoHomeModel({
    required this.nomprod,
    required this.fotoProd,
    required this.precio,
  });

  factory ProductoHomeModel.fromJson(Map<String, dynamic> json) {
    return ProductoHomeModel(
      nomprod: json['Nomprod'] as String,
      fotoProd: json['FotoProd'] as String,
      precio: _parsePrecio(json['Precio']),
    );
  }

  // Función de utilidad para convertir a double de forma segura
  static double _parsePrecio(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Nomprod'] = nomprod;
    data['FotoProd'] = fotoProd;
    data['Precio'] = precio;
    return data;
  }
}