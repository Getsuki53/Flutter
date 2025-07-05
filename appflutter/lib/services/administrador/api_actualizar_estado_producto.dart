import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de aprobar un producto.
class APIActualizarEstadoProducto {
  static var client = http.Client();

  static Future<String?> actualizarEstadoProducto(int producto) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productoadminAPI}/ActualizarEstadoProducto/");

    var body = jsonEncode({
      "pk": producto,
    });

    var response = await client.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['message'] as String?;
    } else {
      print("Error al cambiar estado del producto: ${response.body}");
      return null;
    }
  }
}
