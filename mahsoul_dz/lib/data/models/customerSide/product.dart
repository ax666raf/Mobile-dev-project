class Product {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final String farmName;
  final double price;
  final String category;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.farmName,
    required this.price,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
  });
}



