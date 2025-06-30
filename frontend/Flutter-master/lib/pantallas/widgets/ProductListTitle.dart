import 'package:flutter/material.dart';
import 'package:prueba1/models/ProductModel.dart';
import '../DetalleProducto.dart';

class ProductListTile extends StatefulWidget {
  const ProductListTile({super.key, required this.product});

  final Welcome product;

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      // Aquí puedes guardar/eliminar el producto de una lista real
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleProducto(
              nombre: widget.product.title,
              descripcion: widget.product.description,
              precio: widget.product.price, // String
              imagen: widget.product.thumbnail, // Usa el campo correcto
              stock: widget.product.stock,      // int
              categoria: widget.product.category, // int o String según tu modelo
            )
          ),
        );
      },
      child: SingleChildScrollView(
        child: Container(
          height: size.height,
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.product.thumbnail,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        toggleFavorite();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFavorite ? Colors.red : Colors.white,
                          border: Border.all(
                            color: isFavorite ? Colors.red : Colors.black,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.white : Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.product.title,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "\$${widget.product.price}",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

