import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de verificar si un producto está en la lista de deseados de un usuario.
class APIVerificarProductoDeseado {
  static var client = http.Client();

  static Future<bool> verificarProductoDeseado(
    int usuarioId,
    int productoId,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    // Intentar usar un endpoint más específico si existe, sino usar la lista completa
    var url = Uri.parse(
      Config.buildUrl(
        "${Config.productodeseadoAPI}/ObtenerListaDeseadosPorUsuario/?usuario_id=$usuarioId",
      ),
    );

    try {
      var response = await client.get(url, headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> deseadosData = data;

        // Buscar si el producto está en la lista de deseados
        bool existe = deseadosData.any(
          (deseado) => deseado['producto'] == productoId,
        );

        return existe;
      } else {
        print("❌ Error al verificar producto deseado: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error en verificarProductoDeseado: $e");
      return false;
    }
  }

  // Cache para evitar múltiples llamadas
  static Map<String, bool> _cache = {};
  static DateTime? _lastCacheUpdate;
  static const Duration _cacheTimeout = Duration(minutes: 5);

  static Future<bool> verificarProductoDeseadoConCache(
    int usuarioId,
    int productoId,
  ) async {
    String cacheKey = '${usuarioId}_$productoId';
    DateTime now = DateTime.now();

    // Verificar si hay cache válido
    if (_lastCacheUpdate != null &&
        now.difference(_lastCacheUpdate!).inMinutes < _cacheTimeout.inMinutes &&
        _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Si no hay cache o expiró, hacer la consulta
    bool resultado = await verificarProductoDeseado(usuarioId, productoId);

    // Actualizar cache
    _cache[cacheKey] = resultado;
    _lastCacheUpdate = now;

    return resultado;
  }

  // Limpiar cache cuando se agrega/elimina un favorito
  static void limpiarCache() {
    _cache.clear();
    _lastCacheUpdate = null;
  }
}
