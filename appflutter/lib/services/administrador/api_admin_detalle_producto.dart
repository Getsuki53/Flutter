import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener los detalles completos de un producto para administradores.
class APIDetalleProducto {
  static var client = http.Client();

  static Future<Producto?> detalleProducto(int producto) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    // Usar el endpoint específico para obtener el producto por ID
    var url = Uri.parse(
      Config.buildUrl("${Config.productoadminAPI}$producto/"),
    );

    debugPrint("🔍 DEBUG Admin Detalle - URL: $url");

    try {
      var response = await client.get(url, headers: headers);

      debugPrint("🔍 DEBUG Admin Detalle - Status: ${response.statusCode}");
      debugPrint("🔍 DEBUG Admin Detalle - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Producto.fromJson(data);
      } else {
        debugPrint("🚨 ERROR Admin Detalle - Status: ${response.statusCode}");
        debugPrint("🚨 ERROR Admin Detalle - Body: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("🚨 ERROR Admin Detalle - Exception: $e");
      return null;
    }
  }
}
