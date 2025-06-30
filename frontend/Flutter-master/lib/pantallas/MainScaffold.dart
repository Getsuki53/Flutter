// lib/src/view/main_scaffold.dart

import 'package:flutter/material.dart';
import 'MiPerfil.dart';
import 'MiTienda.dart';
import 'CartView.dart';
import 'Home.dart';
import 'widgets/CustomAppBar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  final searchController = TextEditingController();

  final List<Widget> _pages = const [
    HomePage(),
    CartView(),
    MiTienda(),
    MiPerfil(),
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
        ],
      ),
    );
  }
}
