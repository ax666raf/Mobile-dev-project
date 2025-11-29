import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/product_card.dart';
import 'package:mahsoul_dz/views/screens/customerSide/product_detail.dart';
import 'package:mahsoul_dz/views/models/customerSide/product.dart';
import 'package:mahsoul_dz/logic/market_controller.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/market_search_bar.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/category_chips.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/category_header.dart';

/// Market Screen - View Layer (MVC Pattern)
/// Displays products organized by categories with search functionality
class Market extends StatefulWidget {
  const Market({super.key});

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  // Controller instance
  final MarketController _controller = MarketController();
  
  // UI State
  String _selectedCategory = "Vegetables";
  final TextEditingController _searchController = TextEditingController();
  List<Product> _displayedProducts = [];
  
  // Constants for UI
  static const List<String> _categories = ['Vegetables', 'Fruits', 'Grains', 'Others'];
  static const EdgeInsets _screenPadding = EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0);
  static const double _categorySpacing = 8.0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Load products from controller based on selected category
  void _loadProducts() {
    setState(() {
      _displayedProducts = _getMockProductsByCategory(_selectedCategory);
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
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: _screenPadding,
                child: _buildSearchBar(),
              ),
            ),

            // Category Chips
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildCategoryChips(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Category Title & Description
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildCategoryHeader(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Products Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: _buildProductsGrid(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  /// Search Bar Widget
  Widget _buildSearchBar() {
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

  /// Category Chips Row
  Widget _buildCategoryChips() {
    return CategoryChips(
      categories: _categories,
      selectedCategory: _selectedCategory,
      onCategorySelected: _onCategorySelected,
    );
  }

  /// Category Header with Title and Description
  Widget _buildCategoryHeader() {
    return CategoryHeader(categoryName: _selectedCategory);
  }

  /// Products Grid
  Widget _buildProductsGrid() {
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
                  'No products found',
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

  /// Navigate to Product Detail Page
  void _navigateToProductDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductPage(),
      ),
    );
  }

  /// Mock data generator - Replace with actual controller data
  List<Product> _getMockProductsByCategory(String category) {
    // This should ideally come from the controller
    // For now, generating mock data
    return List.generate(
      6,
      (index) => Product(
        id: '${category}_$index',
        name: 'Tomatoes',
        description: 'Fresh tomatoes starting from 10kg',
        imagePath: 'lib/assets/tomate.png',
        farmName: 'Adam Farm',
        price: 250.0,
        category: category,
        rating: 4.5,
        reviewCount: 150,
      ),
    );
  }
}
