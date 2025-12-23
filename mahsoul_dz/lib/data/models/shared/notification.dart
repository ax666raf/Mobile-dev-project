class NotificationModel {
  final String id;
  final String farmerId;
  final String orderId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final int createdAt;
  final Map<String, dynamic>? order;

  NotificationModel({
    required this.id,
    required this.farmerId,
    required this.orderId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.order,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      farmerId: json['farmer_id'] as String,
      orderId: json['order_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as int,
      order: json['order'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmer_id': farmerId,
      'order_id': orderId,
      'title': title,
      'message': message,
      'type': type,
      'is_read': isRead,
      'created_at': createdAt,
      'order': order,
    };
  }
}