import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de eliminar un producto.
class APIEliminarProducto {
  static var client = http.Client();

  static Future<String?> eliminarProducto(int producto) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    // El endpoint de eliminar requiere el producto_id en el body
    var url = Uri.parse(
      Config.buildUrl("${Config.productoadminAPI}EliminarProducto/"),
    );

    var body = jsonEncode({"producto_id": producto});

    debugPrint("🔍 DEBUG Eliminar Producto - URL: $url");
    debugPrint("🔍 DEBUG Eliminar Producto - Body: $body");

    try {
      var response = await client.delete(url, headers: headers, body: body);

      debugPrint("🔍 DEBUG Eliminar Producto - Status: ${response.statusCode}");
      debugPrint("🔍 DEBUG Eliminar Producto - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['message'] as String?;
      } else {
        debugPrint(
          "🚨 ERROR Eliminar Producto - Status: ${response.statusCode}",
        );
        debugPrint("🚨 ERROR Eliminar Producto - Body: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("🚨 ERROR Eliminar Producto - Exception: $e");
      return null;
    }
  }
}
