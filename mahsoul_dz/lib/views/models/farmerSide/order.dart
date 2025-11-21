import 'package:mahsoul_dz/views/models/customerSide/customer.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

class Order {
  final Customer customer;
  final String farmer;
  final double weight; // in kg
  final double totalPrice;
  final OrderStatus status;
  final String deliveryMethod;
  final String address;
  final String paymentMethod;
  final String paymentStatus;
  final String? id;  // optional for now

  const Order({
    required this.customer,
    required this.farmer,
    required this.weight,
    required this.totalPrice,
    required this.status,
    required this.deliveryMethod,
    required this.address,
    required this.paymentMethod,
    required this.paymentStatus,
    this.id,
  });

  // Convert OrderStatus enum to String
  String get statusString {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Convert String to OrderStatus enum
  static OrderStatus statusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer': customer.toJson(),
        'farmer': farmer,
        'weight': weight,
        'totalPrice': totalPrice,
        'status': statusString,
        'deliveryMethod': deliveryMethod,
        'address': address,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
      };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'] as String?,
        customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
        farmer: json['farmer'] as String,
        weight: (json['weight'] as num).toDouble(),
        totalPrice: (json['totalPrice'] as num).toDouble(),
        status: statusFromString(json['status'] as String),
        deliveryMethod: json['deliveryMethod'] as String,
        address: json['address'] as String,
        paymentMethod: json['paymentMethod'] as String,
        paymentStatus: json['paymentStatus'] as String,
      );
}

