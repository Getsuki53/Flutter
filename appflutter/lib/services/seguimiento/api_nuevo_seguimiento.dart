import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de agregar un seguimiento de un usuario a una tienda.
class APINuevoSeguimiento {
  static var client = http.Client();

  static Future<String?> nuevoSeguimiento(int usuario, int tienda) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl(
      "${Config.seguimientoAgregarSeguimientoTiendaAPI}/",
    ));

    var body = jsonEncode({"usuario_id": usuario, "tienda_id": tienda});

    print("🔍 DEBUG Nuevo Seguimiento - URL: $url");
    print("🔍 DEBUG Nuevo Seguimiento - Body: $body");

    try {
      var response = await client.post(url, headers: headers, body: body);

      print("🔍 DEBUG Nuevo Seguimiento - Status: ${response.statusCode}");
      print("🔍 DEBUG Nuevo Seguimiento - Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        return data['message'] as String?;
      } else {
        print("🚨 ERROR Nuevo Seguimiento - Status: ${response.statusCode}");
        print("🚨 ERROR Nuevo Seguimiento - Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 ERROR Nuevo Seguimiento - Exception: $e");
      return null;
    }
  }
}
