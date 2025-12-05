import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';

class CartRepository {
  final ApiClient _apiClient;

  CartRepository(this._apiClient);

  Future<List<dynamic>> getCart(String customerId) async {
    if (customerId.isEmpty) {
      throw ApiException('Customer ID is required', statusCode: 400);
    }
    try {
      final response = await _apiClient.get(
        ApiEndpoints.cart,
        queryParameters: {'customer_id': customerId},
      );

      if (response.statusCode == 200) {
        // Backend returns 'items' not 'cart_items'
        final cartItems = response.data['items'];
        if (cartItems == null) {
          return [];
        }
        return cartItems as List<dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get cart',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get cart: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> addToCart({
    required String customerId,
    required String productId,
    required String selectedWeight,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.cart}/add',
        data: {
          'customer_id': customerId,
          'product_id': productId,
          'selected_weight': selectedWeight,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to add to cart',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to add to cart: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.cartItem(itemId),
        data: {'quantity': quantity},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to update cart item',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to update cart item: ${e.toString()}');
    }
  }

  Future<void> removeFromCart(String itemId) async {
    try {
      await _apiClient.delete(ApiEndpoints.cartItem(itemId));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to remove from cart: ${e.toString()}');
    }
  }

  Future<void> clearCart(String customerId) async {
    try {
      await _apiClient.post(
        ApiEndpoints.cartClear,
        data: {'customer_id': customerId},
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to clear cart: ${e.toString()}');
    }
  }
}

