class ProductModel {
  final String name;
  final String description;
  final double rating;
  final int reviews;
  final int price;
  final String currency;
  final String deliveryFee;
  final List<WeightOption> weights;
  final SellerInfo seller;
  final List<FeatureItem> features;
  final String origin;
  final String harvestSeason;
  final bool isOrganic;
  final String storageInstructions;
final String category;  
  ProductModel({
    required this.name,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.currency,
    required this.deliveryFee,
    required this.weights,
    required this.seller,
    required this.features,
    required this.category,
    this.origin = "Not specified", // Default value
    this.harvestSeason = "Not specified", // Default value
    this.isOrganic = false, // Default value
    this.storageInstructions = "Not specified", // Default value
  });
}

class WeightOption {
  final String value;
  final bool available;

  WeightOption({required this.value, required this.available});
}

class SellerInfo {
  final String name;
  final String type;
  final double rating;
  final int reviews;

  SellerInfo({
    required this.name,
    required this.type,
    required this.rating,
    required this.reviews,
  });
}

class FeatureItem {
  final String icon;
  final String label;

  FeatureItem({required this.icon, required this.label});
}

class Review {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}