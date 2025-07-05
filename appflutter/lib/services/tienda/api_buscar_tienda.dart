import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/tienda_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de retornar una lista de tiendas para una búsqueda.
class APIBuscarTienda {
  static var client = http.Client();

  static Future<Tienda?> buscarTienda(String busquedaNom) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.http(Config.apiURL, "${Config.tiendaAPI}/buscar/?nombre=$busquedaNom/");

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Tienda.fromJson(data);
    } else {
      print("Error de búsqueda: ${response.body}");
      return null;
    }
  }
}
