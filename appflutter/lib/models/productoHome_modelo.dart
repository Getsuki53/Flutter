import 'dart:convert';
import 'producto_modelo.dart';

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
      nomprod: json['nomprod'] as String,
      fotoProd: json['fotoProd'] as String,
      precio: (json['precio'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nomprod'] = nomprod;
    data['fotoProd'] = fotoProd;
    data['precio'] = precio;
    return data;
  }
}