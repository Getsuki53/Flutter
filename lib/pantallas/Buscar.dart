import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  bool showFilters = false;

  void showSnackbar(String msg) {
    final snack = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  //Simulación de búsqueda
  final List<Map<String, dynamic>> productos = [
    {'nombre': 'Laptop HP', 'precio': 700},
    {'nombre': 'Mouse Logitech', 'precio': 30},
    {'nombre': 'Teclado Mecánico', 'precio': 100},
    {'nombre': 'Monitor Samsung', 'precio': 200},
    {'nombre': 'Impresora Canon', 'precio': 150},
    {'nombre': 'Tablet Lenovo', 'precio': 250},
    {'nombre': 'Laptop Dell', 'precio': 800},
  ];

  List<Map<String, dynamic>> resultados = [];

  void searchProduct(String nombreBuscado) {
    final minPrice = int.tryParse(minPriceController.text) ?? 0;
    final maxPrice = int.tryParse(maxPriceController.text) ?? 1000000;

    setState(() {
      resultados = productos.where((producto) {
        final nombre = producto['nombre'].toLowerCase(); // CORRECTO
        final precio = producto['precio'];
        return nombre.contains(nombreBuscado.toLowerCase()) &&
            precio >= minPrice &&
            precio <= maxPrice;
      }).toList();
    });
  }

  Future<void> switchOrder() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscar"),),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 7,
                    child: TextField(
                      controller: productNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre del producto',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Espacio entre campos
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: () {searchProduct(productNameController.text);},
                      child: const Text(
                        'Buscar',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(0),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showFilters = !showFilters;
                  });
                },
                child: Text(showFilters ? 'Ocultar filtros' : 'Mostrar filtros'),
              ),
            ),
            if (showFilters)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: minPriceController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Precio mínimo',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: maxPriceController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Precio máximo',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Espacio entre filtros y botón
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: switchOrder,
                      child: const Text(
                        'Más vendido',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: resultados.isEmpty ? 
              const Center(child: Text('No hay resultados')) : 
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //Columnas
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 5/4, //Si hay overflow, cambiar a 1
                ),
                itemCount: resultados.length,
                itemBuilder: (context, index) {
                  final producto = resultados[index];
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                          const SizedBox(height: 10),
                          Text(producto['nombre'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text('\$${producto['precio']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}