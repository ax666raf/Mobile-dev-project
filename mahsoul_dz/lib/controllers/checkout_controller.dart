
import 'package:mahsoul_dz/models/cart_model.dart';
import 'package:mahsoul_dz/models/order.dart';
import 'package:mahsoul_dz/models/product_model.dart';
import 'package:mahsoul_dz/models/customer.dart';

class CheckoutController {
  Cart _cart = Cart(items: [
    CartItem(
      product: ProductModel(
        name: 'Organic Tomatoes',
        description: 'Fresh organic tomatoes',
        rating: 4.5,
        reviews: 128,
        price: 3850, 
        currency: '\$',
        deliveryFee: 'FREE',
        weights: [
          WeightOption(value: '1kg', available: true),
          WeightOption(value: '500g', available: true),
        ],
        seller: SellerInfo(
          name: 'Organic Farms',
          type: 'Verified Seller',
          rating: 4.8,
          reviews: 256,
        ),
        features: [
          FeatureItem(icon: '🌱', label: 'Organic'),
          FeatureItem(icon: '🚚', label: 'Fast Delivery'),
        ],
        category: 'Vegetables',
        origin: 'Local Farm',
        harvestSeason: 'All Year',
        isOrganic: true,
        storageInstructions: 'Keep in cool dry place',
      ),
      selectedWeight: '1kg',
      quantity: 1,
    ),
    CartItem(
      product: ProductModel(
        name: 'Organic Cornets',
        description: 'Sweet organic cornets',
        rating: 4.3,
        reviews: 89,
        price: 2700, // in cents
        currency: '\$',
        deliveryFee: 'FREE',
        weights: [
          WeightOption(value: '1kg', available: true),
          WeightOption(value: '500g', available: true),
        ],
        seller: SellerInfo(
          name: 'Fresh Produce Co.',
          type: 'Verified Seller',
          rating: 4.6,
          reviews: 189,
        ),
        features: [
          FeatureItem(icon: '🌱', label: 'Organic'),
          FeatureItem(icon: '🍎', label: 'Fresh'),
        ],
        category: 'Fruits',
        origin: 'Local Farm',
        harvestSeason: 'Summer',
        isOrganic: true,
        storageInstructions: 'Refrigerate after opening',
      ),
      selectedWeight: '1kg',
      quantity: 1,
    ),
  ]);

  Cart get cart => _cart;

  void increaseQuantity(int index) {
    if (index >= 0 && index < _cart.items.length) {
      final items = List<CartItem>.from(_cart.items);
      final item = items[index];
      items[index] = item.copyWith(quantity: item.quantity + 1);
      _cart = _cart.copyWith(items: items);
    }
  }

  void decreaseQuantity(int index) {
    if (index >= 0 && index < _cart.items.length) {
      final items = List<CartItem>.from(_cart.items);
      final item = items[index];
      if (item.quantity > 1) {
        items[index] = item.copyWith(quantity: item.quantity - 1);
        _cart = _cart.copyWith(items: items);
      }
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _cart.items.length) {
      final items = List<CartItem>.from(_cart.items);
      items.removeAt(index);
      _cart = _cart.copyWith(items: items);
    }
  }

  // Create order from cart
  Order createOrder(Customer customer, String farmer) {
    final totalWeight = _cart.items.fold(0.0, (sum, item) {
      final weightValue = double.tryParse(
              item.selectedWeight.replaceAll(RegExp(r'[^0-9.]'), '')) ??
          1.0;
      return sum + (weightValue * item.quantity);
    });

    return Order(
      customer: customer,
      farmer: farmer,
      weight: totalWeight,
      totalPrice: _cart.total,
      status: OrderStatus.pending,
    );
  }

  void continueShopping() {
    // 
  }

  void proceedToCheckout() {
    // 
  }
}