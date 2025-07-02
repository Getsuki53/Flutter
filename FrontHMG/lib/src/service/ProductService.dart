import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Flutter/src/model/producto.dart';

class ProductService {
  static Future<List<Producto>> fetchProducts() async {
    //AQUI CAMBIEN A SU IP 
    final response = await http.get(Uri.parse('http://192.168.1.6:8000/api/producto/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Producto.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}
