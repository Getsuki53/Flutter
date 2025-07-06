import 'package:flutter/material.dart';

class ProductosList extends StatefulWidget {
  const ProductosList({Key? key}) : super(key: key);

  @override
  State<ProductosList> createState() => _ProductosListState();
}

class _ProductosListState extends State<ProductosList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Productos')),
      body: const Center(
        child: Text('Lista de Productos', style: TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-producto');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
