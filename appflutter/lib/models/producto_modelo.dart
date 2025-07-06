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
    print('🔍 DEBUG Producto - Imagen recibida: $fotoData');

    if (fotoData == null || fotoData == '') {
      return null;
    }

    if (fotoData is String && fotoData.isNotEmpty) {
      // Si ya es una URL completa, devolverla tal como está
      if (fotoData.startsWith('http')) {
        return fotoData;
      }

      String cleanPath = fotoData;

      // Si es una ruta que incluye /media/, extraemos la parte del archivo
      if (fotoData.startsWith('/media/')) {
        cleanPath = fotoData; // Mantenemos la ruta completa de Django

        // Extraer solo el nombre del archivo para "limpiarlo"
        final parts = fotoData.split('/');
        if (parts.isNotEmpty) {
          final fileName = parts.last;

          // Limpiar el nombre del archivo eliminando sufijos de Django (_x8HUMfX, etc.)
          final cleanFileName = _cleanFileName(fileName);

          // Reconstruir la ruta con el nombre limpio
          parts[parts.length - 1] = cleanFileName;
          cleanPath = parts.join('/');
        }

        final url = 'http://127.0.0.1:8000$cleanPath';
        print(
          '🔍 DEBUG Producto - URL original: http://127.0.0.1:8000$fotoData',
        );
        print('🔍 DEBUG Producto - URL limpia: $url');
        print('🔍 DEBUG Producto - Extensión del archivo: ${cleanPath.split('.').last}');
        return url;
      }

      // Si es solo el nombre del archivo, limpiarlo y agregar la ruta completa
      final cleanFileName = _cleanFileName(fotoData);
      final url = 'http://127.0.0.1:8000/media/$cleanFileName';
      print('🔍 DEBUG Producto - Archivo limpio: $url');
      return url;
    }

    return null;
  }

  // Método auxiliar para limpiar nombres de archivo de sufijos de Django
  static String _cleanFileName(String fileName) {
    // Patrón para detectar sufijos de Django: _[caracteres].[extensión]
    // Ejemplo: baulmimbre_x8HUMfX.png -> baulmimbre.png
    final regex = RegExp(r'_[a-zA-Z0-9]+\.([a-zA-Z0-9]+)$');

    if (regex.hasMatch(fileName)) {
      // Extraer el nombre base y la extensión
      final extensionMatch = regex.firstMatch(fileName);
      if (extensionMatch != null) {
        final extension = extensionMatch.group(1);
        final baseName =
            fileName.split(
              '_',
            )[0]; // Tomar solo la primera parte antes del primer _
        final cleanName = '$baseName.$extension';
        print(
          '🔍 DEBUG Producto - Archivo original: $fileName -> Limpio: $cleanName',
        );
        return cleanName;
      }
    }

    // Si no hay sufijo, devolver el nombre original
    return fileName;
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
