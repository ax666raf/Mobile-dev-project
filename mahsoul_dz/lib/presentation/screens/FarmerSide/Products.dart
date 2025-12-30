import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/models/farmerSide/product.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/widgets/common/Logo.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/product_tile.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/product_type.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/add_product.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_product_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // variable to handle the filter buttons
  String selectedCategory = 'All';

  void _openAddProductDialog(BuildContext context) {
    final cubit = context.read<FarmerProductCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: BlocProvider.value(value: cubit, child: AddProductWidget()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        String? farmerId;
        if (authState is AuthAuthenticated && authState.userType == 'farmer') {
          farmerId = authState.userId;
        }

        if (farmerId == null) {
          final l10n = AppLocalizations.of(context)!;
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text(l10n.pleaseLoginToViewProducts)),
          );
        }

        return BlocProvider(
          create: (context) => FarmerProductCubit(
            DependencyInjection.farmerRepository,
            farmerId!,
          )..loadProducts(),
          child: _ProductsPageContent(
            selectedCategory: selectedCategory,
            onCategoryChanged: (category) {
              setState(() => selectedCategory = category);
            },
            onOpenAddDialog: _openAddProductDialog,
          ),
        );
      },
    );
  }
}

class _ProductsPageContent extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;
  final Function(BuildContext) onOpenAddDialog;

  const _ProductsPageContent({
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onOpenAddDialog,
  });

  @override
  State<_ProductsPageContent> createState() => _ProductsPageContentState();
}

class _ProductsPageContentState extends State<_ProductsPageContent> {
  @override
  void initState() {
    super.initState();
    // Check if we should open add dialog from route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['openAddDialog'] == true) {
        widget.onOpenAddDialog(context);
      }
    });
  }

  void _openAddProductDialog() {
    final cubit = context.read<FarmerProductCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: BlocProvider.value(value: cubit, child: AddProductWidget()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 26.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // header
                Logo(),

                SizedBox(height: 35),

                // filter buttons - Two rows layout
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First row: All, Vegetables, Fruits
                    Row(
                      children: [
                        Expanded(
                          child: ProductType(
                            Category: 'All',
                            isSelected: widget.selectedCategory == 'All',
                            onTap: () {
                              widget.onCategoryChanged('All');
                              context.read<FarmerProductCubit>().loadProducts();
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ProductType(
                            Category: 'Vegetables',
                            isSelected: widget.selectedCategory == 'Vegetables',
                            onTap: () {
                              widget.onCategoryChanged('Vegetables');
                              context
                                  .read<FarmerProductCubit>()
                                  .loadProductsByCategory('Vegetables');
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ProductType(
                            Category: 'Fruits',
                            isSelected: widget.selectedCategory == 'Fruits',
                            onTap: () {
                              widget.onCategoryChanged('Fruits');
                              context
                                  .read<FarmerProductCubit>()
                                  .loadProductsByCategory('Fruits');
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Second row: Grains, Out of stock
                    Row(
                      children: [
                        Expanded(
                          child: ProductType(
                            Category: 'Grains',
                            isSelected: widget.selectedCategory == 'Grains',
                            onTap: () {
                              widget.onCategoryChanged('Grains');
                              context
                                  .read<FarmerProductCubit>()
                                  .loadProductsByCategory('Grains');
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ProductType(
                            Category: 'Out of stock',
                            isSelected:
                                widget.selectedCategory == 'Out of stock',
                            onTap: () {
                              widget.onCategoryChanged('Out of stock');
                              context.read<FarmerProductCubit>().loadProducts();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // products list
                BlocBuilder<FarmerProductCubit, FarmerProductState>(
                  builder: (context, state) {
                    if (state is FarmerProductLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (state is FarmerProductError) {
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
                              state.message,
                              style: TextStyle(color: Colors.red.shade600),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is FarmerProductLoaded) {
                      final productsData = state.products;

                      // Convert to Product model
                      List<Product> products = productsData.map((p) {
                        // Extract weights from backend response
                        final weights = p['weights'] as List<dynamic>? ?? [];
                        // Get the first available weight, or default to '1kg'
                        String firstWeight = '1kg';
                        if (weights.isNotEmpty) {
                          final firstWeightMap =
                              weights.first as Map<String, dynamic>?;
                          if (firstWeightMap != null) {
                            firstWeight =
                                firstWeightMap['weight_value'] as String? ??
                                '1kg';
                          }
                        }
                        // Calculate quantity from first weight (e.g., "1kg" -> 1.0, "500g" -> 0.5)
                        double quantity = 1.0;
                        if (firstWeight.toLowerCase().endsWith('kg')) {
                          final kgValue = firstWeight
                              .toLowerCase()
                              .replaceAll('kg', '')
                              .trim();
                          quantity = double.tryParse(kgValue) ?? 1.0;
                        } else if (firstWeight.toLowerCase().endsWith('g')) {
                          final gValue = firstWeight
                              .toLowerCase()
                              .replaceAll('g', '')
                              .trim();
                          quantity =
                              (double.tryParse(gValue) ?? 1000.0) / 1000.0;
                        }

                        return Product(
                          id: p['id'] as String? ?? '',
                          name: p['name'] as String? ?? '',
                          quantity: quantity,
                          category: p['category'] as String? ?? '',
                          price: (p['price'] as num?)?.toDouble() ?? 0.0,
                          status: p['status'] as String? ?? 'available',
                        );
                      }).toList();

                      // Filter by selected category
                      final filteredProducts = filterProducts(
                        widget.selectedCategory,
                        products,
                      );

                      if (filteredProducts.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Text(l10n.noProductsFound),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final productData = productsData.firstWhere(
                            (p) => (p['id'] as String?) == product.id,
                            orElse: () => <String, dynamic>{},
                          );
                          final imagePath =
                              productData['image_path'] as String? ??
                              'lib/assets/IMAGE.png';
                          // Get weights for display
                          final weights =
                              productData['weights'] as List<dynamic>? ?? [];
                          final weightStrings = weights
                              .map((w) {
                                final weightMap = w as Map<String, dynamic>?;
                                return weightMap?['weight_value'] as String? ??
                                    '';
                              })
                              .where((w) => w.isNotEmpty)
                              .toList();

                          return ProductTile(
                            product: product,
                            imagePath: imagePath,
                            availableWeights: weightStrings,
                            productData: productData, // Pass full product data
                          );
                        },
                      );
                    }

                    return Center(child: Text(l10n.noProductsAvailable));
                  },
                ),

                SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(25),
                        backgroundColor: primaryColor,
                        shape: CircleBorder(),
                      ),
                      onPressed: () => _openAddProductDialog(),
                      child: Icon(Icons.add, color: Colors.black, size: 25),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// function to filter the products based on the selected category
List<Product> filterProducts(String selectedCategory, List<Product> products) {
  if (selectedCategory == 'All') {
    return products;
  } else if (selectedCategory == 'Out of stock') {
    return products
        .where((product) => product.status == 'out of stock')
        .toList();
  } else {
    return products
        .where(
          (product) => product.category.toLowerCase().contains(
            selectedCategory.toLowerCase(),
          ),
        )
        .toList();
  }
}
