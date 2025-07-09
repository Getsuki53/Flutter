import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/productoDeseado_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de usuarios que desean un producto.
class APIObtenerListaUsuariosQueDeseanProducto {
  static var client = http.Client();

  static Future<List<ProductoDeseado>?> obtenerListaUsuariosQueDeseanProducto(
    int producto,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl(
      "${Config.productodeseadoAPI}/ObtenerListaUsuariosQueDeseanProducto/?producto_id=$producto",
    ));

    print("🔍 DEBUG Usuarios Deseado - URL: $url");

    try {
      var response = await client.get(url, headers: headers);

      print("🔍 DEBUG Usuarios Deseado - Status: ${response.statusCode}");
      print("🔍 DEBUG Usuarios Deseado - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // El backend devuelve una lista de ProductoDeseado
        if (data is List) {
          return data
              .map<ProductoDeseado>((json) => ProductoDeseado.fromJson(json))
              .toList();
        } else {
          print("🚨 ERROR Usuarios Deseado - Response no es una lista");
          return null;
        }
      } else {
        print("🚨 ERROR Usuarios Deseado - Status: ${response.statusCode}");
        print("🚨 ERROR Usuarios Deseado - Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🚨 ERROR Usuarios Deseado - Exception: $e");
      return null;
    }
  }
}
