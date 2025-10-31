import 'package:mahsoul_dz/models/product_model.dart';

import 'package:mahsoul_dz/models/product_model.dart';

class MarketController {
  final List<ProductModel> _products = [
    ProductModel(
      name: "Fresh Tomatoes",
      description: "Organic fresh tomatoes from local farms",
      rating: 4.4,
      reviews: 156,
      price: 299,
      currency: "\$",
      deliveryFee: "Free",
      origin: "Local Farm",
      harvestSeason: "All Season",
      isOrganic: true,
      storageInstructions: "Keep in cool place",
      category: "Vegetables", // Add category
      weights: [
        WeightOption(value: "500g", available: true),
        WeightOption(value: "1kg", available: true),
      ],
      seller: SellerInfo(
        name: "FreshFarm Organics",
        type: "Verified Seller",
        rating: 4.7,
        reviews: 2341,
      ),
      features: [
        FeatureItem(icon: "🌱", label: "Organic"),
        FeatureItem(icon: "🚚", label: "Fast Delivery"),
      ],
    ),
    ProductModel(
      name: "Organic Apples",
      description: "Sweet and crunchy organic apples",
      rating: 4.6,
      reviews: 89,
      price: 399,
      currency: "\$",
      deliveryFee: "Free",
      origin: "Washington",
      harvestSeason: "Fall",
      isOrganic: true,
      storageInstructions: "Refrigerate for freshness",
      category: "Fruits", // Add category
      weights: [
        WeightOption(value: "1kg", available: true),
        WeightOption(value: "2kg", available: true),
      ],
      seller: SellerInfo(
        name: "Apple Orchard",
        type: "Verified Seller",
        rating: 4.8,
        reviews: 1567,
      ),
      features: [
        FeatureItem(icon: "🌱", label: "Organic"),
        FeatureItem(icon: "🏷️", label: "Discount"),
      ],
    ),
    ProductModel(
      name: "Organic Bananas",
      description: "Fresh yellow bananas",
      rating: 4.3,
      reviews: 203,
      price: 199,
      currency: "\$",
      deliveryFee: "Free",
      origin: "Tropical Farm",
      harvestSeason: "Year Round",
      isOrganic: true,
      storageInstructions: "Store at room temperature",
      category: "Fruits", // Add category
      weights: [
        WeightOption(value: "1kg", available: true),
      ],
      seller: SellerInfo(
        name: "Tropical Fruits Co.",
        type: "Verified Seller",
        rating: 4.5,
        reviews: 892,
      ),
      features: [
        FeatureItem(icon: "🌱", label: "Organic"),
        FeatureItem(icon: "⚡", label: "Fast Delivery"),
      ],
    ),
    ProductModel(
      name: "Fresh Carrots",
      description: "Sweet and crunchy carrots",
      rating: 4.2,
      reviews: 134,
      price: 149,
      currency: "\$",
      deliveryFee: "Free",
      origin: "Local Farm",
      harvestSeason: "Spring",
      isOrganic: false,
      storageInstructions: "Keep in refrigerator",
      category: "Vegetables", // Add category
      weights: [
        WeightOption(value: "500g", available: true),
        WeightOption(value: "1kg", available: true),
      ],
      seller: SellerInfo(
        name: "Vegetable Garden",
        type: "Verified Seller",
        rating: 4.4,
        reviews: 567,
      ),
      features: [
        FeatureItem(icon: "💰", label: "Best Price"),
        FeatureItem(icon: "🚚", label: "Free Delivery"),
      ],
    ),
    // Add more products for other categories...
  ];

  List<ProductModel> getFeaturedProducts() {
    return _products;
  }

  List<ProductModel> getByCategory(String category) {
    if (category == 'All') return _products;
    return _products.where((product) => product.category == category).toList();
  }
  
  // Optional: Add search functionality
  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return _products;
    return _products.where((product) => 
      product.name.toLowerCase().contains(query.toLowerCase()) ||
      product.description.toLowerCase().contains(query.toLowerCase()) ||
      product.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}