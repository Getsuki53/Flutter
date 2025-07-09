import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de eliminar un producto a la lista de deseados de un usuario.
class APIEliminarProductoDeseado {
  static var client = http.Client();

  static Future<String?> eliminarProductoDeseado(
    int usuario,
    int producto,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl(
      "${Config.productodeseadoAPI}/EliminarProductoDeseado/",
    ));

    var body = jsonEncode({"usuario_id": usuario, "producto_id": producto});

    print("🔍 DEBUG Eliminar Deseados - URL: $url");
    print("🔍 DEBUG Eliminar Deseados - Body: $body");

    try {
      var response = await client.delete(url, headers: headers, body: body);

      print("🔍 DEBUG Eliminar Deseados - Status: ${response.statusCode}");
      print("🔍 DEBUG Eliminar Deseados - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['message'] as String?;
      } else if (response.statusCode == 404) {
        // El producto no estaba en la lista de deseados
        var data = jsonDecode(response.body);
        return data['message'] as String?;
      } else {
        print("🚨 ERROR Eliminar Deseados - Status: ${response.statusCode}");
        print("🚨 ERROR Eliminar Deseados - Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 ERROR Eliminar Deseados - Exception: $e");
      return null;
    }
  }
}
