import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:appflutter/services/productos/api_crear_producto.dart';
import 'package:appflutter/services/tienda/api_tienda_por_propietario.dart';

class PublicarProducto extends StatefulWidget {
  const PublicarProducto({super.key});

  @override
  State<PublicarProducto> createState() => _PublicarProductoState();
}

class _PublicarProductoState extends State<PublicarProducto> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  String? _categoriaSeleccionada;
  bool _isLoading = false;
  int? _usuarioId;
  int? _tiendaId;
  File? _imagenSeleccionada;
  Uint8List? _imagenBytes; // Para Flutter Web
  String? _nombreImagen;
  final ImagePicker _picker = ImagePicker();

  final List<String> _categorias = [
    'Lana',
    'Ropa',
    'Arcilla',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _usuarioId = prefs.getInt('usuario_id');
    
    if (_usuarioId != null) {
      // Obtener el ID de la tienda del usuario
      final tienda = await APIObtenerTiendaPorPropietario.obtenerTiendaPorPropietario(_usuarioId!);
      if (tienda != null && tienda.id != null) {
        setState(() {
          _tiendaId = tienda.id;
        });
      }
    }
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
      );
    } else if (!kIsWeb && _imagenSeleccionada != null) {
      return Image.file(
        _imagenSeleccionada!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _stockController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _confirmar() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_tiendaId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No se pudo obtener el ID de la tienda')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final success = await APICrearProducto.crearProducto(
          nombre: _nombreController.text.trim(),
          descripcion: _descripcionController.text.trim(),
          stock: int.parse(_stockController.text.trim()),
          precio: double.parse(_precioController.text.trim()),
          categoria: _categoriaSeleccionada!,
          tiendaId: _tiendaId!,
          imagenFile: _imagenSeleccionada,
          imagenBytes: _imagenBytes,
          nombreImagen: _nombreImagen,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Producto creado exitosamente! Será revisado por un administrador antes de ser publicado.')),
          );
          
          // Limpiar formulario
          _nombreController.clear();
          _descripcionController.clear();
          _stockController.clear();
          _precioController.clear();
          setState(() {
            _categoriaSeleccionada = null;
            _imagenSeleccionada = null;
            _imagenBytes = null;
            _nombreImagen = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al crear el producto. Inténtalo de nuevo.')),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del producto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _seleccionarImagen,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
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
                              Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'Toca para seleccionar imagen',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad en stock',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa la cantidad';
                  }
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad < 0) {
                    return 'Ingrese una cantidad válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _precioController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el precio';
                  }
                  final precio = double.tryParse(value);
                  if (precio == null || precio < 0) {
                    return 'Ingrese un precio válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descripcionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descripción breve',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: _categorias
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaSeleccionada = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona una categoría';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _confirmar,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Confirmar', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}