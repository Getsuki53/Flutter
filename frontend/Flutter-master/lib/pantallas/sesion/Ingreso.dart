import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Registro.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  // 🔥 NUEVA FUNCIÓN: Conectar con tu backend Django
  Future<void> loginWithBackend() async {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      showSnackbar("Usuario y contraseña requeridos");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 📡 Conectar a tu backend Django
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login-usuario/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'correo': nameController.text,
          'contrasena': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // ✅ Login exitoso
        showSnackbar("Login exitoso!");

        // Guardar token (opcional)
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('auth_token', data['token']);

        Navigator.pop(context, true);
      } else {
        final error = json.decode(response.body);
        showSnackbar(error['error'] ?? 'Error de login');
      }
    } catch (e) {
      showSnackbar("Error de conexión: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 🔥 TAMBIÉN login de administrador
  Future<void> loginAdmin() async {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      showSnackbar("Usuario y contraseña requeridos");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
          'http://127.0.0.1:8000/api/administrador/AutenticarAdministrador/',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'correo': nameController.text,
          'contraseña': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        showSnackbar("Admin login exitoso!");
        Navigator.pop(context, true);
      } else {
        final error = json.decode(response.body);
        showSnackbar(error['error'] ?? 'Error de admin login');
      }
    } catch (e) {
      showSnackbar("Error de conexión: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              alignment: Alignment.center,
              child: Image.asset(
                'lib/imagenes/perro.jpeg',
                width: 120,
                height: 70,
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Handmade Geeks',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 31, 210, 255),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text('Ingresar', style: TextStyle(fontSize: 20)),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo electrónico',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Redirigir a recuperación (opcional)
              },
              child: const Text(
                '¿Olvidó su contraseña?',
                style: TextStyle(color: Colors.cyan),
              ),
            ),
            // 🔥 BOTÓN LOGIN USUARIO
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _isLoading ? null : loginWithBackend,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.cyan)
                    : const Text(
                        'Acceder como Usuario',
                        style: TextStyle(color: Colors.cyan),
                      ),
              ),
            ),
            SizedBox(height: 10),
            // 🔥 BOTÓN LOGIN ADMIN
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _isLoading ? null : loginAdmin,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Acceder como Admin',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('¿No tiene cuenta?'),
                TextButton(
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 20, color: Colors.cyan),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SigninPage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
