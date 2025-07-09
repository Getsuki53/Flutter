import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../config.dart';

// Esta clase se encarga del registro del usuario.
class APIRegistro {
  static var client = http.Client();

  static Future<String?> registro(
    String correo, 
    String nombre, 
    String apellido, 
    String contrasena, {
    File? imagenFile,
    Uint8List? imagenBytes,
    String? nombreImagen,
  }) async {
    
    try {
      var url = Uri.parse(Config.buildUrl("${Config.usuarioAPI}/CrearUsuario/"));
      
      var request = http.MultipartRequest('POST', url);
      
      // Agregar campos de texto
      request.fields['nombre'] = nombre;
      request.fields['apellido'] = apellido;
      request.fields['correo'] = correo;
      request.fields['contrasena'] = contrasena;
      
      // Manejar la imagen según la plataforma
      if (kIsWeb) {
        // Para Web: usar imagenBytes
        if (imagenBytes != null && nombreImagen != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'foto',
              imagenBytes,
              filename: nombreImagen,
            ),
          );
        }
      } else {
        // Para móvil: usar imagenFile
        if (imagenFile != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'foto',
              imagenFile.path,
            ),
          );
        }
      }
      
      // Enviar la petición
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 201) {
        // Registro exitoso - retornar null indica éxito
        return null;
      } else if (response.statusCode == 400) {
        // Error del cliente (usuario ya existe, campos faltantes, etc.)
        var responseData = json.decode(response.body);
        return responseData['error'] ?? 'Error en los datos enviados';
      } else if (response.statusCode == 500) {
        // Error del servidor
        var responseData = json.decode(response.body);
        return responseData['error'] ?? 'Error interno del servidor';
      } else {
        return 'Error desconocido. Código: ${response.statusCode}';
      }
      
    } catch (e) {
      // Error de conexión o cualquier otro error
      return 'Error de conexión: ${e.toString()}';
    }
  }
}