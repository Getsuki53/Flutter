import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de agregar un producto a la lista de deseados de un usuario.
class APIAgregarAlCarrito {
  static var client = http.Client();

  static Future<String?> agregarAlCarrito(int usuario, int producto, int unidades) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.carritoAPI}/AgAlCarrito/");

    var body = jsonEncode({
      "usuario_id": usuario,
      "producto_id": producto,
      "unidades": unidades,
    });
    print("usuario: $usuario, producto: $producto, unidades: $unidades");

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
