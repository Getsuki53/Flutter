import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos del carrito de un usuario.
class APIObtenerProductosCarrito {
  static var client = http.Client();

  static Future<List<Producto>> obtenerProductosCarrito(usuario) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productoAPI}/ObtenerProductosCarrito/?usuario_id=$usuario");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Suponiendo que data es una lista de productos
      return List<Producto>.from(data.map((item) => Producto.fromJson(item)));
    } else {
      print("Error al obtener productos: ${response.body}");
      return [];
    }
  }
}
