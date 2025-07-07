import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/carrito_item_detallado.dart';
import 'package:appflutter/services/productos/api_detalle_producto.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos del carrito de un usuario.
class APIObtenerProductosCarrito {
  static var client = http.Client();

  static Future<List<CarritoItemDetallado>> obtenerProductosCarritoDetallado(usuario) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.parse(Config.buildUrl("${Config.productoAPI}/ObtenerProductosCarrito/?usuario_id=$usuario"));

    print('🔍 URL carrito: $url');

    var response = await client.get(url, headers: headers);

    print('🔍 Status code: ${response.statusCode}');
    print('🔍 Response body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Map<String, dynamic>> carritoItems = List<Map<String, dynamic>>.from(data);
      
      // Obtener detalles de cada producto
      List<CarritoItemDetallado> itemsDetallados = [];
      
      for (var item in carritoItems) {
        int productoId = item['producto'] as int;
        var producto = await APIDetalleProducto.obtenerProductoPorId(productoId);
        
        var itemDetallado = CarritoItemDetallado.fromCarritoItem(item, producto);
        itemsDetallados.add(itemDetallado);
      }
      
      return itemsDetallados;
    } else {
      print("Error al obtener productos: ${response.body}");
      return [];
    }
  }

  // Mantener el método original por compatibilidad
  static Future<List<Map<String, dynamic>>> obtenerProductosCarrito(usuario) async {
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var url = Uri.parse(Config.buildUrl("${Config.productoAPI}/ObtenerProductosCarrito/?usuario_id=$usuario"));

    var response = await client.get(url, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      print("Error al obtener productos: ${response.body}");
      return [];
    }
  }
}
