import 'package:equatable/equatable.dart';
import 'package:mahsoul_dz/data/models/shared/favorite.dart';

enum FavoriteStatus { initial, loading, loaded, error }

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final List<FavoriteModel> favorites;
  final Set<String> favoriteProductIds;
  final String? errorMessage;

  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.favorites = const [],
    this.favoriteProductIds = const {},
    this.errorMessage,
  });

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<FavoriteModel>? favorites,
    Set<String>? favoriteProductIds,
    String? errorMessage,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
      errorMessage: errorMessage,
    );
  }

  bool isFavorite(String productId) => favoriteProductIds.contains(productId);

  @override
  List<Object?> get props => [status, favorites, favoriteProductIds, errorMessage];
}
