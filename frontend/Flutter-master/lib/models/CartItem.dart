// lib/src/model/cart_item.dart

import 'ProductModel.dart';

class CartItem {
  final Welcome product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
