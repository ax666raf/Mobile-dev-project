class Customer {
  final String id;
  final String fullName;
  final String? phoneNumber;

  const Customer({
    required this.id,
    required this.fullName,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
      };

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as String,
        fullName: json['fullName'] as String? ?? json['full_name'] as String? ?? '',
        phoneNumber: json['phoneNumber'] as String? ?? json['phone_number'] as String?,
      );
}



