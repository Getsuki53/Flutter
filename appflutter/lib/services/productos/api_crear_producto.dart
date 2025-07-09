import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../../config.dart';

class APICrearProducto {
  static var client = http.Client();

  static Future<bool> crearProducto({
    required String nombre,
    required String descripcion,
    required int stock,
    required double precio,
    required String categoria,
    required int tiendaId,
    File? imagenFile,
    Uint8List? imagenBytes,
    String? nombreImagen,
  }) async {
    try {
      var url = Uri.parse(Config.buildUrl(Config.productoCrearProductoAPI));

      print('🌐 Creando producto en: $url');

      // Crear multipart request para enviar archivos
      var request = http.MultipartRequest('POST', url);
      
      // Agregar campos de texto
      request.fields['Nomprod'] = nombre;
      request.fields['DescripcionProd'] = descripcion;
      request.fields['Stock'] = stock.toString();
      request.fields['Precio'] = precio.toString();
      request.fields['tipoCategoria'] = categoria;
      request.fields['tienda'] = tiendaId.toString();
      request.fields['Estado'] = 'false'; // Estado = 0 (pendiente de aprobación)

      // Agregar imagen dependiendo de la plataforma
      if (kIsWeb && imagenBytes != null) {
        print('📸 Agregando imagen desde bytes (Web): ${nombreImagen ?? 'imagen.jpg'}');
        var multipartFile = http.MultipartFile.fromBytes(
          'FotoProd',
          imagenBytes,
          filename: nombreImagen ?? 'imagen.jpg',
        );
        request.files.add(multipartFile);
      } else if (!kIsWeb && imagenFile != null) {
        print('📸 Agregando imagen desde archivo (Móvil): ${imagenFile.path}');
        var stream = http.ByteStream(imagenFile.openRead());
        var length = await imagenFile.length();
        var multipartFile = http.MultipartFile(
          'FotoProd',
          stream,
          length,
          filename: imagenFile.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      print('📦 Campos enviados: ${request.fields}');
      print('� Archivos enviados: ${request.files.length}');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('📊 Status Code: ${response.statusCode}');
      print('📊 Response Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Producto creado exitosamente');
        return true;
      } else {
        print('❌ Error al crear producto: ${response.body}');
        return false;
      }
    } catch (e) {
      print('💥 Excepción al crear producto: $e');
      return false;
    }
  }
}
