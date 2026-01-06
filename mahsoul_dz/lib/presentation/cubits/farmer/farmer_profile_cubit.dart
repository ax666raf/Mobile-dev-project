import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/profile_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'farmer_profile_state.dart';

class FarmerProfileCubit extends Cubit<FarmerProfileState> {
  final ProfileRepository _profileRepository;
  final String userId;

  FarmerProfileCubit(this._profileRepository, this.userId) : super(FarmerProfileInitial());

  // Load farmer profile
  Future<void> loadProfile() async {
    emit(FarmerProfileLoading());

    try {
      final response = await _profileRepository.getProfile(userId);
      // Backend returns: {user_fields..., 'profile': {farmer_profile_fields...}}
      // We need to merge them so the profile page can access both user and farmer data
      final userData = Map<String, dynamic>.from(response); // Create a new map to ensure Equatable detects changes
      final farmerProfile = Map<String, dynamic>.from(response['profile'] as Map<String, dynamic>? ?? {});
      // Merge user data with farmer profile, keeping 'profile' key for farmer-specific data
      final mergedProfile = <String, dynamic>{
        ...userData,
        'farmer': farmerProfile, // Add farmer data under 'farmer' key for consistency
      };
      emit(FarmerProfileLoaded(mergedProfile));
    } on ApiException catch (e) {
      emit(FarmerProfileError(e.message));
    } catch (e) {
      emit(FarmerProfileError('Failed to load profile: ${e.toString()}'));
    }
  }

  // Update profile
  Future<void> updateProfile({
    String? fullName,
    String? farmName,
    String? farmLocation,
    String? phoneNumber,
    String? emailAddress,
    String? description,
    int? establishedYear,
  }) async {
    emit(FarmerProfileLoading()); // Show loading state
    try {
      await _profileRepository.updateProfile(
        userId: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        city: null,
        postalCode: null,
        // Farmer-specific fields
        farmName: farmName,
        farmLocation: farmLocation,
        establishedYear: establishedYear,
        description: description,
      );
      // Reload profile to get updated data
      await loadProfile();
    } on ApiException catch (e) {
      emit(FarmerProfileError(e.message));
    } catch (e) {
      emit(FarmerProfileError('Failed to update profile: ${e.toString()}'));
    }
  }

  // Update profile image
  Future<void> updateProfileImage(String imagePath) async {
    try {
      await _profileRepository.updateProfileImage(
        userId: userId,
        imagePath: imagePath,
      );
      // Small delay to ensure backend has committed the change
      await Future.delayed(const Duration(milliseconds: 300));
      loadProfile(); // Reload profile
    } on ApiException catch (e) {
      emit(FarmerProfileError(e.message));
    } catch (e) {
      emit(FarmerProfileError('Failed to update image: ${e.toString()}'));
    }
  }
}



