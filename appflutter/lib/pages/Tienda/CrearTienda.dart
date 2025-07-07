import 'package:flutter/material.dart';

class CrearTienda extends StatefulWidget {
  const CrearTienda({super.key});

  @override
  State<CrearTienda> createState() => _CreartiendaState();
}

class _CreartiendaState extends State<CrearTienda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Tienda'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No tienes una tienda creada XD Aur? tengo sueño ayuda'),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes implementar la lógica para crear una tienda
              },
              child: const Text('Crear Tienda'),
            ),
          ],
        ),
      ),
    );
  }
}