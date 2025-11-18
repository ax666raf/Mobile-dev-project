import 'package:mahsoul_dz/views/models/customerSide/product_model.dart';

class ProductController {
  ProductModel getProductDetails(String productId) {
    return ProductModel(
      name: "Fresh Organic Apples",
      description:
          "Crispy, sweet and freshly harvested organic apples from our farm",
      rating: 4.4,
      reviews: 156,
      price: 299,
      currency: "\$",
      deliveryFee: "Free",
      origin: "Washington, USA",
      harvestSeason: "September - November",
      isOrganic: true,
      storageInstructions:
          "Keep in cool, dry place. Refrigerate for longer freshness.",
      category: "Fruits",
      weights: [
        WeightOption(value: "500g", available: true),
        WeightOption(value: "1kg", available: true),
        WeightOption(value: "2kg", available: false),
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
        FeatureItem(icon: "💰", label: "Best Price"),
      ],
    );
  }

  List<Review> getProductReviews() {
    return [
      Review(
        id: '1',
        userName: 'John Doe',
        rating: 5.0,
        comment: 'Excellent quality! Very fresh and tasty.',
        date: DateTime(2024, 1, 15),
      ),
      Review(
        id: '2',
        userName: 'Jane Smith',
        rating: 4.0,
        comment: 'Good apples, but a bit expensive.',
        date: DateTime(2024, 1, 10),
      ),
      Review(
        id: '3',
        userName: 'Mike Johnson',
        rating: 4.2,
        comment: 'Fresh and crunchy. Will buy again!',
        date: DateTime(2024, 1, 5),
      ),
    ];
  }

  void addToCart(ProductModel product, String selectedWeight) {
    print('Added ${product.name} ($selectedWeight) to cart');
  }

  void buyNow(ProductModel product, String selectedWeight) {
    print('Buying ${product.name} ($selectedWeight) now');
  }
}
