class ReviewModel {
  final String id;
  final String productId;
  final String customerId;
  final double rating;
  final String comment;
  final int createdAt;
  final Map<String, dynamic>? customer;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.customer,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      customerId: json['customer_id'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] as int,
      customer: json['customer'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'customer_id': customerId,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt,
      'customer': customer,
    };
  }

  String get customerName {
    if (customer != null) {
      return customer!['full_name'] as String? ?? 'Anonymous';
    }
    return 'Anonymous';
  }

  String get customerInitials {
    final name = customerName;
    if (name.isEmpty || name == 'Anonymous') return 'A';
    return name
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .take(2)
        .join()
        .toUpperCase();
  }
}
