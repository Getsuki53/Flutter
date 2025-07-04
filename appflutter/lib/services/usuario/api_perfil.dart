import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/usuario_modelo.dart';
import '../../config.dart';

class APIPerfil {
  static var client = http.Client();

  static Future<Usuario?> obtenerPerfil(int id) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.usuarioAPI}/perfil/$id/");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Usuario.fromJson(data);
    } else {
      print("Error al obtener perfil: ${response.body}");
      return null;
    }
  }
}
