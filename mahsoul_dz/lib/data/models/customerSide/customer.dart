class Customer {
  final String id;
  final String fullName;
  

  const Customer({required this.id, required this.fullName});

  Map<String, dynamic> toJson() => {'id': id, 'fullName': fullName};

  factory Customer.fromJson(Map<String, dynamic> json) =>
      Customer(id: json['id'] as String, fullName: json['fullName'] as String);
}



