import 'dart:convert';
import 'api_service.dart';

class CarritoService {
  final ApiService _apiService = ApiService();

  // Obtener items del carrito
  Future<List<dynamic>> getItemsCarrito() async {
    try {
      final response = await _apiService.get('itemcarrito/');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al cargar carrito');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Agregar producto al carrito
  Future<Map<String, dynamic>> agregarAlCarrito(int productoId, int unidades) async {
    try {
      final response = await _apiService.post('itemcarrito/', {
        'producto': productoId,
        'unidades': unidades,
      });

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['error'] ?? 'Error al agregar al carrito',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Actualizar cantidad en carrito
  Future<Map<String, dynamic>> actualizarCantidad(int itemId, int nuevasCantidad) async {
    try {
      final response = await _apiService.patch('itemcarrito/$itemId/', {
        'unidades': nuevasCantidad,
      });

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else if (response.statusCode == 204) {
        // Item eliminado (cantidad = 0)
        return {
          'success': true,
          'message': 'Ítem eliminado del carrito',
        };
      } else {
        final error = json.decode(response.body);
        return {
          'success': false,
          'error': error['error'] ?? 'Error al actualizar cantidad',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Sumar cantidad
  Future<Map<String, dynamic>> sumarCantidad(int itemId, int cantidad) async {
    try {
      final response = await _apiService.patch('itemcarrito/$itemId/', {
        'sumar': cantidad,
      });

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Error al sumar cantidad',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Restar cantidad
  Future<Map<String, dynamic>> restarCantidad(int itemId, int cantidad) async {
    try {
      final response = await _apiService.patch('itemcarrito/$itemId/', {
        'restar': cantidad,
      });

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'data': response.statusCode == 204 ? 'Item eliminado' : json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Error al restar cantidad',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Error de conexión: $e',
      };
    }
  }

  // Eliminar item del carrito
  Future<bool> eliminarDelCarrito(int itemId) async {
    try {
      final response = await _apiService.delete('itemcarrito/$itemId/');
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  // Checkout (proceso de pago)
  Future<Map<String, dynamic>> checkout() async {
    try {
      final response = await _apiService.post('checkout/', {});
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'data': data,
        };
      } else {
        return {
          'success': false,
          'error': 'Error en checkout',
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
