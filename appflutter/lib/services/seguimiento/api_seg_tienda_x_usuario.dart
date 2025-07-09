import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/tienda_modelo.dart';
import 'package:appflutter/services/tienda/api_detalle_tienda.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de tiendas que sigue un usuario.
class APIObtenerListaTiendasSeguidasPorUsuario {
  static var client = http.Client();

  static Future<List<Tienda>> obtenerListaTiendasSeguidasPorUsuario(
    int usuario,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl(
        "${Config.seguimientoObtenerListaTiendasSeguidasPorUsuarioAPI}/?usuario_id=$usuario",
      ),
    );

    print("🔍 DEBUG Lista Seguidas - URL: $url");

    try {
      var response = await client.get(url, headers: headers);

      print("🔍 DEBUG Lista Seguidas - Status: ${response.statusCode}");
      print("🔍 DEBUG Lista Seguidas - Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('🔍 Data type: ${data.runtimeType}');
        print('🔍 Data content: $data');

        // data es una lista de objetos con estructura: {"id": 1, "usuario": 3, "tienda": 1}
        List<dynamic> seguidosData = data;
        List<Tienda> tiendas = [];

        print('🔍 Procesando ${seguidosData.length} tiendas seguidas');

        // Para cada relación usuario-tienda, obtener los datos completos de la tienda
        for (var seguido in seguidosData) {
          int tiendaId = seguido['tienda'] as int;
          print('🔍 Obteniendo tienda con ID: $tiendaId');

          try {
            Tienda? tienda = await APIDetalleTienda.detalleTienda(tiendaId);
            if (tienda != null) {
              tiendas.add(tienda);
              print('✅ Tienda agregada: ${tienda.nomTienda}');
            } else {
              print('⚠️ No se pudo obtener la tienda con ID: $tiendaId');
            }
          } catch (e) {
            print('❌ Error al obtener tienda $tiendaId: $e');
          }
        }

        print('🔍 Total tiendas obtenidas: ${tiendas.length}');
        return tiendas;
      } else {
        print("🚨 ERROR Lista Seguidas - Status: ${response.statusCode}");
        print("🚨 ERROR Lista Seguidas - Body: ${response.body}");
        return [];
      }
    } catch (e) {
      print("🚨 ERROR Lista Seguidas - Exception: $e");
      return [];
    }
  }
}
