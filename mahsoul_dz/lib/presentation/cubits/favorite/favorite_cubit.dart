import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/favorite_repository.dart';
import 'package:mahsoul_dz/presentation/cubits/favorite/favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _favoriteRepository;
  String? _currentCustomerId;

  FavoriteCubit(this._favoriteRepository) : super(const FavoriteState());

  /// Load all favorites for a customer
  Future<void> loadFavorites(String customerId) async {
    _currentCustomerId = customerId;
    emit(state.copyWith(status: FavoriteStatus.loading));

    try {
      final favorites = await _favoriteRepository.getCustomerFavorites(customerId);
      final productIds = favorites.map((f) => f.productId).toSet();

      emit(state.copyWith(
        status: FavoriteStatus.loaded,
        favorites: favorites,
        favoriteProductIds: productIds,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoriteStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Load only the favorite product IDs (lighter weight)
  Future<void> loadFavoriteIds(String customerId) async {
    _currentCustomerId = customerId;

    try {
      final productIds = await _favoriteRepository.getCustomerFavoriteIds(customerId);
      emit(state.copyWith(
        favoriteProductIds: productIds.toSet(),
      ));
    } catch (e) {
      // Silent fail - don't disrupt the UI
    }
  }

  /// Toggle favorite status for a product
  Future<void> toggleFavorite(String customerId, String productId) async {
    final isFavorite = state.favoriteProductIds.contains(productId);

    if (isFavorite) {
      await _removeFavorite(customerId, productId);
    } else {
      await _addFavorite(customerId, productId);
    }
  }

  Future<void> _addFavorite(String customerId, String productId) async {
    // Optimistic update
    final newIds = Set<String>.from(state.favoriteProductIds)..add(productId);
    emit(state.copyWith(favoriteProductIds: newIds));

    try {
      final favorite = await _favoriteRepository.addFavorite(
        customerId: customerId,
        productId: productId,
      );

      // Update the full favorites list if it's loaded
      final newFavorites = List.from(state.favorites)..add(favorite);
      emit(state.copyWith(
        favorites: newFavorites.cast(),
      ));
    } catch (e) {
      // Revert optimistic update
      final revertedIds = Set<String>.from(state.favoriteProductIds)..remove(productId);
      emit(state.copyWith(
        favoriteProductIds: revertedIds,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _removeFavorite(String customerId, String productId) async {
    // Optimistic update
    final newIds = Set<String>.from(state.favoriteProductIds)..remove(productId);
    final removedFavorite = state.favorites.where((f) => f.productId == productId).firstOrNull;
    final newFavorites = state.favorites.where((f) => f.productId != productId).toList();

    emit(state.copyWith(
      favoriteProductIds: newIds,
      favorites: newFavorites,
    ));

    try {
      await _favoriteRepository.removeFavoriteByProduct(customerId, productId);
    } catch (e) {
      // Revert optimistic update
      final revertedIds = Set<String>.from(state.favoriteProductIds)..add(productId);
      final revertedFavorites = removedFavorite != null
          ? [...state.favorites, removedFavorite]
          : state.favorites;

      emit(state.copyWith(
        favoriteProductIds: revertedIds,
        favorites: revertedFavorites,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Check if a specific product is favorited
  bool isFavorite(String productId) => state.favoriteProductIds.contains(productId);

  /// Refresh favorites
  Future<void> refresh() async {
    if (_currentCustomerId != null) {
      await loadFavorites(_currentCustomerId!);
    }
  }
}
