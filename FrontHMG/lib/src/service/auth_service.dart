import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Login de usuario
  Future<Map<String, dynamic>> loginUsuario(String correo, String contrasena) async {
    try {
      final response = await _apiService.post('login-usuario/', {
        'correo': correo,
        'contrasena': contrasena,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Guardar token y usuario_id
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', data['token']);
        await prefs.setInt('usuario_id', data['usuario_id']);
        
        return {
          'success': true,
          'token': data['token'],
          'usuario_id': data['usuario_id'],
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['error'] ?? 'Error de autenticación',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Login de administrador
  Future<Map<String, dynamic>> loginAdministrador(String username, String password) async {
    try {
      final response = await _apiService.post('administrador/AutenticarAdministrador/', {
        'username': username,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['error'] ?? 'Error de autenticación',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post('logout/', {});
    } catch (e) {
      print('Error durante logout: $e');
    } finally {
      // Limpiar datos locales
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('usuario_id');
    }
  }

  // Verificar si está autenticado
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') != null;
  }

  // Obtener usuario ID
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuario_id');
  }
}
