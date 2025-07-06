import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Alternativa: obtener productos uno por uno
class APIObtenerListaDeseadosAlternativa {
  static var client = http.Client();

  static Future<List<Producto>> obtenerListaDeseadosPorUsuario(
    int usuario,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    // Primero obtenemos los ProductoDeseado
    var url = Uri.http(
      Config.apiURL,
      "${Config.productodeseadoAPI}/ObtenerListaDeseadosPorUsuario/?usuario_id=$usuario/",
    );
    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var deseadosData = jsonDecode(response.body);
      List<Producto> productos = [];

      // Para cada ProductoDeseado, obtener el Producto completo
      for (var item in deseadosData) {
        if (item['producto'] != null) {
          int productoId = item['producto'] as int;

          // Obtener producto individual: api/producto/id
          var productoUrl = Uri.http(
            Config.apiURL,
            "${Config.productoAPI}/$productoId",
          );
          var productoResponse = await client.get(
            productoUrl,
            headers: headers,
          );

          if (productoResponse.statusCode == 200) {
            var productoData = jsonDecode(productoResponse.body);
            productos.add(Producto.fromJson(productoData));
          }
        }
      }

      return productos;
    } else {
      print("Error al obtener deseados: ${response.body}");
      return [];
    }
  }
}
