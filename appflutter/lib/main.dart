import 'package:appflutter/pages/Sesion/registro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/Inicio/main_scaffold.dart';
import 'pages/Sesion/login.dart';
import 'pages/Tienda/CrearTienda.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // runApp(MyApp(isLoggedIn: isLoggedIn));
  // const ProviderScope(child: MyApp()),
  runApp(ProviderScope(child: MyApp(isLoggedIn: isLoggedIn)));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handmade Geeks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      // Mostramos la pantalla correspondiente
      initialRoute: isLoggedIn ? '/home' : '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const SigninPage(),
        '/home': (context) => const MainScaffold(),
        '/crearTienda': (context) => const CrearTienda(),
      },
    );
  }
}
