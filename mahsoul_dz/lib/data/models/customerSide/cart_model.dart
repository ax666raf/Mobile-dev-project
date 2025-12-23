import 'package:mahsoul_dz/data/models/customerSide/product_model.dart';

class CartItem {
  final ProductModel product;
  final String selectedWeight;
  final int quantity;

  CartItem({
    required this.product,
    required this.selectedWeight,
    this.quantity = 1,
  });

  double get totalPrice => (product.price * quantity).toDouble();

  CartItem copyWith({
    ProductModel? product,
    String? selectedWeight,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      selectedWeight: selectedWeight ?? this.selectedWeight,
      quantity: quantity ?? this.quantity,
    );
  }
}

class Cart {
  final List<CartItem> items;

  Cart({this.items = const []});

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => 0.0; // FREE delivery
  double get total => subtotal + deliveryFee;

  Cart copyWith({
    List<CartItem>? items,
  }) {
    return Cart(
      items: items ?? this.items,
    );
  }
}



