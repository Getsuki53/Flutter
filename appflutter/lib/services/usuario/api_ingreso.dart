import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/usuario_modelo.dart';
import '../../config.dart';

// Esta clase se encarga del ingreso del usuario.
class APIIngreso {
  static var client = http.Client();

  static Future<Usuario?> ingreso(String correo, String contrasena) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.loginAPI}/");

    var body = jsonEncode({
      "correo": correo,
      "contrasena": contrasena,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Decodificamos el JSON y lo convertimos a un objeto Usuario
      var data = jsonDecode(response.body);
      return Usuario.fromJson(data);
    } else {
      // Puedes imprimir el error o retornarlo como mensaje
      print("Ingreso fallido: ${response.body}");
      return null;
    }
  }
}
