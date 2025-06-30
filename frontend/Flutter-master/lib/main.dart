import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pantallas/sesion/Ingreso.dart';

void main() {
  runApp(
    ProviderScope(child: MiTiendaApp()),
  );
}

class MiTiendaApp extends StatelessWidget {
  const MiTiendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Tienda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
