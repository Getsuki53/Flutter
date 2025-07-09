import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:appflutter/services/tienda/api_crear_tienda.dart';
import '../Tienda/MiTienda.dart';

class CrearTienda extends StatefulWidget {
  const CrearTienda({super.key});

  @override
  State<CrearTienda> createState() => _CrearTiendaState();
}

class _CrearTiendaState extends State<CrearTienda> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nombreTiendaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  
  bool _isLoading = false;
  int? _usuarioId;
  File? _imagenSeleccionada;
  Uint8List? _imagenBytes; // Para Flutter Web
  String? _nombreImagen;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUsuarioId();
  }

  Future<void> _loadUsuarioId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _usuarioId = prefs.getInt('usuario_id');
    });
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
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
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: const Icon(
        Icons.store,
        size: 60,
        color: Colors.grey,
      ),
    );
  }

  Future<void> _crearTienda() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_usuarioId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se pudo obtener el ID del usuario')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final resultado = await APICrearTienda.crearTienda(
          propietario: _usuarioId.toString(),
          nombreTienda: _nombreTiendaController.text.trim(),
          descripcionTienda: _descripcionController.text.trim(),
          imagenPath: _imagenSeleccionada?.path,
          imagenBytes: _imagenBytes,
          nombreImagen: _nombreImagen,
        );

        if (resultado != null) {
          // La API ahora retorna el mensaje directamente
          if (resultado.contains('exitosamente')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ $resultado'),
                backgroundColor: Colors.green,
              ),
            );
            
            // Navegar a MiTienda después de crear la tienda
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MiTienda()),
            );
          } else {
            // Mostrar mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ $resultado'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Error desconocido al crear la tienda'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nombreTiendaController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1e2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff383758),
        title: const Text('Crear Tienda', style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '¡Crea tu tienda!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Completa la información para crear tu tienda',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Logo de la tienda
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
                      icon: const Icon(Icons.store, color: Colors.blue),
                      label: Text(
                        _tieneImagen() ? 'Cambiar logo' : 'Agregar logo de tienda (opcional)',
                        style: const TextStyle(color: Color(0xff9dd5f3),),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Nombre de la tienda
              TextFormField(
                cursorColor: Colors.white,
                controller: _nombreTiendaController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Nombre de la tienda',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store, color: Colors.white,),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffae92f2),
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el nombre de la tienda';
                  }
                  if (value.trim().length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                cursorColor: Colors.white,
                controller: _descripcionController,
                style: TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la tienda',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description, color: Colors.white,),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffae92f2),
                      width: 1.5,
                    ),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  if (value.trim().length < 10) {
                    return 'La descripción debe tener al menos 10 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botón crear tienda
              ElevatedButton(
                onPressed: _isLoading ? null : _crearTienda,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff383758),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Crear Tienda',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              const SizedBox(height: 16),

              // Información adicional
              const Card(
                color: Color(0xff383758),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Color(0xff9dd5f3),),
                          SizedBox(width: 8),
                          Text(
                            'Información importante',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('• Tu tienda será revisada antes de aparecer públicamente',
                        style: TextStyle(color: Colors.white,),),
                      Text('• Podrás agregar productos una vez aprobada la tienda',
                        style: TextStyle(color: Colors.white,),),
                      Text('• El logo ayuda a que los clientes reconozcan tu marca',
                        style: TextStyle(color: Colors.white,),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}