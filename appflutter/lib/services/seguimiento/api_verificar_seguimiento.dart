import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de verificar si un usuario sigue una tienda específica.
class APIVerificarSeguimiento {
  static var client = http.Client();

  static Future<bool> verificarSeguimiento(int usuario, int tienda) async {
    var url = Uri.parse(Config.buildUrl("${Config.seguimientoVerificarSeguimientoAPI}/?usuario_id=$usuario&tienda_id=$tienda"));

    print("🔍 DEBUG Verificar Seguimiento - URL: $url");

    try {
      var response = await client.get(url);

      print("🔍 DEBUG Verificar Seguimiento - Status: ${response.statusCode}");
      print("🔍 DEBUG Verificar Seguimiento - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['sigue'] == true;
      } else {
        print(
          "🚨 ERROR Verificar Seguimiento - Status: ${response.statusCode}",
        );
        print("🚨 ERROR Verificar Seguimiento - Body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("🚨 ERROR Verificar Seguimiento - Exception: $e");
      return false;
    }
  }
}
