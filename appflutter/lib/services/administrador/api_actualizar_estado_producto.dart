import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de aprobar un producto.
class APIActualizarEstadoProducto {
  static var client = http.Client();

  static Future<String?> actualizarEstadoProducto(int producto) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    // El endpoint requiere el pk en la URL, no en el body
    var url = Uri.parse(
      Config.buildUrl(
        "${Config.productoadminAPI}$producto/ActualizarEstadoProducto/",
      ),
    );

    debugPrint("🔍 DEBUG Actualizar Estado - URL: $url");

    try {
      var response = await client.patch(url, headers: headers);

      debugPrint("🔍 DEBUG Actualizar Estado - Status: ${response.statusCode}");
      debugPrint("🔍 DEBUG Actualizar Estado - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['message'] as String?;
      } else {
        debugPrint(
          "🚨 ERROR Actualizar Estado - Status: ${response.statusCode}",
        );
        debugPrint("🚨 ERROR Actualizar Estado - Body: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("🚨 ERROR Actualizar Estado - Exception: $e");
      return null;
    }
  }
}
