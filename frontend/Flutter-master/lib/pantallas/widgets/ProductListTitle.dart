import 'package:flutter/material.dart';
import '../../models/producto.dart';
import '../DetalleProducto.dart';


class ProductListTile extends StatefulWidget {
  const ProductListTile({super.key, required this.product});

  final Producto product;

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  bool isFavorite = false;

  /*void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleProducto(
              nombre: widget.product.nomprod,
              descripcion: widget.product.descripcionProd,
              precio: widget.product.precio,
              imagen: widget.product.fotoProd ?? '',
              stock: widget.product.stock,
              categoria: widget.product.tipoCategoria, // Ajusta según tu modelo
            ),
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
                  widget.product.fotoProd != null && widget.product.fotoProd!.isNotEmpty
                      ? Image.network(
                          widget.product.fotoProd!,
                          height: 250,
                          fit: BoxFit.contain,
                        )
                      : const Icon(Icons.image_not_supported, size: 250),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      //onTap: toggleFavorite,
                      child: Container(
                        /*decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFavorite ? Colors.red : Colors.white,
                          border: Border.all(
                            color: isFavorite ? Colors.red : Colors.black,
                            width: 1.5,
                          ),
                        ),*/
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.product.nomprod,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '\$${widget.product.precio.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Usuario {
  final String correo;
  final String contrasena; // Cambia aquí

  Usuario({
    required this.correo,
    required this.contrasena, // Cambia aquí
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      correo: json['correo'] ?? '',
      contrasena: json['contraseña'] ?? '', // Cambia aquí
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'correo': correo,
      'contraseña': contrasena, // Cambia aquí
    };
  }
}

