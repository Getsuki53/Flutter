import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ApiService {
  static const String baseUrl = 'http://${Config.apiURL}';

  // Método POST genérico
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    return response;
  }

  // Método GET genérico
  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.get(
      url,
      headers: headers ?? {'Content-Type': 'application/json'},
    );

    return response;
  }

  // Método específico para login
  static Future<Map<String, dynamic>> login(
    String correo,
    String contrasena,
  ) async {
    try {
      final response = await post('api/login-usuario/', {
        'correo': correo,
        'contraseña': contrasena,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['error'] ?? 'Error de autenticación',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }
}
