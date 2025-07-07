import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';

// Esta clase se encarga del ingreso del usuario.
class APIIngreso {
  static var client = http.Client();

  static Future<String?> ingresoUsuario(String correo, String contrasena) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.parse(Config.buildUrl(Config.loginAPI)); // ✅ Cambiar de Uri.http a Uri.parse

    var body = jsonEncode({
      "correo": correo,
      "contrasena": contrasena,
    });

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // ✅ GUARDAR usuario_id si existe
      if (data.containsKey('usuario_id')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('usuario_id', data['usuario_id']);
        print('usuario_id guardado: ${data['usuario_id']}');
      }

      return data['mensaje'] as String? ?? data['message'] as String?;
    } else {
      // Intentar autenticación de administrador
      var adminUrl = Uri.parse(Config.buildUrl("${Config.administradorAPI}/AutenticacionarAdministrador/")); // ✅ También cambiar aquí

      var adminResponse = await client.post(adminUrl, headers: headers, body: body);

      if (adminResponse.statusCode == 200) {
        var data = jsonDecode(adminResponse.body);

        // ✅ Si admin también tiene un ID, puedes guardarlo con otra clave
        if (data.containsKey('admin_id')) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('admin_id', data['admin_id']);
          print('admin_id guardado: ${data['admin_id']}');
        }

        return data['mensaje'] as String? ?? data['message'] as String?;
      } else {
        print("Ingreso fallido: ${response.body}");
        print("Ingreso administrador fallido: ${adminResponse.body}");
        return null;
      }
    }
  }
}
