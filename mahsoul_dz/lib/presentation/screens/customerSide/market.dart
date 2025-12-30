import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/product_card.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/customer_side_screens.dart';
import 'package:mahsoul_dz/data/models/customerSide/product.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/market_search_bar.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/category_chips.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/category_header.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/product_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/product_state.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/cart_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/favorite/favorite_cubit.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/favorites_page.dart';

class Market extends StatefulWidget {
  const Market({super.key});

  @override
  State<Market> createState() => _MarketState();
}

/// Market with bottom navigation bar
class MarketWithNav extends StatelessWidget {
  const MarketWithNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Market(),
      bottomNavigationBar: _MarketBottomNav(),
    );
  }
}

/// Bottom navigation bar for Market page
class _MarketBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: BottomNavigationBar(
            currentIndex: 0, // No item selected (Market is not in navbar)
            onTap: (index) {
              if (index == 0) {
                // Navigate to Home (MainNavigation with index 0)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainNavigation(),
                  ),
                  (route) => false,
                );
              } else if (index == 1) {
                // Navigate to Cart (MainNavigation with index 1)
                final authState = context.read<AuthCubit>().state;
                if (authState is AuthAuthenticated &&
                    authState.userType == 'customer') {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => CartCubit(
                          DependencyInjection.cartRepository,
                          authState.userId,
                        )..loadCart(),
                        child: MahsoulOrderScreen(customerId: authState.userId),
                      ),
                    ),
                    (route) => false,
                  );
                } else {
                  // Navigate to MainNavigation which will show login message
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                    (route) => false,
                  );
                }
              } else if (index == 2) {
                // Navigate to Profile (MainNavigation with index 2)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainNavigation(),
                  ),
                  (route) => false,
                );
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: primaryColor,
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: l10n.home,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_cart),
                label: l10n.cart ?? 'Cart',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: l10n.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketState extends State<Market> {
  // UI State
  String _selectedCategory = "";
  final TextEditingController _searchController = TextEditingController();
  String? _customerId;

  static const List<String> _categoryKeys = [
    'Vegetables',
    'Fruits',
    'Grains',
    'Others',
  ];
  static const EdgeInsets _screenPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 16.0,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedCategory = 'Vegetables'; // Default to first category
        _loadProducts();
        _loadFavorites();
      });
    });
  }

  void _loadFavorites() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated && authState.userType == 'customer') {
      _customerId = authState.userId;
      context.read<FavoriteCubit>().loadFavoriteIds(_customerId!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Load products from ProductCubit based on selected category
  void _loadProducts() {
    final productCubit = context.read<ProductCubit>();
    if (_selectedCategory.isEmpty) {
      productCubit.loadProducts();
    } else {
      productCubit.loadProductsByCategory(_selectedCategory);
    }
  }

  /// Handle category selection
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _searchController.clear();
      _loadProducts();
    });
  }

  /// Handle search query
  void _onSearchChanged(String query) {
    final productCubit = context.read<ProductCubit>();
    if (query.isEmpty) {
      _loadProducts();
    } else {
      productCubit.searchProducts(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Bar with Favorites Icon
            SliverToBoxAdapter(
              child: Padding(
                padding: _screenPadding,
                child: Row(
                  children: [
                    Expanded(child: _buildSearchBar(l10n)),
                    const SizedBox(width: 12),
                    _buildFavoritesButton(context),
                  ],
                ),
              ),
            ),

            // Category Chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildCategoryChips(l10n),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Category Title & Description
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildCategoryHeader(l10n),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Products Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: _buildProductsGrid(l10n),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return MarketSearchBar(
      controller: _searchController,
      onChanged: _onSearchChanged,
      onClear: () {
        _searchController.clear();
        _onSearchChanged('');
      },
      showClearButton: _searchController.text.isNotEmpty,
    );
  }

  Widget _buildFavoritesButton(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (_customerId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesPage(customerId: _customerId!),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.pleaseLogin ?? 'Please login to view favorites'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.favorite,
            color: Colors.red.shade400,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips(AppLocalizations l10n) {
    final categoryMap = {
      'Vegetables': l10n.vegetables,
      'Fruits': l10n.fruits,
      'Grains': l10n.grains,
      'Others': l10n.others,
    };

    return CategoryChips(
      categories: _categoryKeys,
      selectedCategory: _selectedCategory,
      onCategorySelected: _onCategorySelected,
      categoryMap: categoryMap,
    );
  }

  Widget _buildCategoryHeader(AppLocalizations l10n) {
    final categoryMap = {
      'Vegetables': l10n.vegetables,
      'Fruits': l10n.fruits,
      'Grains': l10n.grains,
      'Others': l10n.others,
    };
    final localizedCategoryName =
        categoryMap[_selectedCategory] ?? _selectedCategory;

    return CategoryHeader(categoryName: localizedCategoryName, l10n: l10n);
  }

  Widget _buildProductsGrid(AppLocalizations l10n) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state is ProductError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is ProductLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noProductsFound,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Convert backend product data to Product model
          final productList = products.map((p) {
            final productData = p;
            return Product(
              id: productData['id'] as String? ?? '',
              name: productData['name'] as String? ?? '',
              description: productData['description'] as String? ?? '',
              imagePath:
                  productData['image_path'] as String? ??
                  'lib/assets/tomate.png',
              farmName: productData['farmer']?['farm_name'] as String? ?? '',
              price: (productData['price'] as num?)?.toDouble() ?? 0.0,
              category: productData['category'] as String? ?? '',
              rating: (productData['rating'] as num?)?.toDouble() ?? 0.0,
              reviewCount: productData['review_count'] as int? ?? 0,
            );
          }).toList();

          return SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = productList[index];
              return ProductCard(
                product: product,
                onPressed: () => _navigateToProductDetail(product.id),
                customerId: _customerId,
              );
            }, childCount: productList.length),
          );
        }

        return SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  void _navigateToProductDetail(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(productId: productId),
      ),
    );
  }
}
