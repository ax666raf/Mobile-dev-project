import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/cubits/favorite/favorite_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/favorite/favorite_state.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/product_detail.dart';
import 'package:mahsoul_dz/core/utils/image_storage_helper.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';

class FavoritesPage extends StatefulWidget {
  final String customerId;

  const FavoritesPage({super.key, required this.customerId});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Load full favorites with product data
    context.read<FavoriteCubit>().loadFavorites(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          l10n.favorites ?? 'Favorites',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          if (state.status == FavoriteStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == FavoriteStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? l10n.somethingWentWrong,
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoriteCubit>().loadFavorites(widget.customerId);
                    },
                    child: Text(l10n.retry ?? 'Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noFavorites ?? 'No favorites yet',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.addFavoritesHint ?? 'Tap the heart icon on products to add favorites',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<FavoriteCubit>().loadFavorites(widget.customerId);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final favorite = state.favorites[index];
                return _buildFavoriteCard(context, favorite);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, dynamic favorite) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(productId: favorite.productId),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: ImageStorageHelper.getImageWidget(
                  favorite.productImagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.productName ?? 'Unknown Product',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (favorite.productCategory != null)
                      Text(
                        favorite.productCategory!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      '${favorite.productPrice?.toStringAsFixed(2) ?? '0.00'} ${l10n.currency ?? 'DZD'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Remove Button
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  context.read<FavoriteCubit>().toggleFavorite(
                    widget.customerId,
                    favorite.productId,
                  );
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
