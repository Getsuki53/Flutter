import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/tienda_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de tiendas que sigue un usuario.
class APIObtenerListaTiendasSeguidasPorUsuario {
  static var client = http.Client();

  static Future<List<Tienda>> obtenerListaTiendasSeguidasPorUsuario(int usuario) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.seguimientotiendaAPI}/ObtenerImgNomTiendaPorProducto/?usuario_id=$usuario/");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Suponiendo que data es una lista de tiendas
      return List<Tienda>.from(data.map((item) => Tienda.fromJson(item)));
    } else {
      print("Error al obtener tiendas: ${response.body}");
      return [];
    }
  }
}
