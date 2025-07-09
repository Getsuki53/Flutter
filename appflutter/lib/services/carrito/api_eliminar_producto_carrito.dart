import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de eliminar completamente un producto del carrito.
class APIEliminarProductoCarrito {
  static var client = http.Client();

  static Future<Map<String, dynamic>?> eliminarProducto(
    int usuarioId,
    int productoId,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(Config.buildUrl(Config.EliminarProductoCarritoAPI));

    var body = jsonEncode({"usuario_id": usuarioId, "producto_id": productoId});

    debugPrint("🔍 URL eliminar del carrito: $url");
    debugPrint("🔍 Usuario: $usuarioId, Producto: $productoId");

    try {
      var response = await client.delete(url, headers: headers, body: body);

      debugPrint("🔍 Status code: ${response.statusCode}");
      debugPrint("🔍 Response body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {'success': true, 'message': data['message']};
      } else {
        debugPrint("🚨 Error al eliminar del carrito: ${response.body}");
        try {
          var errorData = jsonDecode(response.body);
          return {
            'success': false,
            'error': errorData['error'] ?? 'Error desconocido',
          };
        } catch (e) {
          return {'success': false, 'error': 'Error de conexión'};
        }
      }
    } catch (e) {
      debugPrint("🚨 Exception al eliminar del carrito: $e");
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }
}
