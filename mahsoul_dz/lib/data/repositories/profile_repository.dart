import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';

class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository(this._apiClient);

  Future<Map<String, dynamic>> getProfile(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.profile,
        queryParameters: {'user_id': userId},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to get profile',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to get profile: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
    String? city,
    String? postalCode,
    // Farmer-specific fields
    String? farmName,
    String? farmLocation,
    int? establishedYear,
    String? description,
  }) async {
    try {
      final data = <String, dynamic>{
        'user_id': userId, // Backend expects user_id in request body, not query parameter
      };
      if (fullName != null && fullName.isNotEmpty) data['full_name'] = fullName;
      if (phoneNumber != null && phoneNumber.isNotEmpty) data['phone_number'] = phoneNumber;
      if (city != null && city.isNotEmpty) data['city'] = city;
      if (postalCode != null && postalCode.isNotEmpty) data['postal_code'] = postalCode;
      // Farmer-specific fields
      if (farmName != null && farmName.isNotEmpty) data['farm_name'] = farmName;
      if (farmLocation != null && farmLocation.isNotEmpty) data['farm_location'] = farmLocation;
      if (establishedYear != null) data['established_year'] = establishedYear.toString(); // Backend expects String
      if (description != null && description.isNotEmpty) data['description'] = description;

      print('📤 ProfileRepository.updateProfile - Sending data: $data');
      print('📤 ProfileRepository.updateProfile - user_id: $userId');

      final response = await _apiClient.put(
        ApiEndpoints.profile,
        data: data,
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to update profile',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to update profile: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> updateProfileImage({
    required String userId,
    required String imagePath,
  }) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.profileImage,
        data: {
          'user_id': userId,
          'image_path': imagePath,
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          response.data['error'] ?? 'Failed to update profile image',
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to update profile image: ${e.toString()}');
    }
  }
}

