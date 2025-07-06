import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/productoHome_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos.
class APIProductos {
  static var client = http.Client();

  static Future<List<ProductoHomeModel>> obtenerProductos() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productoAPI}");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Suponiendo que data es una lista de productos
      return List<ProductoHomeModel>.from(data.map((item) => ProductoHomeModel.fromJson(item)));
    } else {
      print("Error al obtener productos: ${response.body}");
      return [];
    }
  }
}
