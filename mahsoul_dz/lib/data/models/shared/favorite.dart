class FavoriteModel {
  final String id;
  final String customerId;
  final String productId;
  final int createdAt;
  final Map<String, dynamic>? product;

  FavoriteModel({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.createdAt,
    this.product,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      productId: json['product_id'] as String,
      createdAt: json['created_at'] as int,
      product: json['product'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'product_id': productId,
      'created_at': createdAt,
      'product': product,
    };
  }

  // Helper getters for product data
  String get productName => product?['name'] as String? ?? '';
  String get productCategory => product?['category'] as String? ?? '';
  double get productPrice => (product?['price'] as num?)?.toDouble() ?? 0.0;
  String get productImagePath => product?['image_path'] as String? ?? '';
  double get productRating => (product?['rating'] as num?)?.toDouble() ?? 0.0;
  String get farmerId => product?['farmer_id'] as String? ?? '';
}
