import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos de una tienda específica.
class APIObtenerListaProductosPorTienda {
  static var client = http.Client();

  static Future<List<Producto>> obtenerListaTiendasProductosPorTienda(int tienda) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productoAPI}/ObtenerProductosPorTienda/?tienda_id=$tienda/");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Producto>.from(data.map((item) => Producto.fromJson(item)));
    } else {
      print("Error al obtener productos: ${response.body}");
      return [];
    }
  }
}
