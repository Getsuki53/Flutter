import 'tienda_modelo.dart';

class Producto {
  final int? id;
  final String nomprod;
  final String descripcionProd;
  final int stock;
  final String? fotoProd; // Nullable - puede no tener imagen
  final double precio;
  final String tipoCategoria;
  final bool? estado;
  final DateTime? fechaPub;
  final Tienda? tienda;

  Producto({
    this.id,
    required this.nomprod,
    required this.descripcionProd,
    required this.stock,
    this.fotoProd, // Opcional ya que es nullable
    required this.precio,
    required this.tipoCategoria,
    this.estado,
    this.fechaPub,
    this.tienda,
  });

  // Método auxiliar para parsear precio que puede venir como String o num
  static double _parsePrice(dynamic precio) {
    if (precio == null) return 0.0;
    if (precio is num) return precio.toDouble();
    if (precio is String) {
      return double.tryParse(precio) ?? 0.0;
    }
    return 0.0;
  }

  // Método auxiliar para parsear enteros que pueden venir como String o num
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Método auxiliar para parsear tienda que puede venir como int (ID) o objeto completo
  static Tienda? _parseTienda(dynamic tiendaData) {
    if (tiendaData == null) return null;

    if (tiendaData is int) {
      // Si es un entero, crear una Tienda solo con el ID
      return Tienda(id: tiendaData);
    }

    if (tiendaData is Map<String, dynamic>) {
      // Si es un objeto, usar el fromJson normal
      return Tienda.fromJson(tiendaData);
    }

    return null;
  }

  // Método auxiliar para parsear imagen - construye la URL completa del backend
  static String? _parseImage(dynamic fotoData) {
    if (fotoData == null || fotoData == '') {
      // Si no hay imagen, devolver null
      return null;
    }

    if (fotoData is String && fotoData.isNotEmpty) {
      // Si ya es una URL completa, devolverla tal como está
      if (fotoData.startsWith('http')) {
        return fotoData;
      }

      // Si es una ruta que ya incluye /media/, solo agregar el dominio
      if (fotoData.startsWith('/media/')) {
        return 'http://127.0.0.1:8000$fotoData';
      }

      // Si es solo el nombre del archivo, agregar la ruta completa
      return 'http://127.0.0.1:8000/media/$fotoData';
    }

    return null;
  }

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as int?,
      nomprod: json['Nomprod'] as String? ?? '', // ← Corregido: Mayúscula
      descripcionProd:
          json['DescripcionProd'] as String? ?? '', // ← Corregido: Mayúscula
      stock: _parseInt(json['Stock']), // ← Usar método auxiliar
      fotoProd: _parseImage(
        json['FotoProd'],
      ), // ← Usar método auxiliar para imagen
      precio: _parsePrice(
        json['Precio'],
      ), // ← Método auxiliar para manejar string/number
      tipoCategoria: json['tipoCategoria'] as String? ?? '',
      estado: json['Estado'] as bool?, // ← Corregido: Mayúscula
      fechaPub:
          json['FechaPub'] != null
              ? DateTime.parse(json['FechaPub'])
              : null, // ← Corregido: Mayúscula
      tienda: _parseTienda(
        json['tienda'],
      ), // ← Manejar tienda como int o objeto
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['nomprod'] = nomprod;
    data['descripcionProd'] = descripcionProd;
    data['stock'] = stock;
    data['fotoProd'] = fotoProd;
    data['precio'] = precio;
    data['tipoCategoria'] = tipoCategoria;
    data['estado'] = estado;
    data['fechaPub'] = fechaPub?.toIso8601String();
    if (tienda != null) {
      data['tienda'] = tienda!.toJson();
    }
    return data;
  }
}
