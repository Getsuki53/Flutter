import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config.dart';

class APISeguimientoTienda {
  static var client = http.Client();

  // Verificar si un usuario sigue una tienda específica
  static Future<bool> verificarSeguimiento(int usuarioId, int tiendaId) async {
    try {
      final tiendasSeguidas = await obtenerTiendasSeguidasPorUsuario(usuarioId);
      return tiendasSeguidas.any((tienda) => tienda['tienda'] == tiendaId);
    } catch (e) {
      print('Error al verificar seguimiento: $e');
      return false;
    }
  }

  // Obtener lista de tiendas seguidas por un usuario
  static Future<List<dynamic>> obtenerTiendasSeguidasPorUsuario(
    int usuarioId,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl(
        "api/SeguimientoTienda/ObtenerListaTiendasSeguidasPorUsuario/?usuario_id=$usuarioId",
      ),
    );

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener tiendas seguidas: ${response.body}');
    }
  }

  // Agregar seguimiento a una tienda
  static Future<bool> agregarSeguimientoTienda(
    int usuarioId,
    int tiendaId,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl("api/SeguimientoTienda/AgregarSeguimientoTienda/"),
    );

    var body = jsonEncode({'usuario_id': usuarioId, 'tienda_id': tiendaId});

    var response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print('Error al agregar seguimiento: ${response.body}');
      return false;
    }
  }

  // Dejar de seguir una tienda
  static Future<bool> dejarDeSeguirTienda(int usuarioId, int tiendaId) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    var url = Uri.parse(
      Config.buildUrl("api/SeguimientoTienda/DejarDeSeguirTienda/"),
    );

    var body = jsonEncode({'usuario_id': usuarioId, 'tienda_id': tiendaId});

    var response = await client.delete(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al dejar de seguir tienda: ${response.body}');
      return false;
    }
  }
}
