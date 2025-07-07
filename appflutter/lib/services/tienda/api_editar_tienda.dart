import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de crear una tienda.
class APIEditarTienda {
  static var client = http.Client();
  
  static Future<String?> editarTienda({
    required String idTienda,
    String? propietario,
    String? nombreTienda,
    String? descripcionTienda,
    String? imagenPath, // Ruta local del archivo de imagen
  }) async {
    var url = Uri.parse(Config.buildUrl("${Config.tiendaAPI}/ModificarTienda/$idTienda/")); // ✅ Cambiar Uri.http por Uri.parse

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
}
