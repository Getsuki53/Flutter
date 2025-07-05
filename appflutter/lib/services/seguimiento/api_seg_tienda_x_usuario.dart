import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/tienda_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de tiendas que sigue un usuario.
class APIObtenerListaTiendasSeguidasPorUsuario {
  static var client = http.Client();

  static Future<Tienda?> obtenerListaTiendasSeguidasPorUsuario(int id) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.seguimientotiendaAPI}/ObtenerImgNomTiendaPorProducto/?usuario_id=$id/");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Tienda.fromJson(data);
    } else {
      print("Error al obtener tiendas: ${response.body}");
      return null;
    }
  }
}
