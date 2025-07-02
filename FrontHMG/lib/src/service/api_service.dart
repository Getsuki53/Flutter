import 'dart:convert';
import 'package:Flutter/config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Como tu backend está en el mismo directorio, usa localhost
  static const String baseUrl = 'http://127.0.0.1:8000/api/';
  
  // Headers base
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Headers con autenticación
  Future<Map<String, String>> get _authHeaders async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    return {
      ..._headers,
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  // Método genérico para GET
  Future<http.Response> get(String endpoint) async {
    final headers = await _authHeaders;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      print('GET $baseUrl$endpoint - Status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error en GET $endpoint: $e');
      rethrow;
    }
  }

  // Método genérico para POST
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final headers = await _authHeaders;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      print('POST $baseUrl$endpoint - Status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error en POST $endpoint: $e');
      rethrow;
    }
  }

  // Método genérico para PATCH
  Future<http.Response> patch(String endpoint, Map<String, dynamic> data) async {
    final headers = await _authHeaders;
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      print('PATCH $baseUrl$endpoint - Status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error en PATCH $endpoint: $e');
      rethrow;
    }
  }

  // Método genérico para DELETE
  Future<http.Response> delete(String endpoint) async {
    final headers = await _authHeaders;
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      print('DELETE $baseUrl$endpoint - Status: ${response.statusCode}');
      return response;
    } catch (e) {
      print('Error en DELETE $endpoint: $e');
      rethrow;
    }
  }
}
