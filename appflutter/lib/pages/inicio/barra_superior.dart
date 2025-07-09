import 'package:flutter/material.dart';
import 'busqueda.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  //final VoidCallback onCartPressed;

  const CustomAppBar({
    super.key,
    required this.controller,
    //required this.onCartPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  void _realizarBusqueda(BuildContext context) {
    final query = controller.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultadosBusquedaPage(query: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff383758),
      elevation: 2,
      title: TextField(
        controller: controller,
        onSubmitted: (_) => _realizarBusqueda(context),
        decoration: InputDecoration(
          hintText: "Buscar productos...",
          hintStyle: TextStyle(color: Colors.black),
          prefixIconColor: Colors.black,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () => _realizarBusqueda(context),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        ),
      ),
    );
  }
}
