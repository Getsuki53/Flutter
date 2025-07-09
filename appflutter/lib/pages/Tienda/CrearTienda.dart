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
      return Image.memory(
        _imagenBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (!kIsWeb && _imagenSeleccionada != null) {
      return Image.file(
        _imagenSeleccionada!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return const SizedBox.shrink();
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
        String? imagePath;
        if (!kIsWeb && _imagenSeleccionada != null) {
          imagePath = _imagenSeleccionada!.path;
        }
        // Para web necesitaríamos modificar la API para manejar bytes

        final resultado = await APICrearTienda.crearTienda(
          propietario: _usuarioId.toString(),
          nombreTienda: _nombreTiendaController.text.trim(),
          descripcionTienda: _descripcionController.text.trim(),
          imagenPath: imagePath,
        );

        if (resultado != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('¡Tienda creada exitosamente! $resultado')),
          );
          
          // Navegar a MiTienda después de crear la tienda
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MiTienda()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al crear la tienda. Inténtalo de nuevo.')),
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
      appBar: AppBar(
        title: const Text('Crear Tienda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '¡Crea tu tienda!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Completa la información para crear tu tienda',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Nombre de la tienda
              TextFormField(
                controller: _nombreTiendaController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la tienda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.store),
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

              // Logo de la tienda
              const Text(
                'Logo de la tienda (opcional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _seleccionarImagen,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _tieneImagen()
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _construirImagen(),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'Toca para seleccionar logo',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                controller: _descripcionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la tienda',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
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
                        style: TextStyle(fontSize: 18),
                      ),
              ),
              const SizedBox(height: 16),

              // Información adicional
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Información importante',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('• Tu tienda será revisada antes de aparecer públicamente'),
                      Text('• Podrás agregar productos una vez creada la tienda'),
                      Text('• El logo ayuda a que los clientes reconozcan tu marca'),
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