import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<List<dynamic>> getAllProducts({
    String? category,
    String? searchQuery,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (searchQuery != null) queryParams['q'] = searchQuery;
      if (status != null) queryParams['status'] = status;

      final response = await _apiClient.get(
        ApiEndpoints.products,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data['products'] as List<dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get products',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get products: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getProductById(
    String productId, {
    bool includeReviews = false,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productById(productId),
        queryParameters: {'include_reviews': includeReviews.toString()},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get product',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get product: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getProductsByCategory(String category) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productsByCategory(category),
      );

      if (response.statusCode == 200) {
        return response.data['products'] as List<dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get products',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get products: ${e.toString()}');
    }
  }

  Future<List<dynamic>> searchProducts(String query) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productSearch,
        queryParameters: {'q': query},
      );

      if (response.statusCode == 200) {
        return response.data['products'] as List<dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to search products',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to search products: ${e.toString()}');
    }
  }

  Future<List<dynamic>> getProductReviews(String productId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productReviews(productId),
      );

      if (response.statusCode == 200) {
        return response.data['reviews'] as List<dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get reviews',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get reviews: ${e.toString()}');
    }
  }
}

