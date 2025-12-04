import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/product_card.dart';
import 'package:mahsoul_dz/views/screens/customerSide/product_detail.dart';
import 'package:mahsoul_dz/views/models/customerSide/product.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/market_search_bar.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/category_chips.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/category_header.dart';

class Market extends StatefulWidget {
  const Market({super.key});

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  // UI State
  String _selectedCategory = "";
  final TextEditingController _searchController = TextEditingController();
  List<Product> _displayedProducts = [];
  
  static const List<String> _categoryKeys = ['Vegetables', 'Fruits', 'Grains', 'Others'];
  static const EdgeInsets _screenPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedCategory = 'Vegetables'; // Default to first category
        _loadProducts();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Load products from controller based on selected category
  void _loadProducts() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _displayedProducts = _getMockProductsByCategory(_selectedCategory, l10n);
    });
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
    if (query.isEmpty) {
      _loadProducts();
    } else {
      setState(() {
        _displayedProducts = _displayedProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
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
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: _screenPadding,
                child: _buildSearchBar(l10n),
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
    final localizedCategoryName = categoryMap[_selectedCategory] ?? _selectedCategory;
    
    return CategoryHeader(
      categoryName: localizedCategoryName,
      l10n: l10n,
    );
  }

  Widget _buildProductsGrid(AppLocalizations l10n) {
    if (_displayedProducts.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
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

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = _displayedProducts[index];
          return ProductCard(
            product: product,
            onPressed: () => _navigateToProductDetail(product),
          );
        },
        childCount: _displayedProducts.length,
      ),
    );
  }

  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductPage(),
      ),
    );
  }

  List<Product> _getMockProductsByCategory(String category, AppLocalizations l10n) {
    return List.generate(
      6,
      (index) => Product(
        id: '${category}_$index',
        name: l10n.tomatoes,
        description: l10n.freshTomatoesStartingFrom('10kg'),
        imagePath: 'lib/assets/tomate.png',
        farmName: l10n.adamFarm,
        price: 250.0,
        category: category,
        rating: 4.5,
        reviewCount: 150,
      ),
    );
  }
}
