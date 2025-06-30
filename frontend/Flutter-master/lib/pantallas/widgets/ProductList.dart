import 'package:flutter/material.dart';
import 'package:prueba1/models/ProductModel.dart';
import 'package:prueba1/services/ProductService.dart';
import 'ProductListTitle.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key});

  @override
    Widget build(BuildContext context) {
      return FutureBuilder<List<Welcome>>(
        future: ProductService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final products = snapshot.data!;

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductListTile(product: products[index]);
            },
          );
        },
      );
    }
}