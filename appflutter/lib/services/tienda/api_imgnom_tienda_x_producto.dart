import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/tienda_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener solo el nombre e imagen de una tienda que subió un producto.
class APIImgNomTiendaXProducto {
  static var client = http.Client();

  static Future<Tienda?> obtenerImgNomTiendaPorProducto(int producto) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.tiendaAPI}/ObtenerImgNomTiendaPorProducto/?producto_id=$producto/");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Tienda.fromJson(data);
    } else {
      print("Error al obtener tienda: ${response.body}");
      return null;
    }
  }
}
