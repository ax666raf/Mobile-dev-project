class OrderModel {
  final String id;
  final String productName;
  final String farmName;
  final String price;
  final String status;
  final String imagePath;
  final DateTime orderDate;

  OrderModel({
    required this.id,
    required this.productName,
    required this.farmName,
    required this.price,
    required this.status,
    required this.imagePath,
    required this.orderDate,
  });

  // Get status color based on status
  int get statusColor {
    switch (status.toLowerCase()) {
      case 'awaiting confirmation':
        return 0xFF4CAF50; // Green
      case 'on going':
      case 'ongoing':
        return 0xFFFF9800; // Orange
      case 'delivered':
        return 0xFF2196F3; // Blue
      case 'cancelled':
        return 0xFFF44336; // Red
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  // Check if order matches filter
  bool matchesFilter(String filter) {
    switch (filter.toLowerCase()) {
      case 'all orders':
        return true;
      case 'ongoing':
        return status.toLowerCase() == 'on going' || 
               status.toLowerCase() == 'ongoing' ||
               status.toLowerCase() == 'awaiting confirmation';
      case 'delivered':
        return status.toLowerCase() == 'delivered';
      default:
        return true;
    }
  }

  // Factory method to create from JSON (for future API integration)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      productName: json['productName'] ?? '',
      farmName: json['farmName'] ?? '',
      price: json['price'] ?? '',
      status: json['status'] ?? '',
      imagePath: json['imagePath'] ?? '',
      orderDate: json['orderDate'] != null 
          ? DateTime.parse(json['orderDate'])
          : DateTime.now(),
    );
  }

  // Method to convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'farmName': farmName,
      'price': price,
      'status': status,
      'imagePath': imagePath,
      'orderDate': orderDate.toIso8601String(),
    };
  }
}
