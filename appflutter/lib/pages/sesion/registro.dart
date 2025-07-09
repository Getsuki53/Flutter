import 'package:appflutter/services/usuario/api_registro.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> registerWithBackend() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        nameController.text.isEmpty) {
      showSnackbar("Nombre, email y contraseña son requeridos");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final mensaje = await APIRegistro.registro(
          emailController.text,
          nameController.text,
          apellidoController.text,
          passwordController.text,
      );

      if (mensaje != null) {
        showSnackbar("Usuario registrado exitosamente!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        showSnackbar('Error de registro');
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
      backgroundColor: const Color(0xff1f1e2a),
      appBar: AppBar(
        title: const Text('Registro',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xffae92f2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/LogoHG.png',
                  width: 140,
                  height: 140,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image,
                      size: 70,
                      color: Colors.cyan,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Crear Cuenta',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre *',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.person, color: Colors.white,),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffae92f2), width: 1.5),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  controller: apellidoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Apellido (opcional)',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffae92f2), width: 1.5),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Correo electrónico *',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffae92f2), width: 1.5),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña *',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffae92f2), width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffe8d0f8), Color(0xffae92f2), Color(0xff9dd5f3)], // Gradiente cyan
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: _isLoading ? null : registerWithBackend,
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Registrarse',
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes cuenta?',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Color(0xff9dd5f3),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}