import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appflutter/pages/Administrador/home_admin.dart';

class MainAdminView extends StatefulWidget {
  const MainAdminView({super.key});

  @override
  State<MainAdminView> createState() => _MainAdminViewState();
}

class _MainAdminViewState extends State<MainAdminView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrador'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Limpiar las SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('tipo_usuario');
              await prefs.remove('usuario_id');
              await prefs.remove('admin_id');

              // Volver al login
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: const HomeAdminView(),
    );
  }
}
