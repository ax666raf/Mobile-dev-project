import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'package:mahsoul_dz/data/models/shared/favorite.dart';

class FavoriteRepository {
  final ApiClient _apiClient;

  FavoriteRepository(this._apiClient);

  /// Get all favorites for a customer (includes product data)
  Future<List<FavoriteModel>> getCustomerFavorites(String customerId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.customerFavorites(customerId),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final favorites = data['favorites'] as List<dynamic>;
        return favorites
            .map((f) => FavoriteModel.fromJson(f as Map<String, dynamic>))
            .toList();
      }
      throw ApiException('Failed to fetch favorites');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error fetching favorites: ${e.toString()}');
    }
  }

  /// Get just the product IDs of customer's favorites (for quick lookup)
  Future<List<String>> getCustomerFavoriteIds(String customerId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.customerFavoriteIds(customerId),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final productIds = data['product_ids'] as List<dynamic>;
        return productIds.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Add a product to favorites
  Future<FavoriteModel> addFavorite({
    required String customerId,
    required String productId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.favorites,
        data: {
          'customer_id': customerId,
          'product_id': productId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return FavoriteModel.fromJson(data['favorite'] as Map<String, dynamic>);
      }
      throw ApiException(
        response.data['error']?.toString() ?? 'Failed to add favorite',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error adding favorite: ${e.toString()}');
    }
  }

  /// Remove a product from favorites by favorite ID
  Future<void> removeFavorite(String favoriteId) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.favoriteById(favoriteId),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          response.data['error']?.toString() ?? 'Failed to remove favorite',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error removing favorite: ${e.toString()}');
    }
  }

  /// Remove a product from favorites by customer and product ID
  Future<void> removeFavoriteByProduct(String customerId, String productId) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.removeFavoriteByProduct(customerId, productId),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          response.data['error']?.toString() ?? 'Failed to remove favorite',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error removing favorite: ${e.toString()}');
    }
  }

  /// Check if a product is in customer's favorites
  Future<bool> isFavorite(String customerId, String productId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.checkFavorite(customerId, productId),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['is_favorite'] as bool;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
