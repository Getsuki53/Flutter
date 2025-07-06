import 'package:flutter/material.dart';
import 'package:appflutter/pages/Carrito/miCarrito.dart';
import 'package:appflutter/pages/PerfilUsuario/MiPerfil.dart';
import 'package:appflutter/pages/seguidos/Seguidos.dart';
import 'package:appflutter/pages/Inicio/home.dart';
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
      const HomeView(),
      // Si usuarioId aún no está disponible, muestra un loader
      usuarioId == null
          ? const Center(child: CircularProgressIndicator())
          : CartView(usuarioId: usuarioId!),
      const MiPerfil(),
      const FollowedPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
      ),
    );
  }
}
