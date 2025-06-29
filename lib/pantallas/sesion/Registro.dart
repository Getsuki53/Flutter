import 'package:flutter/material.dart';
import 'Ingreso.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rPasswordController = TextEditingController();

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> signin() async {
    if (nameController.text.isEmpty || passwordController.text.isEmpty || mailController.text.isEmpty) {
      showSnackbar(
        "${nameController.text.isEmpty ? "-User " : ""} ${mailController.text.isEmpty ? "- Correo " : ""} ${passwordController.text.isEmpty ? "- Contraseña " : ""} requerido");
      return;
    }

    if (passwordController.text != rPasswordController.text) {
      showSnackbar(
        "Las contraseñas no coinciden"
      );
      return;
    }
    else {
      showSnackbar(
        "Sign in Proceso"
      );
      return;
    }

    // final datosUsuario = {
    //   "username": nameController.text,
    //   "mail": mailController.text,
    //   "password": passwordController.text
    // };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Handmade Geeks")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('lib/imagenes/perro.jpeg', width: 70, height: 70),
                  const SizedBox(width: 10),
                  const Text('Handmade Geeks',
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan
                    )
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Registrarse',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre de Usuario',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: mailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contraseña',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: rPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Repetir Contraseña',
                ),
              ),
            ),
            Container(
              height: 60,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                onPressed: signin,
                child: const Text(
                  'Registrarse',
                  style: TextStyle(color: Colors.cyan),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Ya tengo cuenta'),
                TextButton(
                  child: const Text(
                    'Ingresar',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.cyan,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()),);
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
