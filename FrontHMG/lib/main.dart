import 'package:Flutter/src/view/main_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Flutter/src/view/sessions/login.dart';

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
      home: const MainScaffold(),
    );
  }
}
