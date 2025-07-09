import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/tienda_modelo.dart';
import '../../config.dart';

// Esta clase se encarga de obtener el perfil de la tienda.
class APIDetalleTienda {
  static Future<Tienda?> detalleTienda(int tiendaId) async {
    try {
      var url = Uri.parse(Config.buildUrl("${Config.tiendaAPI}/ObtenerDetallesTienda/"));

      var response = await http.get(
        url.replace(queryParameters: {'tienda_id': tiendaId.toString()}),
        headers: {
          'Accept': 'application/json; charset=utf-8',
          'Content-Type': 'application/json; charset=utf-8',
        },
      );

      if (response.statusCode == 200) {
        // Asegurar decodificación UTF-8
        String responseBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(responseBody);
        return Tienda.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      print('Error al obtener detalles de tienda: $e');
      return null;
    }
  }
}
