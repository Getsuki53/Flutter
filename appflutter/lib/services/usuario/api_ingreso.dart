import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';

// Esta clase se encarga del ingreso del usuario.
class APIIngreso {
  static var client = http.Client();

  static Future<Map<String, dynamic>?> ingresoUsuario(
    String correo,
    String contrasena,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(Config.buildUrl(Config.loginAPI)); // ✅ Ya corregido

    var body = jsonEncode({"correo": correo, "contrasena": contrasena});

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // Guardar usuario_id si existe
      if (data.containsKey('usuario_id')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('usuario_id', data['usuario_id']);
        await prefs.setString(
          'tipo_usuario',
          data['tipo_usuario'] ?? 'usuario',
        );
        debugPrint('usuario_id guardado: ${data['usuario_id']}');
      }

      return {
        'mensaje': data['mensaje'] ?? data['message'],
        'tipo_usuario': data['tipo_usuario'] ?? 'usuario',
        'usuario_id': data['usuario_id'],
      };
    } else {
      // Intentar autenticación de administrador
      var adminUrl = Uri.parse(Config.buildUrl("${Config.administradorAPI}/AutenticacionarAdministrador/")); // ✅ Ya corregido

      var adminResponse = await client.post(
        adminUrl,
        headers: headers,
        body: body,
      );

      if (adminResponse.statusCode == 200) {
        var data = jsonDecode(adminResponse.body);

        // Guardar admin_id si existe
        if (data.containsKey('admin_id')) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setInt('admin_id', data['admin_id']);
          await prefs.setString(
            'tipo_usuario',
            data['tipo_usuario'] ?? 'administrador',
          );
          debugPrint('admin_id guardado: ${data['admin_id']}');
        }

        return {
          'mensaje': data['mensaje'] ?? data['message'],
          'tipo_usuario': data['tipo_usuario'] ?? 'administrador',
          'admin_id': data['admin_id'],
        };
      } else {
        debugPrint("Ingreso fallido: ${response.body}");
        debugPrint("Ingreso administrador fallido: ${adminResponse.body}");
        return null;
      }
    }
  }
}
