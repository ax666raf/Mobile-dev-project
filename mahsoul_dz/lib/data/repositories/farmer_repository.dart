import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';

class FarmerRepository {
  final ApiClient _apiClient;

  FarmerRepository(this._apiClient);

  // Products
  Future<List<dynamic>> getFarmerProducts(String farmerId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.farmerProducts,
        queryParameters: {'farmer_id': farmerId},
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

  Future<Map<String, dynamic>> getFarmerProductById(String productId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.farmerProductById(productId),
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

  Future<Map<String, dynamic>> addProduct({
    required String farmerId,
    required String name,
    required String description,
    required String category,
    required double price,
    String? origin,
    String? harvestSeason,
    bool? isOrganic,
    String? storageInstructions,
    String? imagePath,
    String? status,
    required List<Map<String, dynamic>> weights,
  }) async {
    try {
      // Backend expects list of weight strings, extract weight_value from maps
      final weightStrings = weights.map((w) => w['weight_value'] as String).toList();
      
      final response = await _apiClient.post(
        ApiEndpoints.farmerProducts,
        data: {
          'farmer_id': farmerId,
          'name': name,
          'description': description,
          'category': category,
          'price': price,
          if (origin != null) 'origin': origin,
          if (harvestSeason != null) 'harvest_season': harvestSeason,
          if (isOrganic != null) 'is_organic': isOrganic,
          if (storageInstructions != null) 'storage_instructions': storageInstructions,
          if (imagePath != null) 'image_path': imagePath,
          if (status != null) 'status': status,
          'weights': weightStrings,
        },
      );

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to add product',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to add product: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateProduct({
    required String productId,
    String? name,
    String? description,
    String? category,
    double? price,
    String? origin,
    String? harvestSeason,
    bool? isOrganic,
    String? storageInstructions,
    String? imagePath,
    String? status,
    List<String>? weights,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (description != null) data['description'] = description;
      if (category != null) data['category'] = category;
      if (price != null) data['price'] = price;
      if (origin != null) data['origin'] = origin;
      if (harvestSeason != null) data['harvest_season'] = harvestSeason;
      if (isOrganic != null) data['is_organic'] = isOrganic;
      if (storageInstructions != null) data['storage_instructions'] = storageInstructions;
      if (imagePath != null) data['image_path'] = imagePath;
      if (status != null) data['status'] = status;
      if (weights != null && weights.isNotEmpty) {
        data['weights'] = weights;
      }

      final response = await _apiClient.put(
        ApiEndpoints.farmerProductById(productId),
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to update product',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to update product: ${e.toString()}');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _apiClient.delete(ApiEndpoints.farmerProductById(productId));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to delete product: ${e.toString()}');
    }
  }

  // Orders
  Future<List<dynamic>> getFarmerOrders(String farmerId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.farmerOrders,
        queryParameters: {'farmer_id': farmerId},
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

  Future<Map<String, dynamic>> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.farmerOrderStatus(orderId),
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

  // Dashboard
  Future<Map<String, dynamic>> getDashboard(String farmerId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.farmerDashboard,
        queryParameters: {'farmer_id': farmerId},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get dashboard',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get dashboard: ${e.toString()}');
    }
  }
}

