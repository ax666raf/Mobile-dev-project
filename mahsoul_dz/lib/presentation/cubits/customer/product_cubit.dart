import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/product_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;

  ProductCubit(this._productRepository) : super(ProductInitial());

  // Load all products
  Future<void> loadProducts() async {
    emit(ProductLoading());

    try {
      final products = await _productRepository.getAllProducts(status: 'available');
      emit(ProductLoaded(products));
    } on ApiException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('Failed to load products: ${e.toString()}'));
    }
  }

  // Load products by category
  Future<void> loadProductsByCategory(String category) async {
    emit(ProductLoading());

    try {
      final products = await _productRepository.getProductsByCategory(category);
      emit(ProductLoaded(products));
    } on ApiException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('Failed to load products: ${e.toString()}'));
    }
  }

  // Search products
  Future<void> searchProducts(String query) async {
    emit(ProductLoading());

    try {
      final products = await _productRepository.searchProducts(query);
      emit(ProductLoaded(products));
    } on ApiException catch (e) {
      emit(ProductError(e.message));
    } catch (e) {
      emit(ProductError('Failed to search products: ${e.toString()}'));
    }
  }

  // Get product by ID
  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      final product = await _productRepository.getProductById(productId);
      return product;
    } on ApiException {
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get product reviews
  Future<List<Map<String, dynamic>>> getProductReviews(String productId) async {
    try {
      final reviews = await _productRepository.getProductReviews(productId);
      return reviews.cast<Map<String, dynamic>>();
    } on ApiException {
      return [];
    } catch (e) {
      return [];
    }
  }
}



