import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos pendientes de aprobación (Estado = false).
class APIProductosAdmin {
  static var client = http.Client();

  static Future<List<Producto>> obtenerProductosPendientes() async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    // Usar el endpoint de ProductoAdminViewSet que filtra por Estado=False
    var url = Uri.parse(Config.buildUrl(Config.productoadminAPI));

    debugPrint("🔍 DEBUG Admin - URL: $url");

    try {
      var response = await client.get(url, headers: headers);

      debugPrint("🔍 DEBUG Admin - Status: ${response.statusCode}");
      debugPrint("🔍 DEBUG Admin - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Convertir la lista de productos
        return List<Producto>.from(data.map((item) => Producto.fromJson(item)));
      } else {
        debugPrint("🚨 ERROR Admin - Status: ${response.statusCode}");
        debugPrint("🚨 ERROR Admin - Body: ${response.body}");
        return [];
      }
    } catch (e) {
      debugPrint("🚨 ERROR Admin - Exception: $e");
      return [];
    }
  }
}
