import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener los detalles de un producto.
class APIDetalleProducto {
  static var client = http.Client();

  static Future<Producto?> detalleProducto(int producto) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productoadminAPI}/ObtenerProductoMain/?producto_id=$producto/");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Producto.fromJson(data);
    } else {
      print("Error al obtener detalles del producto: ${response.body}");
      return null;
    }
  }
}
