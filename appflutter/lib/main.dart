import 'package:appflutter/pages/Sesion/registro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/Inicio/main_scaffold.dart';
import 'pages/Sesion/login.dart';
import 'pages/Tienda/CrearTienda.dart';
import 'pages/Administrador/main_admin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String? tipoUsuario = prefs.getString('tipo_usuario');

  runApp(
    ProviderScope(
      child: MyApp(isLoggedIn: isLoggedIn, tipoUsuario: tipoUsuario),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? tipoUsuario;

  const MyApp({super.key, required this.isLoggedIn, this.tipoUsuario});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handmade Geeks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      // Mostramos la pantalla correspondiente basado en el estado de login y tipo de usuario
      initialRoute: _getInitialRoute(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const SigninPage(),
        '/home': (context) => const MainScaffold(),
        '/crearTienda': (context) => const CrearTienda(),
        '/admin': (context) => const MainAdminView(),
      },
    );
  }

  String _getInitialRoute() {
    if (!isLoggedIn) {
      return '/login';
    }

    // Si está logueado, verificar el tipo de usuario
    if (tipoUsuario == 'administrador') {
      return '/admin';
    } else {
      return '/home';
    }
  }
}
