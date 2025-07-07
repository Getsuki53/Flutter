import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/tienda_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener el perfil de la tienda.
class APIDetalleTienda {
  static var client = http.Client();

  static Future<Tienda?> detalleTienda(int tienda) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(
      Config.apiURL, 
      "${Config.tiendaAPI}/ObtenerDetallesTienda",
      {"tienda_id": tienda.toString()},
    );

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Tienda.fromJson(data);
    } else {
      print("Error al obtener tienda: ${response.body}");
      return null;
    }
  }
}
