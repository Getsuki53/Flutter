import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/tienda_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de usuarios que siguen una tienda.
class APIObtenerListaUsuarioQueSiguenTienda {
  static var client = http.Client();

  static Future<Tienda?> obtenerListaUsuarioQueSiguenTienda(int tienda) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.parse(Config.buildUrl("${Config.seguimientotiendaAPI}/ObtenerListaUsuarioQueSiguenTienda/?tienda_id=$tienda/")); 

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Tienda.fromJson(data);
    } else {
      print("Error al obtener usuarios: ${response.body}");
      return null;
    }
  }
}
