import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/tienda_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener solo el nombre e imagen de una tienda que subió un producto.
class APIObtenerTiendaPorPropietario {
  static var client = http.Client();

  static Future<Tienda?> obtenerTiendaPorPropietario(int usuario) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    // Construir la URL correcta con propietario_id como query parameter
    var url = Uri.http(
      Config.apiURL,
      "${Config.tiendaAPI}/ObtenerTiendaPorPropietario/",
      {"propietario_id": usuario.toString()},
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
