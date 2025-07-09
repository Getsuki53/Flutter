import 'package:appflutter/services/usuario/api_registro.dart';
import 'package:appflutter/services/usuario/api_ingreso.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'login.dart';
import '../inicio/main_scaffold.dart';

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
  final TextEditingController rPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key for validation
  bool _isLoading = false;
  
  // Variables para manejo de imagen
  File? _imagenSeleccionada;
  Uint8List? _imagenBytes; // Para Flutter Web
  String? _nombreImagen;
  final ImagePicker _picker = ImagePicker();

  void showSnackbar(String msg) {
    final snack = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 4),
      backgroundColor: msg.contains('Error') || msg.contains('fallido') 
          ? Colors.red 
          : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> _seleccionarImagen() async {
    try {
      final XFile? imagen = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (imagen != null) {
        if (kIsWeb) {
          // Para Flutter Web, usar bytes
          final bytes = await imagen.readAsBytes();
          setState(() {
            _imagenBytes = bytes;
            _nombreImagen = imagen.name;
            _imagenSeleccionada = null; // Limpiar el File para evitar errores
          });
        } else {
          // Para móvil, usar File
          setState(() {
            _imagenSeleccionada = File(imagen.path);
            _imagenBytes = null;
            _nombreImagen = imagen.name;
          });
        }
      }
    } catch (e) {
      showSnackbar('Error al seleccionar imagen: $e');
    }
  }

  bool _tieneImagen() {
    return (kIsWeb && _imagenBytes != null) || (!kIsWeb && _imagenSeleccionada != null);
  }

  Widget _construirImagen() {
    if (kIsWeb && _imagenBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.memory(
          _imagenBytes!,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        ),
      );
    } else if (!kIsWeb && _imagenSeleccionada != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.file(
          _imagenSeleccionada!,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        ),
      );
    }
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(60),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(
        Icons.person,
        size: 60,
        color: Colors.grey,
      ),
    );
  }

  // Add email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> registerWithBackend() async {
    // Clear any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();
    
    // Validate form fields
    if (nameController.text.trim().isEmpty) {
      showSnackbar("El nombre es requerido");
      return;
    }
    
    if (emailController.text.trim().isEmpty) {
      showSnackbar("El correo electrónico es requerido");
      return;
    }
    
    if (!_isValidEmail(emailController.text.trim())) {
      showSnackbar("Ingrese un correo electrónico válido");
      return;
    }
    
    if (passwordController.text.isEmpty) {
      showSnackbar("La contraseña es requerida");
      showSnackbar("R : ${rPasswordController.text}");
      return;
    }

    if (rPasswordController.text != passwordController.text) {
      showSnackbar("Las contraseñas no coinciden");
      return;
    }
    
    if (passwordController.text.length < 6) {
      showSnackbar("La contraseña debe tener al menos 6 caracteres");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    print("Iniciando registro...");
    print("Email: ${emailController.text.trim()}");
    print("Nombre: ${nameController.text.trim()}");
    print("Apellido: ${apellidoController.text.trim()}");
    print("Contraseña length: ${passwordController.text.length}");
    print("Tiene imagen: ${_tieneImagen()}");

    try {
      showSnackbar("Enviando datos de registro...");
      
      final mensaje = await APIRegistro.registro(
          emailController.text.trim(),
          nameController.text.trim(),
          apellidoController.text.trim(),
          passwordController.text,
          imagenFile: _imagenSeleccionada,
          imagenBytes: _imagenBytes,
          nombreImagen: _nombreImagen,
      );

      if (mensaje == null) {
        // null significa éxito
        print("Registro exitoso!");
        showSnackbar("Usuario creado correctamente");
        
        // Hacer login automático después del registro exitoso
        showSnackbar("Iniciando sesión...");
        
        try {
          final respuestaLogin = await APIIngreso.ingresoUsuario(
            emailController.text.trim(),
            passwordController.text,
          );

          if (respuestaLogin != null) {
            showSnackbar("¡Bienvenido!");
            
            // Esperar un poco antes de navegar para que el usuario vea el mensaje
            await Future.delayed(const Duration(seconds: 1));
            
            if (mounted) {
              // Navegar directamente a la aplicación principal
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MainScaffold()),
                (route) => false,
              );
            }
          } else {
            // Si falla el login automático, ir a la página de login
            print("Login automático falló, redirigiendo al login");
            showSnackbar("Usuario creado. Por favor, inicia sesión");
            
            await Future.delayed(const Duration(seconds: 1));
            
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            }
          }
        } catch (e) {
          // Si hay error en el login automático, ir a la página de login
          print("Error en login automático: $e");
          showSnackbar("Usuario creado. Por favor, inicia sesión");
          
          await Future.delayed(const Duration(seconds: 1));
          
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        }
      } else {
        // String contiene el mensaje de error
        print("Registro fallido: $mensaje");
        showSnackbar('$mensaje');
      }
    } catch (e) {
      print("Excepción durante registro: $e");
      showSnackbar("Error de conexión: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1f1e2a),
      appBar: AppBar(
        title: const Text('Registro',
        style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xff383758),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Wrap in Form widget
          key: _formKey,
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
                const SizedBox(height: 20),
                // Sección de selección de imagen de perfil
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _seleccionarImagen,
                        child: _construirImagen(),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: _seleccionarImagen,
                        icon: const Icon(Icons.camera_alt, color: Color(0xff9dd5f3)),
                        label: Text(
                          _tieneImagen() ? 'Cambiar foto' : 'Agregar foto de perfil (opcional)',
                          style: const TextStyle(color: Color(0xff9dd5f3)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField( // Changed to TextFormField
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
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
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField( // Changed to TextFormField
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
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
                  child: TextFormField( // Changed to TextFormField
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El correo electrónico es requerido';
                      }
                      if (!_isValidEmail(value.trim())) {
                        return 'Ingrese un correo válido';
                      }
                      return null;
                    },
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
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField( // Changed to TextFormField
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña es requerida';
                      }
                      if (value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
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
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField( // Changed to TextFormField
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    controller: rPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Repetir Contraseña *',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffae92f2), width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.5),
                      ),
                      errorStyle: TextStyle(color: Colors.red),
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
      ),
    );
  }
}