import 'registro.dart';
import 'package:flutter/material.dart';
import 'package:appflutter/pages/inicio/main_scaffold.dart';
import 'package:appflutter/services/usuario/api_ingreso.dart';

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

  Future<void> loginWithBackend() async {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      showSnackbar("Usuario y contraseña requeridos");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final mensaje = await APIIngreso.ingresoUsuario(
        nameController.text,
        passwordController.text,
      );

      if (mensaje != null) {
        showSnackbar("Login exitoso!");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScaffold()),
          (route) => false,
        );
      } else {
        showSnackbar("Usuario o contraseña incorrectos");
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
                'lib/imagenes/logo.png',
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

            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: _isLoading ? null : loginWithBackend,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.cyan)
                    : const Text(
                        'Acceder',
                        style: TextStyle(color: Colors.cyan),
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