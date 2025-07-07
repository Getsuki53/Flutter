import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de agregar un producto al carrito de un usuario.
class APIAgregarAlCarrito {
  static var client = http.Client();

  static Future<String?> agregarAlCarrito(int usuario, int producto, int unidades) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // ✅ CORREGIR: Usar Uri.parse con buildUrl
    var url = Uri.parse(Config.buildUrl("${Config.carritoAPI}/AgAlCarrito/"));

    var body = jsonEncode({
      "usuario_id": usuario,
      "producto_id": producto,
      "unidades": unidades,
    });

    print("🔍 URL agregar carrito: $url");
    print("🔍 usuario: $usuario, producto: $producto, unidades: $unidades");
    print("🔍 Body: $body");

    var response = await client.post(url, headers: headers, body: body);

    print("🔍 Status code: ${response.statusCode}");
    print("🔍 Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      return data['message'] as String?;
    } else {
      print("Error al agregar producto: ${response.body}");
      
      // Intentar parsear el error para mostrar mensaje específico
      try {
        var errorData = jsonDecode(response.body);
        return errorData['error'] as String?;
      } catch (e) {
        return "Error de conexión";
      }
    }
  }
}
