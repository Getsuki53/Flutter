import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../config.dart';

// Esta clase se encarga de crear una tienda.
class APICrearTienda {
  static var client = http.Client();

  static Future<String?> crearTienda({
    required String propietario,
    required String nombreTienda,
    required String descripcionTienda,
    String? imagenPath, // Para móvil
    Uint8List? imagenBytes, // Para web
    String? nombreImagen, // Para web
  }) async {
    try {
      var url = Uri.parse(Config.buildUrl("${Config.tiendaAPI}/CrearTienda/"));
      
      var request = http.MultipartRequest('POST', url);
      
      // Agregar campos con los nombres correctos que espera el backend
      request.fields['propietario_id'] = propietario;
      request.fields['nombre_tienda'] = nombreTienda;
      request.fields['descripcion_tienda'] = descripcionTienda;
      
      // Manejar la imagen según la plataforma
      if (kIsWeb) {
        // Para Web: usar imagenBytes
        if (imagenBytes != null && nombreImagen != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'logo', // Campo que espera el backend
              imagenBytes,
              filename: nombreImagen,
            ),
          );
        }
      } else {
        // Para móvil: usar imagenPath
        if (imagenPath != null && imagenPath.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'logo', // Campo que espera el backend
              imagenPath,
            ),
          );
        }
      }
      
      // Enviar la petición
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 201) {
        // Creación exitosa
        var responseData = json.decode(response.body);
        return responseData['message'] ?? 'Tienda creada exitosamente';
      } else if (response.statusCode == 200) {
        // Tienda ya existe
        var responseData = json.decode(response.body);
        return responseData['message'] ?? 'La tienda ya existe';
      } else if (response.statusCode == 400) {
        // Error del cliente
        var responseData = json.decode(response.body);
        return responseData['error'] ?? 'Error en los datos enviados';
      } else if (response.statusCode == 404) {
        // Usuario no encontrado
        var responseData = json.decode(response.body);
        return responseData['error'] ?? 'Usuario no encontrado';
      } else {
        return 'Error desconocido. Código: ${response.statusCode}';
      }
      
    } catch (e) {
      // Error de conexión o cualquier otro error
      return 'Error de conexión: ${e.toString()}';
    }
  }
  /*
  static Future<String?> modificarTienda({
    required String idTienda,
    String? propietario,
    String? nombreTienda,
    String? descripcionTienda,
    String? imagenPath, // Ruta local del archivo de imagen
  }) async {
    var url = Uri.http(Config.apiURL, "${Config.tiendaAPI}/ModificarTienda/$idTienda/");

    var request = http.MultipartRequest("PUT", url);

    // Agregar solo los campos que no sean nulos
    if (propietario != null) request.fields['propietario'] = propietario;
    if (nombreTienda != null) request.fields['nombreTienda'] = nombreTienda;
    if (descripcionTienda != null) request.fields['descripcionTienda'] = descripcionTienda;

    // Si hay una imagen, adjuntarla
    if (imagenPath != null && imagenPath.isNotEmpty) {
      var imagen = await http.MultipartFile.fromPath('imagen', imagenPath);
      request.files.add(imagen);
    }

    // Enviar la solicitud
    var streamedResponse = await request.send();

    if (streamedResponse.statusCode == 200) {
      var responseString = await streamedResponse.stream.bytesToString();
      var jsonMap = jsonDecode(responseString);
      return jsonMap['mensaje'] as String?;
    } else {
      print("Error al modificar tienda: ${streamedResponse.statusCode}");
      return null;
    }
  }
  */
}
