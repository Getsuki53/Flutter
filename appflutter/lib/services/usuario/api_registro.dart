import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga del registro del usuario.
class APIRegistro {
  static var client = http.Client();

  static Future<String?> registro(String correo, String nombre, String apellido, String contrasena) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.usuarioAPI}/CrearUsuario/");

    var body = jsonEncode({
      "nombre": nombre,
      "apellido": apellido, // Puedes cambiar esto si necesitas un apellido
      "foto": "",
      "contrasena": contrasena,
      "correo": correo,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data.fromJson(data);
    } else {
      print("Registro fallido: ${response.body}");
      return null;
    }
  }
}
