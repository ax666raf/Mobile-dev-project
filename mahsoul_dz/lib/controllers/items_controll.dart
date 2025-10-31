
import 'package:flutter/material.dart';
import 'package:mahsoul_dz/models/product_model.dart';
class ProductController extends ChangeNotifier {
  final ProductModel product;
  String _selectedWeight = '10kg';

  ProductController({required this.product});

  String get selectedWeight => _selectedWeight;

  void selectWeight(String weight) {
    _selectedWeight = weight;
    notifyListeners();
  }

  void addToCart() {
    // Add to cart logic here
    print('Added to cart: $_selectedWeight of ${product.name}');
  }
}
