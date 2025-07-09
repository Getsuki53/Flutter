import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de actualizar la cantidad de un producto en el carrito.
class APIActualizarCantidadCarrito {
  static var client = http.Client();

  static Future<Map<String, dynamic>?> actualizarCantidad(
    int usuarioId,
    int productoId,
    int nuevaCantidad,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(Config.buildUrl(Config.ActualizarCantidadCarritoAPI));

    var body = jsonEncode({
      "usuario_id": usuarioId,
      "producto_id": productoId,
      "nueva_cantidad": nuevaCantidad,
    });

    debugPrint("🔍 URL actualizar cantidad: $url");
    debugPrint(
      "🔍 Usuario: $usuarioId, Producto: $productoId, Nueva cantidad: $nuevaCantidad",
    );

    try {
      var response = await client.patch(url, headers: headers, body: body);

      debugPrint("🔍 Status code: ${response.statusCode}");
      debugPrint("🔍 Response body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'eliminado': data['eliminado'] ?? false,
          'nueva_cantidad': data['nueva_cantidad'],
          'nuevo_total': data['nuevo_total'],
        };
      } else {
        debugPrint("🚨 Error al actualizar cantidad: ${response.body}");
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
      debugPrint("🚨 Exception al actualizar cantidad: $e");
      return {'success': false, 'error': 'Error de conexión: $e'};
    }
  }
}
