import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/farmer_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'farmer_product_state.dart';

class FarmerProductCubit extends Cubit<FarmerProductState> {
  final FarmerRepository _farmerRepository;
  final String farmerId;

  FarmerProductCubit(this._farmerRepository, this.farmerId) : super(FarmerProductInitial());

  // Load all products for farmer
  Future<void> loadProducts() async {
    emit(FarmerProductLoading());

    try {
      final products = await _farmerRepository.getFarmerProducts(farmerId);
      emit(FarmerProductLoaded(products.cast<Map<String, dynamic>>()));
    } on ApiException catch (e) {
      emit(FarmerProductError(e.message));
    } catch (e) {
      emit(FarmerProductError('Failed to load products: ${e.toString()}'));
    }
  }

  // Load products by category
  Future<void> loadProductsByCategory(String category) async {
    emit(FarmerProductLoading());

    try {
      final products = await _farmerRepository.getFarmerProducts(farmerId);
      final filteredProducts = products.where((product) => 
        (product as Map<String, dynamic>)['category'] == category
      ).toList();
      emit(FarmerProductLoaded(filteredProducts.cast<Map<String, dynamic>>()));
    } on ApiException catch (e) {
      emit(FarmerProductError(e.message));
    } catch (e) {
      emit(FarmerProductError('Failed to load products: ${e.toString()}'));
    }
  }

  // Add product
  Future<void> addProduct({
    required String name,
    required String description,
    required String category,
    required double price,
    String? origin,
    String? harvestSeason,
    bool isOrganic = false,
    String? storageInstructions,
    String? imagePath,
    String? status,
    List<String>? weights,
  }) async {
    try {
      // Backend expects list of weight strings, not maps
      final weightsList = weights ?? [];
      
      final response = await _farmerRepository.addProduct(
        farmerId: farmerId,
        name: name,
        description: description,
        category: category,
        price: price,
        origin: origin,
        harvestSeason: harvestSeason,
        isOrganic: isOrganic,
        storageInstructions: storageInstructions,
        imagePath: imagePath,
        status: status,
        weights: weightsList.map((w) => {'weight_value': w, 'is_available': true}).toList(),
      );
      
      final product = response['product'] as Map<String, dynamic>;
      emit(FarmerProductAdded(product));
      loadProducts(); // Reload products list
    } on ApiException catch (e) {
      emit(FarmerProductError(e.message));
    } catch (e) {
      emit(FarmerProductError('Failed to add product: ${e.toString()}'));
    }
  }

  // Update product
  Future<void> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      // Extract weights if provided
      List<String>? weights;
      if (updates.containsKey('weights') && updates['weights'] != null) {
        weights = (updates['weights'] as List<dynamic>).cast<String>();
      }
      
      final response = await _farmerRepository.updateProduct(
        productId: productId,
        name: updates['name'] as String?,
        description: updates['description'] as String?,
        category: updates['category'] as String?,
        price: (updates['price'] as num?)?.toDouble(),
        origin: updates['origin'] as String?,
        harvestSeason: updates['harvest_season'] as String?,
        isOrganic: updates['is_organic'] as bool?,
        storageInstructions: updates['storage_instructions'] as String?,
        imagePath: updates['image_path'] as String?,
        status: updates['status'] as String?,
        weights: weights,
      );
      
      final product = response['product'] as Map<String, dynamic>;
      emit(FarmerProductUpdated(product));
      loadProducts(); // Reload products list
    } on ApiException catch (e) {
      emit(FarmerProductError(e.message));
    } catch (e) {
      emit(FarmerProductError('Failed to update product: ${e.toString()}'));
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _farmerRepository.deleteProduct(productId);
      emit(FarmerProductDeleted(productId));
      loadProducts(); // Reload products list
    } on ApiException catch (e) {
      emit(FarmerProductError(e.message));
    } catch (e) {
      emit(FarmerProductError('Failed to delete product: ${e.toString()}'));
    }
  }

  // Update product status
  Future<void> updateProductStatus(String productId, String status) async {
    try {
      await updateProduct(productId, {'status': status});
    } catch (e) {
      emit(FarmerProductError('Failed to update status: ${e.toString()}'));
    }
  }
}



