import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/cart_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  final String customerId;

  CartCubit(this._cartRepository, this.customerId) : super(CartInitial());

  // Calculate cart total
  double _calculateTotal(List<Map<String, dynamic>> items) {
    double total = 0.0;
    for (var item in items) {
      final quantity = item['quantity'] as int? ?? 1;
      final product = item['product'] as Map<String, dynamic>?;
      final price = (product?['price'] as num?)?.toDouble() ?? 0.0;
      total += price * quantity;
    }
    return total;
  }

  // Load cart items with product details
  Future<void> loadCart() async {
    emit(CartLoading());

    try {
      final cartItems = await _cartRepository.getCart(customerId);
      final itemsWithDetails = cartItems.cast<Map<String, dynamic>>();
      
      // Calculate total from item subtotals (backend already calculates weight-based pricing)
      // Each item has 'subtotal' (unit_price * quantity) where unit_price is weight-adjusted
      double total = 0.0;
      for (var item in itemsWithDetails) {
        final subtotal = (item['subtotal'] as num?)?.toDouble();
        if (subtotal != null) {
          // Use subtotal from backend (already includes weight-based pricing)
          total += subtotal;
        } else {
          // Fallback: use unit_price * quantity (unit_price is weight-adjusted from backend)
          final unitPrice = (item['unit_price'] as num?)?.toDouble() ?? 0.0;
          final quantity = item['quantity'] as int? ?? 1;
          total += unitPrice * quantity;
        }
      }

      emit(CartLoaded(items: itemsWithDetails, total: total));
    } on ApiException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  // Add to cart
  Future<void> addToCart(String productId, String selectedWeight, int quantity) async {
    try {
      await _cartRepository.addToCart(
        customerId: customerId,
        productId: productId,
        selectedWeight: selectedWeight,
        quantity: quantity,
      );
      loadCart(); // Reload cart
    } on ApiException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to add to cart: ${e.toString()}'));
    }
  }

  // Update cart item quantity
  Future<void> updateCartItem(String itemId, int quantity) async {
    try {
      await _cartRepository.updateCartItem(
        itemId: itemId,
        quantity: quantity,
      );
      loadCart(); // Reload cart
    } on ApiException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to update cart: ${e.toString()}'));
    }
  }

  // Remove from cart
  Future<void> removeFromCart(String itemId) async {
    try {
      await _cartRepository.removeFromCart(itemId);
      loadCart(); // Reload cart
    } on ApiException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to remove from cart: ${e.toString()}'));
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      await _cartRepository.clearCart(customerId);
      loadCart(); // Reload cart
    } on ApiException catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      emit(CartError('Failed to clear cart: ${e.toString()}'));
    }
  }
}



