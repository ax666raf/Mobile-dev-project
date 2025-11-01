import 'package:flutter/material.dart';
import 'package:mahsoul_dz/models/product_model.dart';

class ProductController extends ChangeNotifier {
  ProductModel? _product;
  String _selectedWeight = '';
  List<Review> _reviews = [];

  ProductModel? get product => _product;
  String get selectedWeight => _selectedWeight;
  List<Review> get reviews => _reviews;

  void initializeProduct(String productId) {
    _product = _getProductDetails(productId);
    _reviews = _getProductReviews();
    if (_product != null) {
      _selectedWeight = _product!.weights.firstWhere((w) => w.available).value;
    }
    notifyListeners();
  }

  ProductModel _getProductDetails(String productId) {
    // In a real app, you'd fetch this from API based on productId
    return ProductModel(
      name: "Fresh Organic Tomatoes",
      description: "Organic tomatoes grown with sustainable farming practices. Locally-picked, Bilaalo, Algeria. Family-owned farm since 1987.",
      rating: 4.8,
      reviews: 5,
      price: 100,
      currency: "DA",
      deliveryFee: "FREE",
      origin: "Bilaalo, Algeria",
      harvestSeason: "All Year",
      isOrganic: true,
      storageInstructions: "Store at room temperature. Refrigerate only if fully ripe.",
      category: "Vegetables",
      weights: [
        WeightOption(value: "5kg", available: true),
        WeightOption(value: "10kg", available: true),
        WeightOption(value: "20kg", available: true),
      ],
      seller: SellerInfo(
        name: "Adam's Organic Farm",
        type: "Verified Farmer",
        rating: 4.8,
        reviews: 8,
      ),
      features: [
        FeatureItem(icon: "🏆", label: "1000 SA"),
        FeatureItem(icon: "📦", label: "10 KG"),
        FeatureItem(icon: "🏪", label: "Store"),
      ],
    );
  }

  List<Review> _getProductReviews() {
    return [
      Review(
        id: '1',
        userName: 'Sarah M.',
        rating: 5.0,
        comment: 'Excellent quality! Very fresh and tasty tomatoes.',
        date: DateTime(2024, 1, 15),
      ),
      Review(
        id: '2',
        userName: 'Ahmed K.',
        rating: 4.0,
        comment: 'Good tomatoes, perfect for cooking.',
        date: DateTime(2024, 1, 10),
      ),
      Review(
        id: '3',
        userName: 'Fatima Z.',
        rating: 4.8,
        comment: 'Fresh and flavorful. Will buy again!',
        date: DateTime(2024, 1, 5),
      ),
    ];
  }

  void selectWeight(String weight) {
    _selectedWeight = weight;
    notifyListeners();
  }

  void addToCart() {
    if (_product != null) {
      print('Added ${_product!.name} ($_selectedWeight) to cart');
      // Add your cart logic here
    }
  }

  void buyNow() {
    if (_product != null) {
      print('Buying ${_product!.name} ($_selectedWeight) now');
      // Add your buy now logic here
    }
  }
}