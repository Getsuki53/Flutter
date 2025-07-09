import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Servicio temporal para debug de productos pendientes
class APIDebugProductos {
  static var client = http.Client();

  static Future<Map<String, dynamic>?> debugProductosPendientes() async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl("${Config.productoadminAPI}DebugProductosPendientes/"),
    );

    debugPrint("🔍 DEBUG - URL: $url");

    try {
      var response = await client.get(url, headers: headers);

      debugPrint("🔍 DEBUG - Status: ${response.statusCode}");
      debugPrint("🔍 DEBUG - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {
        debugPrint("🚨 ERROR DEBUG - Status: ${response.statusCode}");
        debugPrint("🚨 ERROR DEBUG - Body: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("🚨 ERROR DEBUG - Exception: $e");
      return null;
    }
  }
}
