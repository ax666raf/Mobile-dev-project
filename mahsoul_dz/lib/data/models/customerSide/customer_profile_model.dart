class CustomerProfileModel {
  final String name;
  final String email;
  final String phone;
  final String profileImagePath;
  final String userType;
  final int totalOrders;
  final String joinDate;

  CustomerProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImagePath,
    required this.userType,
    required this.totalOrders,
    required this.joinDate,
  });

  // Factory method to create from JSON (for future API integration)
  factory CustomerProfileModel.fromJson(Map<String, dynamic> json) {
    return CustomerProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImagePath: json['profileImagePath'] ?? '',
      userType: json['userType'] ?? 'Regular Customer',
      totalOrders: json['totalOrders'] ?? 0,
      joinDate: json['joinDate'] ?? '',
    );
  }

  // Method to convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImagePath': profileImagePath,
      'userType': userType,
      'totalOrders': totalOrders,
      'joinDate': joinDate,
    };
  }

  // Create a copy with updated fields
  CustomerProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImagePath,
    String? userType,
    int? totalOrders,
    String? joinDate,
  }) {
    return CustomerProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      userType: userType ?? this.userType,
      totalOrders: totalOrders ?? this.totalOrders,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}



