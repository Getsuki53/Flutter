import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de eliminar un producto.
class APIEliminarProducto {
  static var client = http.Client();

  static Future<String?> eliminarProducto(int producto) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productoadminAPI}/EliminarProducto/?producto_id=$producto");

    var response = await client.delete(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['message'] as String?;
    } else {
      print("Error al eliminar producto: ${response.body}");
      return null;
    }
  }
}
