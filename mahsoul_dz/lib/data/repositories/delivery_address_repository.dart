import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';

class DeliveryAddressRepository {
  final ApiClient _apiClient;

  DeliveryAddressRepository(this._apiClient);

  Future<List<dynamic>> getAddresses(String customerId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.addresses,
        queryParameters: {'customer_id': customerId},
      );

      if (response.statusCode == 200) {
        return response.data['addresses'] as List<dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get addresses',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get addresses: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getAddressById(String addressId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.addressById(addressId),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get address',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get address: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> addAddress({
    required String customerId,
    required String address,
    required String city,
    String? postalCode,
  }) async {
    try {
      final requestData = {
        'customer_id': customerId,
        'address': address,
        'city': city,
        if (postalCode != null && postalCode.isNotEmpty) 'postal_code': postalCode,
      };
      
      print('📤 DeliveryAddressRepository.addAddress - Sending: $requestData');
      
      final response = await _apiClient.post(
        ApiEndpoints.addresses,
        data: requestData,
      );

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to add address',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to add address: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateAddress({
    required String addressId,
    String? address,
    String? city,
    String? postalCode,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (address != null) data['address'] = address;
      if (city != null) data['city'] = city;
      if (postalCode != null) data['postal_code'] = postalCode;

      final response = await _apiClient.put(
        ApiEndpoints.addressById(addressId),
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to update address',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to update address: ${e.toString()}');
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      await _apiClient.delete(ApiEndpoints.addressById(addressId));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to delete address: ${e.toString()}');
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    try {
      print('📤 DeliveryAddressRepository.setDefaultAddress - addressId: $addressId');
      final response = await _apiClient.post(ApiEndpoints.setDefaultAddress(addressId));
      
      if (response.statusCode == 200) {
        print('✅ Default address set successfully');
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to set default address',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to set default address: ${e.toString()}');
    }
  }
}

