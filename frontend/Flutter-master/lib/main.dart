import 'package:flutter/material.dart';
import 'pantallas/sesion/Ingreso.dart';
import 'pantallas/Home.dart';

void main() {
  runApp(const MiTiendaApp());
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
      home: const AppEntry(),
    );
  }
}

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});
  
  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();

    // Esperar al primer frame antes de navegar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goToLogin();
    });
  }

  Future<void> _goToLogin() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );

    // El login fue exitoso si retornó true
    if (resultado == true) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loggedIn
        ? const HomePage()
        : const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
  }
}