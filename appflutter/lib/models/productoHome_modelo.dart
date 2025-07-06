import 'dart:convert';

List<ProductoHomeModel> productosHomeFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ProductoHomeModel>((json) => ProductoHomeModel.fromJson(json))
      .toList();
}

class ProductoHomeModel {
  late String nomprod;
  late String fotoProd;
  late double precio;

  ProductoHomeModel({
    required this.nomprod,
    required this.fotoProd,
    required this.precio,
  });

  // Método auxiliar para parsear imagen - construye la URL completa del backend
  static String _parseImage(dynamic fotoData) {
    print('🔍 DEBUG - Imagen recibida: $fotoData');

    if (fotoData == null || fotoData == '') {
      return 'https://via.placeholder.com/300x300/E0E0E0/666666?text=Sin+Imagen';
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
        print('🔍 DEBUG - URL original: http://127.0.0.1:8000$fotoData');
        print('🔍 DEBUG - URL limpia: $url');
        return url;
      }

      // Si es solo el nombre del archivo, limpiarlo y agregar la ruta completa
      final cleanFileName = _cleanFileName(fotoData);
      final url = 'http://127.0.0.1:8000/media/$cleanFileName';
      print('🔍 DEBUG - Archivo limpio: $url');
      return url;
    }

    return 'https://via.placeholder.com/300x300/E0E0E0/666666?text=Sin+Imagen';
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
        print('🔍 DEBUG - Archivo original: $fileName -> Limpio: $cleanName');
        return cleanName;
      }
    }

    // Si no hay sufijo, devolver el nombre original
    return fileName;
  }

  factory ProductoHomeModel.fromJson(Map<String, dynamic> json) {
    return ProductoHomeModel(
      nomprod: json['Nomprod'] as String? ?? '', // ← Corregido: Mayúscula
      fotoProd: _parseImage(
        json['FotoProd'], // ← Corregido: Mayúscula
      ), // ← Usar método auxiliar para imagen
      precio:
          (json['Precio'] as num?)?.toDouble() ?? 0.0, // ← Corregido: Mayúscula
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nomprod'] = nomprod;
    data['fotoProd'] = fotoProd;
    data['precio'] = precio;
    return data;
  }
}
