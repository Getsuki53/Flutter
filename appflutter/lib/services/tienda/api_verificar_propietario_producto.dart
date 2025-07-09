import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

class APIVerificarPropietarioProducto {
  static var client = http.Client();

  static Future<bool> verificarPropietario(int productoId, int usuarioId) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };

      var url = Uri.parse(Config.buildUrl(
        "${Config.tiendaVerificarPropietarioProdAPI}?producto_id=$productoId&usuario_id=$usuarioId"
      ));

      print('🔍 URL verificar propietario: $url');

      var response = await client.get(url, headers: headers);

      print('🔍 Status code verificar propietario: ${response.statusCode}');
      print('🔍 Response body verificar propietario: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['es_propietario'] ?? false;
      } else {
        print("Error al verificar propietario: ${response.body}");
        return false;
      }
    } catch (e) {
      print('❌ Error en verificarPropietario: $e');
      return false;
    }
  }
}