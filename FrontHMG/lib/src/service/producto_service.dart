import 'dart:convert';
import '../model/producto.dart';
import 'api_service.dart';

class ProductoService {
  final ApiService _apiService = ApiService();

  // Obtener todos los productos
  Future<List<Producto>> getProductos() async {
    try {
      final response = await _apiService.get('producto/');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener producto por ID
  Future<Producto> getProductoById(int id) async {
    try {
      final response = await _apiService.get('producto/ObtenerProductoMain/?producto_id=$id');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Producto.fromJson(data);
      } else {
        throw Exception('Producto no encontrado');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener productos por tienda
  Future<List<Producto>> getProductosPorTienda(int tiendaId) async {
    try {
      final response = await _apiService.get('producto/ObtenerProductosPorTienda/?tienda_id=$tiendaId');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos de la tienda');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener productos para administrador (no aprobados)
  Future<List<Producto>> getProductosAdmin() async {
    try {
      final response = await _apiService.get('productoadmin/');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos para revisión');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Aprobar producto (Admin)
  Future<Map<String, dynamic>> aprobarProducto(int productoId) async {
    try {
      final response = await _apiService.patch('productoadmin/$productoId/ActualizarEstadoProducto/', {});
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'error': 'Error al aprobar producto',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }
}
