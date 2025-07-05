import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/usuario_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener los usuarios registrados.
class APIObtenerUsuarios {
  static var client = http.Client();

  static Future<Usuario?> obtenerUsuarios() async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.usuarioAPI}");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Usuario.fromJson(data);
    } else {
      print("Error al obtener usuarios: ${response.body}");
      return null;
    }
  }
}
