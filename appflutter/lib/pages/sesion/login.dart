import 'registro.dart';
import 'package:flutter/material.dart';
import 'package:appflutter/pages/inicio/main_scaffold.dart';
import 'package:appflutter/pages/Administrador/main_admin.dart';
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
      final respuesta = await APIIngreso.ingresoUsuario(
        nameController.text,
        passwordController.text,
      );

      if (respuesta != null) {
        showSnackbar("Login exitoso!");

        // Redireccionar basado en el tipo de usuario
        if (respuesta['tipo_usuario'] == 'administrador') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainAdminView()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainScaffold()),
            (route) => false,
          );
        }
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
      backgroundColor: Color(0xff1f1e2a),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/LogoHG.png',
                width: 140,
                height: 140,
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
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Ingresar',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                cursorColor: Colors.white,
                controller: nameController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                  filled: false,
                  fillColor: Color(0xff2c2b3a),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffae92f2),
                      width: 1.5,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                cursorColor: Colors.white,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                controller: passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffae92f2),
                      width: 1.5,
                    ),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Redirigir a recuperación (opcional)
              },
              child: const Text(
                '¿Olvidó su contraseña?',
                style: TextStyle(color: Colors.white),
              ),
            ),

            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xffe8d0f8),
                    Color(0xffae92f2),
                    Color(0xff9dd5f3),
                  ], // Aquí defines los colores del gradiente
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _isLoading ? null : loginWithBackend,
                  child: Center(
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Acceder como Usuario',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '¿No tiene cuenta?',
                  style: const TextStyle(color: Colors.white),
                ),
                TextButton(
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(fontSize: 20, color: Color(0xff9dd5f3)),
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
