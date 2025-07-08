// lib/src/view/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff383758),
      elevation: 2,
      title: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Buscar productos...",
          hintStyle: TextStyle(color: Colors.black),
          prefixIconColor: Colors.black,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        ),
      ),
      /*actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartView()),
            );
          },
        )
      ],*/
    );
  }
}
