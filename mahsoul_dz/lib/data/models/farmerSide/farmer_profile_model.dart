class FarmerProfileModel {
  final String farmName;
  final String farmerName;
  final String profileImageUrl;
  final bool isVerified;
  final String farmLocation;
  final String established;
  final String contactNumber;
  final String emailAddress;
  final int ordersCompleted;
  final double totalEarnings;
  final String currency;
  final int activeProducts;

  FarmerProfileModel({
    required this.farmName,
    required this.farmerName,
    required this.profileImageUrl,
    required this.isVerified,
    required this.farmLocation,
    required this.established,
    required this.contactNumber,
    required this.emailAddress,
    required this.ordersCompleted,
    required this.totalEarnings,
    required this.currency,
    required this.activeProducts,
  });

  // Factory method to create from JSON (for future API integration)
  factory FarmerProfileModel.fromJson(Map<String, dynamic> json) {
    return FarmerProfileModel(
      farmName: json['farmName'] ?? '',
      farmerName: json['farmerName'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      isVerified: json['isVerified'] ?? false,
      farmLocation: json['farmLocation'] ?? '',
      established: json['established'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      ordersCompleted: json['ordersCompleted'] ?? 0,
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'DA',
      activeProducts: json['activeProducts'] ?? 0,
    );
  }

  // Method to convert to JSON (for future API integration)
  Map<String, dynamic> toJson() {
    return {
      'farmName': farmName,
      'farmerName': farmerName,
      'profileImageUrl': profileImageUrl,
      'isVerified': isVerified,
      'farmLocation': farmLocation,
      'established': established,
      'contactNumber': contactNumber,
      'emailAddress': emailAddress,
      'ordersCompleted': ordersCompleted,
      'totalEarnings': totalEarnings,
      'currency': currency,
      'activeProducts': activeProducts,
    };
  }

  // Create a copy with updated fields
  FarmerProfileModel copyWith({
    String? farmName,
    String? farmerName,
    String? profileImageUrl,
    bool? isVerified,
    String? farmLocation,
    String? established,
    String? contactNumber,
    String? emailAddress,
    int? ordersCompleted,
    double? totalEarnings,
    String? currency,
    int? activeProducts,
  }) {
    return FarmerProfileModel(
      farmName: farmName ?? this.farmName,
      farmerName: farmerName ?? this.farmerName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isVerified: isVerified ?? this.isVerified,
      farmLocation: farmLocation ?? this.farmLocation,
      established: established ?? this.established,
      contactNumber: contactNumber ?? this.contactNumber,
      emailAddress: emailAddress ?? this.emailAddress,
      ordersCompleted: ordersCompleted ?? this.ordersCompleted,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      currency: currency ?? this.currency,
      activeProducts: activeProducts ?? this.activeProducts,
    );
  }
}



