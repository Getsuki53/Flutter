import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de eliminar un seguimiento de un usuario a una tienda.
class APIDejarDeSeguir {
  static var client = http.Client();

  static Future<String?> eliminarSeguimiento(int usuario, int tienda) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.parse(Config.buildUrl("${Config.seguimientotiendaAPI}/DejarDeSeguirTienda/")); // ✅ Cambiar Uri.http por Uri.parse

    var body = jsonEncode({
      "usuario_id": usuario,
      "tienda_id": tienda,
    });

    var response = await client.delete(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['message'] as String?;
    } else {
      print("Error al eliminar seguimiento: ${response.body}");
      return null;
    }
  }
}
