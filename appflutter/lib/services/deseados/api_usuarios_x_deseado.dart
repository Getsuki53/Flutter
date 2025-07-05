import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de usuarios que desean un producto.
class APIObtenerListaUsuariosQueDeseanProducto {
  static var client = http.Client();

  static Future<Producto?> obtenerListaUsuariosQueDeseanProducto(int producto) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.productodeseadoAPI}/ObtenerListaUsuariosQueDeseanProducto/?producto_id=$producto/");

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
