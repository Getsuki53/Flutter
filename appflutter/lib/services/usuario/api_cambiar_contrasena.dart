import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga del cambio de contraseña.
class ApiCambiarContrasena {
  static var client = http.Client();

  static Future<String?> cambiarContrasena(int usuario, String nuevaContrasena) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.usuarioAPI}/CambiarContrasena/");

    var body = jsonEncode({
      "usuario_id": usuario,
      "nueva_contrasena": nuevaContrasena,
    });

    var response = await client.patch(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data.fromJson(data);
    } else {
      print("Cambio de contraseña fallido: ${response.body}");
      return null;
    }
  }
}
