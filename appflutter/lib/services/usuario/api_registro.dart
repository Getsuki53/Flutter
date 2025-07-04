import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/usuario_modelo.dart';
import '../../config.dart';

// Esta clase se encarga del registro del usuario.
class APIRegistro {
  static var client = http.Client();

  static Future<Usuario?> registro(String correo, String nombre, String contrasena) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.usuarioAPI}/CrearUsuario/");

    var body = jsonEncode({
      "correo": correo,
      "nombre": nombre,
      "contrasena": contrasena,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      // Decodificamos el JSON y lo convertimos a un objeto Usuario
      var data = jsonDecode(response.body);
      return Usuario.fromJson(data);
    } else {
      // Puedes imprimir el error o retornarlo como mensaje
      print("Registro fallido: ${response.body}");
      return null;
    }
  }
}
