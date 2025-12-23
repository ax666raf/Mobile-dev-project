import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';

class OrderRepository {
  final ApiClient _apiClient;

  OrderRepository(this._apiClient);

  Future<List<dynamic>> getCustomerOrders(String customerId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.orders,
        queryParameters: {'customer_id': customerId},
      );

      if (response.statusCode == 200) {
        return response.data['orders'] as List<dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get orders',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get orders: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.orderById(orderId),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get order',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get order: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> createOrder({
    required String customerId,
    required String deliveryAddress,
    required String deliveryMethod,
    String? paymentMethod,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.orders,
        data: {
          'customer_id': customerId,
          'delivery_address': deliveryAddress,
          'delivery_method': deliveryMethod,
          if (paymentMethod != null) 'payment_method': paymentMethod,
        },
      );

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to create order',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to create order: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updateOrderStatus(orderId),
        data: {'status': status},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to update order status',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to update order status: ${e.toString()}');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await _apiClient.post(ApiEndpoints.cancelOrder(orderId));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to cancel order: ${e.toString()}');
    }
  }
}

