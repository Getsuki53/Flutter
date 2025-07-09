import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de eliminar un seguimiento de un usuario a una tienda.
class APIDejarDeSeguir {
  static var client = http.Client();

  static Future<String?> eliminarSeguimiento(int usuario, int tienda) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.http(
      Config.apiURL,
      "${Config.seguimientoDejarDeSeguirTiendaAPI}/",
    );

    var body = jsonEncode({"usuario_id": usuario, "tienda_id": tienda});

    print("🔍 DEBUG Eliminar Seguimiento - URL: $url");
    print("🔍 DEBUG Eliminar Seguimiento - Body: $body");

    try {
      var response = await client.delete(url, headers: headers, body: body);

      print("🔍 DEBUG Eliminar Seguimiento - Status: ${response.statusCode}");
      print("🔍 DEBUG Eliminar Seguimiento - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['message'] as String?;
      } else if (response.statusCode == 404) {
        // El usuario no seguía la tienda
        var data = jsonDecode(response.body);
        return data['message'] as String?;
      } else {
        print("🚨 ERROR Eliminar Seguimiento - Status: ${response.statusCode}");
        print("🚨 ERROR Eliminar Seguimiento - Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 ERROR Eliminar Seguimiento - Exception: $e");
      return null;
    }
  }
}
