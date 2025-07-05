import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de agregar un producto a la lista de deseados de un usuario.
class APIAgregarProductoDeseado {
  static var client = http.Client();

  static Future<String?> agregarProductoDeseado(int usuario, int producto) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productodeseadoAPI}/AgregarProductoDeseado/");

    var body = jsonEncode({
      "usuario_id": usuario,
      "producto_id": producto,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['message'] as String?;
    } else {
      print("Error al agregar producto: ${response.body}");
      return null;
    }
  }
}
