import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos del carrito de un usuario.
class APIObtenerListaProductosPorCarrito {
  static var client = http.Client();

  static Future<Producto?> obtenerListaTiendasProductosPorCarrito(int usuario) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productoAPI}/ObtenerProductosPorTienda/?usuario_id=$usuario/");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Producto.fromJson(data);
    } else {
      print("Error al obtener productos: ${response.body}");
      return null;
    }
  }
}
