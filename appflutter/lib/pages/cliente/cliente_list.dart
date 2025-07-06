import 'package:flutter/material.dart';

class ClientesList extends StatefulWidget {
  const ClientesList({Key? key}) : super(key: key);

  @override
  State<ClientesList> createState() => _ClientesListState();
}

class _ClientesListState extends State<ClientesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Clientes')),
      body: const Center(
        child: Text('Lista de Clientes', style: TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-cliente');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
