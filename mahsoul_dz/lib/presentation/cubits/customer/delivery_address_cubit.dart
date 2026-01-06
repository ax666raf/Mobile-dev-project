import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/delivery_address_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'delivery_address_state.dart';

class DeliveryAddressCubit extends Cubit<DeliveryAddressState> {
  final DeliveryAddressRepository _addressRepository;
  final String customerId;

  DeliveryAddressCubit(this._addressRepository, this.customerId) : super(DeliveryAddressInitial());

  // Load all addresses
  Future<void> loadAddresses() async {
    emit(DeliveryAddressLoading());

    try {
      final addresses = await _addressRepository.getAddresses(customerId);
      emit(DeliveryAddressLoaded(addresses.cast<Map<String, dynamic>>()));
    } on ApiException catch (e) {
      emit(DeliveryAddressError(e.message));
    } catch (e) {
      emit(DeliveryAddressError('Failed to load addresses: ${e.toString()}'));
    }
  }

  // Add address
  Future<void> addAddress({
    required String address,
    required String city,
    String? postalCode,
    bool? isDefault, // null means auto-detect (first address = default)
  }) async {
    try {
      // Check if this is the first address (auto-set as default if no addresses exist)
      final currentState = state;
      bool shouldBeDefault = false;
      
      if (isDefault != null) {
        shouldBeDefault = isDefault;
      } else {
        // Auto-detect: if no addresses exist, this should be default
        if (currentState is DeliveryAddressLoaded) {
          shouldBeDefault = currentState.addresses.isEmpty;
        } else {
          // If state is not loaded yet, load addresses first to check
          try {
            final addresses = await _addressRepository.getAddresses(customerId);
            shouldBeDefault = addresses.isEmpty;
          } catch (e) {
            // If we can't check, assume it's the first one
            shouldBeDefault = true;
          }
        }
      }
      
      await _addressRepository.addAddress(
        customerId: customerId,
        address: address,
        city: city,
        postalCode: postalCode,
        isDefault: shouldBeDefault,
      );
      
      loadAddresses(); // Reload to get updated list
    } on ApiException catch (e) {
      emit(DeliveryAddressError(e.message));
    } catch (e) {
      emit(DeliveryAddressError('Failed to add address: ${e.toString()}'));
    }
  }

  // Update address
  Future<void> updateAddress(
    String addressId, {
    String? address,
    String? city,
    String? postalCode,
  }) async {
    try {
      await _addressRepository.updateAddress(
        addressId: addressId,
        address: address,
        city: city,
        postalCode: postalCode,
      );
      loadAddresses(); // Reload addresses
    } on ApiException catch (e) {
      emit(DeliveryAddressError(e.message));
    } catch (e) {
      emit(DeliveryAddressError('Failed to update address: ${e.toString()}'));
    }
  }

  // Delete address
  Future<void> deleteAddress(String addressId) async {
    try {
      await _addressRepository.deleteAddress(addressId);
      loadAddresses(); // Reload addresses
    } on ApiException catch (e) {
      emit(DeliveryAddressError(e.message));
    } catch (e) {
      emit(DeliveryAddressError('Failed to delete address: ${e.toString()}'));
    }
  }

  // Set default address
  Future<void> setDefaultAddress(String addressId) async {
    try {
      await _addressRepository.setDefaultAddress(addressId);
      // Reload addresses to show updated default status
      await loadAddresses();
    } on ApiException catch (e) {
      emit(DeliveryAddressError(e.message));
    } catch (e) {
      emit(DeliveryAddressError('Failed to set default address: ${e.toString()}'));
    }
  }
}



