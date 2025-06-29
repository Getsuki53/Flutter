import 'package:flutter/material.dart';

class DetalleProducto extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final int precio;
  final String imagen;

  const DetalleProducto({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nombre)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                imagen,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(descripcion),
            const SizedBox(height: 16),
            Text('Precio: \$${precio.toString()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

