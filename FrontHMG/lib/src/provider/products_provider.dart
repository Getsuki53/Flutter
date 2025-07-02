import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Flutter/src/model/producto.dart';

final productsProvider = FutureProvider<List<Producto>>((ref) async {
  const int skip = 0;
  const int limit = 20;

  final response = await http.get(Uri.parse(
    "http://192.168.1.6:8000/api/producto/?skip=$skip&limit=$limit",
  ));

  if (response.statusCode == 200) {
    final List<dynamic> productsJson = json.decode(response.body);
    return productsJson.map((json) => Producto.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar productos');
  }
});
