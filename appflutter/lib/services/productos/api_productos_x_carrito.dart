import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos del carrito de un usuario.
class APIObtenerProductosCarrito {
  static var client = http.Client();

  static Future<List<Map<String, dynamic>>> obtenerProductosCarrito(usuario) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // ✅ Usar Uri.parse con buildUrl
    var url = Uri.parse(Config.buildUrl("${Config.productoAPI}/ObtenerProductosCarrito/?usuario_id=$usuario"));

    print('🔍 URL carrito: $url'); // Debug

    var response = await client.get(url, headers: headers);

    print('🔍 Status code: ${response.statusCode}');
    print('🔍 Response body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Devolver los datos tal como vienen de la API
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener productos: ${response.body}");
      return [];
    }
  }
}
