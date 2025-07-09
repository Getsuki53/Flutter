import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de agregar un producto a la lista de deseados de un usuario.
class APIAgregarProductoDeseado {
  static var client = http.Client();

  static Future<String?> agregarProductoDeseado(
    int usuario,
    int producto,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl(
      "${Config.productodeseadoAPI}/AgregarProductoDeseado/",
    ));

    var body = jsonEncode({"usuario_id": usuario, "producto_id": producto});

    print("🔍 DEBUG Deseados - URL: $url");
    print("🔍 DEBUG Deseados - Body: $body");

    var response = await client.post(url, headers: headers, body: body);

    print("🔍 DEBUG Deseados - Status: ${response.statusCode}");
    print("🔍 DEBUG Deseados - Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data['message'] as String?;
    } else {
      print("🚨 ERROR Deseados - Status: ${response.statusCode}");
      print("🚨 ERROR Deseados - Body: ${response.body}");
      return null;
    }
  }
}
