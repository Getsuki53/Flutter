import 'package:flutter/material.dart';
import 'package:appflutter/pages/Carrito/miCarrito.dart';
import 'package:appflutter/pages/PerfilUsuario/MiPerfil.dart';
import 'package:appflutter/pages/Deseados/Deseados.dart';
import 'package:appflutter/pages/inicio/home.dart';
import 'package:appflutter/pages/Producto/detalle_producto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int? usuarioId;
  int _selectedIndex = 0;
  final searchController = TextEditingController();

  // Nuevo: Estado para mostrar el detalle
  Widget? _detalleProducto;

  void mostrarDetalleProducto({
    required int id,
    required String nombre,
    required String descripcion,
    required double precio,
    required String imagen,
    required int stock,
    required String? categoria,
  }) {
    setState(() {
      _detalleProducto = DetalleProducto(
        id: id,
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        imagen: imagen,
        stock: stock,
        categoria: categoria,
        onCerrar: cerrarDetalleProducto, // <-- Agrega esto
      );
    });
  }

  void cerrarDetalleProducto() {
    setState(() {
      _detalleProducto = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsuarioId();
  }

  Future<void> _loadUsuarioId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      usuarioId = prefs.getInt('usuario_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeView(onVerDetalle: mostrarDetalleProducto),
      usuarioId == null
          ? const Center(child: CircularProgressIndicator())
          : CartView(usuarioId: usuarioId!),
      const MiPerfil(),
      usuarioId == null
          ? const Center(child: CircularProgressIndicator())
          : WishedPage(usuario_id: usuarioId!),
    ];

    return Scaffold(
      body: _detalleProducto != null
          ? Stack(
              children: [
                pages[_selectedIndex],
                // Capa superior: DetalleProducto (sin botón de cerrar)
                Positioned.fill(
                  child: Material(
                    color: Colors.black.withOpacity(0.85),
                    child: Column(
                      children: [
                        Expanded(child: _detalleProducto!),
                        // Elimina el Padding con IconButton aquí
                      ],
                    ),
                  ),
                ),
              ],
            )
          : pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff383758),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _detalleProducto = null; // Cierra el detalle si cambias de tab
          });
        },
        selectedItemColor: Color(0xffe8d0f8),
        unselectedItemColor: Color(0xfffcf6ff),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_checkout),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}
