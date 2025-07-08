import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de obtener la imagen y nombre de la tienda por producto.
class APITiendaPorProducto {
  static var client = http.Client();

  static Future<Map<String, dynamic>?> obtenerImgNomTiendaPorProducto(
    int productoId,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl(
        "${Config.tiendaAPI}/ObtenerImgNomTiendaPorProducto/$productoId",
      ),
    );

    print('🔍 URL tienda por producto: $url');

    var response = await client.get(url, headers: headers);

    print('🔍 Status code: ${response.statusCode}');
    print('🔍 Response body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print("❌ Error al obtener info de tienda: ${response.body}");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> obtenerTiendaPorProducto(
    int productoId,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl("${Config.tiendaAPI}/ObtenerProducto/$productoId"),
    );

    print('🔍 URL tienda completa por producto: $url');

    var response = await client.get(url, headers: headers);

    print('🔍 Status code: ${response.statusCode}');
    print('🔍 Response body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      print("❌ Error al obtener tienda completa: ${response.body}");
      return null;
    }
  }
}
