import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/profile_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'customer_profile_state.dart';

class CustomerProfileCubit extends Cubit<CustomerProfileState> {
  final ProfileRepository _profileRepository;
  final String userId;

  CustomerProfileCubit(this._profileRepository, this.userId) : super(CustomerProfileInitial());

  // Load customer profile
  Future<void> loadProfile() async {
    emit(CustomerProfileLoading());

    try {
      final response = await _profileRepository.getProfile(userId);
      // Backend returns: { 'id': '...', 'full_name': '...', 'email': '...', 'profile': {...} }
      // We need to merge user-level data with profile data
      final userData = Map<String, dynamic>.from(response);
      final profileData = userData['profile'] as Map<String, dynamic>? ?? {};
      
      // Merge user-level fields (full_name, email, phone_number, etc.) with profile data
      final mergedProfile = <String, dynamic>{
        ...profileData, // Profile-specific data (city, postal_code, etc.)
        'full_name': userData['full_name'] ?? profileData['full_name'] ?? '',
        'email': userData['email'] ?? profileData['email'] ?? '',
        'phone_number': userData['phone_number'] ?? profileData['phone_number'] ?? '',
        'profile_image_path': userData['profile_image_path'] ?? profileData['profile_image_path'] ?? '',
        'created_at': userData['created_at'] ?? profileData['created_at'],
        'total_orders': profileData['total_orders'] ?? 0, // This might be calculated
      };
      
      emit(CustomerProfileLoaded(mergedProfile));
    } on ApiException catch (e) {
      emit(CustomerProfileError(e.message));
    } catch (e) {
      emit(CustomerProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  // Update profile
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    try {
      await _profileRepository.updateProfile(
        userId: userId,
        fullName: updates['full_name'] as String?,
        phoneNumber: updates['phone_number'] as String?,
        city: updates['city'] as String?,
        postalCode: updates['postal_code'] as String?,
      );
      loadProfile(); // Reload profile
    } on ApiException catch (e) {
      emit(CustomerProfileError(e.message));
    } catch (e) {
      emit(CustomerProfileError('Failed to update profile: ${e.toString()}'));
    }
  }

  // Update profile image
  Future<void> updateProfileImage(String imagePath) async {
    try {
      await _profileRepository.updateProfileImage(
        userId: userId,
        imagePath: imagePath,
      );
      loadProfile(); // Reload profile
    } on ApiException catch (e) {
      emit(CustomerProfileError(e.message));
    } catch (e) {
      emit(CustomerProfileError('Failed to update image: ${e.toString()}'));
    }
  }
}



