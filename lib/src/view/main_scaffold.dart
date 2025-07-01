import 'package:flutter/material.dart';
import 'package:Flutter/src/view/MiPerfil.dart';
import 'package:Flutter/src/view/MiTienda.dart';
import 'package:Flutter/src/view/Seguidos.dart';
import 'package:Flutter/src/view/cart_view.dart';
import 'package:Flutter/src/view/home.dart';
import 'package:Flutter/src/view/widgets/custom_app_bar.dart';
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  final searchController = TextEditingController();

  final List<Widget> _pages = const [
    HomeView(),
    CartView(),
    MiPerfil(),
    FollowedPage(),
    MiTienda()
    //Center(child: Text('La Belen es tan pero tan watona que')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        controller: searchController,
        //onCartPressed: _onCartPressed,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout), label: 'Carrito'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Tienda'),
        ],
      ),
    );
  }
}
