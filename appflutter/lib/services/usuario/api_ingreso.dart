import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga del ingreso del usuario.
class APIIngreso {
  static var client = http.Client();

  static Future<String?> ingresoUsuario(String correo, String contrasena) async {
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
      var data = jsonDecode(response.body);
      return data['mensaje'] as String? ?? data['message'] as String?;
    } else {

      // Intentar autenticación de administrador
      var adminUrl = Uri.http(Config.apiURL, "${Config.administradorAPI}/AutenticacionarAdministrador/");
      
      var adminResponse = await client.post(adminUrl, headers: headers, body: body);

      if (adminResponse.statusCode == 200) {
        var data = jsonDecode(adminResponse.body);
        return data['mensaje'] as String? ?? data['message'] as String?;
      } else {
        print("Ingreso fallido: ${response.body}");
        print("Ingreso administrador fallido: ${adminResponse.body}");
        return null;
      }
    }
  }
}
