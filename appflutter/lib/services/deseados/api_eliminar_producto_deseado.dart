import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de eliminar un producto a la lista de deseados de un usuario.
class APIEliminarProductoDeseado {
  static var client = http.Client();

  static Future<String?> eliminarProductoDeseado(int usuario, int producto) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productodeseadoAPI}/EliminarProductoDeseado/");

    var body = jsonEncode({
      "usuario_id": usuario,
      "producto_id": producto,
    });

    var response = await client.delete(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['message'] as String?;
    } else {
      print("Error al eliminar producto: ${response.body}");
      return null;
    }
  }
}
