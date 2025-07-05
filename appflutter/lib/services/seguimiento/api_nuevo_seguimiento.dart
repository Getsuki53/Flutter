import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de agregar un seguimiento de un usuario a una tienda.
class APINuevoSeguimiento {
  static var client = http.Client();

  static Future<String?> nuevoSeguimiento(int usuario, int tienda) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.seguimientotiendaAPI}/AgregarSeguimientoTienda/");

    var body = jsonEncode({
      "usuario_id": usuario,
      "tienda_id": tienda,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['message'] as String?;
    } else {
      print("Error al agregar seguimiento: ${response.body}");
      return null;
    }
  }
}
