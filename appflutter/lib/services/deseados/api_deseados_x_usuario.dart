import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appflutter/models/producto_modelo.dart';
import 'package:appflutter/services/productos/api_detalle_producto.dart';
import '../../config.dart';

// Esta clase se encarga de obtener la lista de productos deseados de un usuario específico.
class APIObtenerListaDeseadosPorUsuario {
  static var client = http.Client();

  static Future<List<Producto>> obtenerListaDeseadosPorUsuario(
    int usuario,
  ) async {
    Map<String, String> headers = {"Content-Type": "application/json"};

    // Corregir la URL - eliminar la barra al final que causa problemas
    var url = Uri.parse(
      Config.buildUrl(
        "${Config.productodeseadoAPI}/ObtenerListaDeseadosPorUsuario/?usuario_id=$usuario",
      ),
    );

    print('🔍 URL deseados: $url');

    var response = await client.get(url, headers: headers);

    print('🔍 Status code: ${response.statusCode}');
    print('🔍 Response body: ${response.body}');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('🔍 Data type: ${data.runtimeType}');
      print('🔍 Data content: $data');

      // data es una lista de objetos con estructura: {"id": 1, "usuario": 3, "producto": 1}
      List<dynamic> deseadosData = data;
      List<Producto> productos = [];

      print('🔍 Procesando ${deseadosData.length} productos deseados');

      // Para cada relación usuario-producto, obtener los datos completos del producto
      for (var deseado in deseadosData) {
        int productoId = deseado['producto'] as int;
        print('🔍 Obteniendo producto con ID: $productoId');

        try {
          Producto? producto = await APIDetalleProducto.obtenerProductoPorId(
            productoId,
          );
          if (producto != null) {
            productos.add(producto);
            print('✅ Producto agregado: ${producto.nomprod}');
          } else {
            print('⚠️ No se pudo obtener el producto con ID: $productoId');
          }
        } catch (e) {
          print('❌ Error al obtener producto $productoId: $e');
        }
      }

      print('🔍 Total productos obtenidos: ${productos.length}');
      return productos;
    } else {
      print("❌ Error al obtener productos deseados: ${response.body}");
      return [];
    }
  }
}
