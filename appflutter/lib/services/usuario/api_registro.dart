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
      // REVERT: Use the original working URL
      var url = Uri.parse(Config.buildUrl("${Config.usuarioAPI}/CrearUsuario/"));
      
      print("🔗 URL de registro: $url");
      print("📋 Datos a enviar:");
      print("  - Nombre: '$nombre'");
      print("  - Apellido: '$apellido'");
      print("  - Correo: '$correo'");
      print("  - Contraseña length: ${contrasena.length}");
      print("  - Tiene imagen: ${imagenFile != null || imagenBytes != null}");
      
      // Si no hay imagen, usar JSON simple
      if (imagenFile == null && imagenBytes == null) {
        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
        };

        var body = jsonEncode({
          "nombre": nombre.trim(),
          "apellido": apellido.trim(),
          "contrasena": contrasena,
          "correo": correo.trim(),
        });

        print("🔄 Enviando registro (JSON) a: $url");
        print("📝 Headers: $headers");
        print("📝 Body: $body");

        var response = await client.post(url, headers: headers, body: body);
        
        print("📡 Status Code: ${response.statusCode}");
        print("📡 Response Headers: ${response.headers}");
        print("📡 Response Body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("✅ Status code indica éxito");
          
          // Try to parse as JSON, but don't fail if it's not JSON
          try {
            var data = jsonDecode(response.body);
            print("✅ Registro exitoso con JSON: $data");
            return "Usuario registrado exitosamente";
          } catch (e) {
            // If it's not JSON, check if response contains success indicators
            String responseText = response.body.toLowerCase();
            if (responseText.contains('exitoso') || 
                responseText.contains('success') || 
                responseText.contains('creado') ||
                responseText.contains('registrado') ||
                response.body.trim().isEmpty) { // Sometimes successful responses are empty
              print("✅ Registro exitoso (respuesta no-JSON): ${response.body}");
              return "Usuario registrado exitosamente";
            } else {
              print("⚠️ Status 200/201 pero respuesta inesperada: ${response.body}");
              return "Usuario registrado exitosamente"; // Assume success based on status code
            }
          }
        } else if (response.statusCode == 400) {
          print("❌ Error 400 - Datos inválidos");
          try {
            var errorData = jsonDecode(response.body);
            print("❌ Detalles del error: $errorData");
          } catch (e) {
            print("❌ Error 400 - Response: ${response.body}");
          }
          return null;
        } else if (response.statusCode == 500) {
          print("❌ Error 500 - Error interno del servidor");
          return null;
        } else {
          print("❌ Registro fallido: Status ${response.statusCode}");
          print("❌ Response: ${response.body}");
          return null;
        }
      } else {
        // Si hay imagen, usar multipart/form-data
        var request = http.MultipartRequest('POST', url);
        
        // Agregar headers
        request.headers['Accept'] = 'application/json';
        
        // Agregar campos de texto
        request.fields['nombre'] = nombre.trim();
        request.fields['apellido'] = apellido.trim();
        request.fields['contrasena'] = contrasena;
        request.fields['correo'] = correo.trim();
        
        print("🔄 Enviando registro (Multipart) a: $url");
        print("📝 Fields: ${request.fields}");
        
        // Agregar imagen
        if (imagenFile != null && !kIsWeb) {
          var stream = http.ByteStream(imagenFile.openRead());
          var length = await imagenFile.length();
          var multipartFile = http.MultipartFile('foto', stream, length,
              filename: nombreImagen ?? 'user_image.jpg');
          request.files.add(multipartFile);
          print("🖼️ Imagen agregada (File): ${nombreImagen ?? 'user_image.jpg'}");
        } else if (imagenBytes != null && kIsWeb) {
          var multipartFile = http.MultipartFile.fromBytes(
            'foto',
            imagenBytes,
            filename: nombreImagen ?? 'user_image.jpg',
          );
          request.files.add(multipartFile);
          print("🖼️ Imagen agregada (Bytes): ${nombreImagen ?? 'user_image.jpg'}");
        }
        
        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        
        print("📡 Status Code: ${response.statusCode}");
        print("📡 Response Headers: ${response.headers}");
        print("📡 Response Body: $responseData");

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("✅ Status code indica éxito (Multipart)");
          
          try {
            var data = jsonDecode(responseData);
            print("✅ Registro exitoso con JSON: $data");
            return "Usuario registrado exitosamente";
          } catch (e) {
            // If it's not JSON, check if response contains success indicators
            String responseText = responseData.toLowerCase();
            if (responseText.contains('exitoso') || 
                responseText.contains('success') || 
                responseText.contains('creado') ||
                responseText.contains('registrado') ||
                responseData.trim().isEmpty) {
              print("✅ Registro exitoso (respuesta no-JSON): $responseData");
              return "Usuario registrado exitosamente";
            } else {
              print("⚠️ Status 200/201 pero respuesta inesperada: $responseData");
              return "Usuario registrado exitosamente"; // Assume success based on status code
            }
          }
        } else if (response.statusCode == 400) {
          print("❌ Error 400 - Datos inválidos (Multipart)");
          try {
            var errorData = jsonDecode(responseData);
            print("❌ Detalles del error: $errorData");
          } catch (e) {
            print("❌ Error 400 - Response: $responseData");
          }
          return null;
        } else {
          print("❌ Registro fallido: Status ${response.statusCode}");
          print("❌ Response: $responseData");
          return null;
        }
      }
    } catch (e) {
      print("❌ Excepción en registro: $e");
      print("❌ Tipo de error: ${e.runtimeType}");
      if (e.toString().contains('SocketException')) {
        print("❌ Error de conexión - Verificar que el servidor esté corriendo");
      }
      return null;
    }
  }
}
