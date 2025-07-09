import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos segun su nombre.
class APIObtenerListaProductosPorNombre {
  static var client = http.Client();

  static Future<List<Producto>> obtenerProductosPorNombre(String nombreProd) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.parse(
      Config.buildUrl(
      "${Config.productoAPI}/ObtenerProductoPorNombre/",
    ));

    var body = jsonEncode({
      "Nomprod": nombreProd,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Producto>.from(data.map((item) => Producto.fromJson(item)));
    } else if (response.statusCode == 404) {
      // No se encontraron productos
      return [];
    } else {
      print("Error al obtener productos: ${response.statusCode} - ${response.body}");
      throw Exception("Error al buscar productos: ${response.statusCode}");
    }
  }
}
