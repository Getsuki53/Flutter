// lib/src/service/product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto.dart';

class ProductService {
  static Future<List<Producto>> fetchProducts() async {
    final response = await http.get(Uri.parse('http://localhost:8000/api/producto/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}
