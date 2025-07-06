import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos deseados de un usuario específico.
class APIObtenerListaDeseadosPorUsuario {
  static var client = http.Client();
  static Future<List<Producto>> obtenerListaDeseadosPorUsuario(
    int usuario,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.http(
      Config.apiURL,
      "${Config.productodeseadoAPI}/ObtenerListaDeseadosPorUsuario/",
      {'usuario_id': usuario.toString()},
    );
    var response = await client.get(url, headers: headers);

    print("=== DEBUG API RESPONSE ===");
    print("URL: $url");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    print("==========================");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      print("=== DEBUG DECODED DATA ===");
      print("Data Type: ${data.runtimeType}");
      print("Data Content: $data");
      print("==========================");

      // El API ya devuelve productos completos, así que simplemente los parseamos
      try {
        return List<Producto>.from(data.map((item) => Producto.fromJson(item)));
      } catch (e) {
        print("Error al parsear productos: $e");
        return [];
      }
    } else {
      print("Error al obtener deseados: ${response.body}");
      return [];
    }
  }
}
