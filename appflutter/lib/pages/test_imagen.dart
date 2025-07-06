import 'package:flutter/material.dart';
import '../models/producto_modelo.dart';

class TestImagenPage extends StatelessWidget {
  const TestImagenPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simular datos de la API
    final testData = {
      "id": 1,
      "Nomprod": "Canasto de mimbre",
      "DescripcionProd": "Canasto hecho a mano de mimbre",
      "Stock": 5,
      "FotoProd": "http://127.0.0.1:8000/media/images/balaio.png",
      "Precio": "7000.00",
      "Estado": true,
      "FechaPub": "2025-07-05T23:56:06Z",
      "tipoCategoria": "Mimbre",
      "tienda": 1,
    };

    // Crear producto desde JSON
    final producto = Producto.fromJson(testData);

    return Scaffold(
      appBar: AppBar(title: const Text('Test de Imagen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Producto: ${producto.nomprod}'),
            const SizedBox(height: 16),
            Text('URL Original API: ${testData['FotoProd']}'),
            const SizedBox(height: 8),
            Text('URL Procesada: ${producto.fotoProd}'),
            const SizedBox(height: 16),
            const Text('Imagen:'),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child:
                  producto.fotoProd != null && producto.fotoProd!.isNotEmpty
                      ? Image.network(
                        producto.fotoProd!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print(
                            '🚨 ERROR Test - No se pudo cargar imagen: ${producto.fotoProd}',
                          );
                          print('🚨 ERROR Test - Error: $error');
                          print('🚨 ERROR Test - StackTrace: $stackTrace');
                          return Container(
                            color: Colors.red[100],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 50,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Error al cargar imagen',
                                  style: TextStyle(color: Colors.red[700]),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  error.toString(),
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                      : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Test manual de la URL
                print('🧪 Testing URL manualmente: ${producto.fotoProd}');

                // Mostrar información útil en consola
                print('🧪 URL Original de API: ${testData['FotoProd']}');
                print('🧪 URL Procesada por modelo: ${producto.fotoProd}');
                print(
                  '🧪 ¿Son iguales?: ${testData['FotoProd'] == producto.fotoProd}',
                );
              },
              child: const Text('Test URLs'),
            ),
          ],
        ),
      ),
    );
  }
}
