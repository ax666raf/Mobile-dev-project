import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/cart_page.dart';
import 'package:mahsoul_dz/presentation/widgets/common/page_with_nav.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/product_hero_image.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/product_info_card.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/weight_selector.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/price_summary_card.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/seller_info_card.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/product_details_card.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/customer_reviews_card.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/product_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/cart_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  
  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String selectedWeight = '';
  List<String> availableWeights = [];
  Map<String, dynamic>? productData;
  List<Map<String, dynamic>> reviews = [];
  double basePrice = 0.0;
  
  // Calculate price based on selected weight
  // Price doubles for each weight increment (500g = 1x, 1kg = 2x, 2kg = 4x, etc.)
  double _calculatePriceForWeight(String weight) {
    if (basePrice == 0.0 || weight.isEmpty) return basePrice;
    
    // Extract numeric value from weight string (e.g., "500g" -> 0.5, "1kg" -> 1, "2kg" -> 2)
    final weightStr = weight.toLowerCase().replaceAll('kg', '').replaceAll('g', '').trim();
    double weightValue = 0.0;
    
    try {
      weightValue = double.parse(weightStr);
      // Convert grams to kg (if it's in grams, divide by 1000)
      if (weight.toLowerCase().contains('g') && !weight.toLowerCase().contains('kg')) {
        weightValue = weightValue / 1000.0;
      }
    } catch (e) {
      // If parsing fails, default to 1kg
      weightValue = 1.0;
    }
    
    // Calculate multiplier: base is 0.5kg (500g), so multiply by (weightValue / 0.5)
    // This means: 500g = 1x, 1kg = 2x, 2kg = 4x, etc.
    final multiplier = weightValue / 0.5;
    return basePrice * multiplier;
  }

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    final productCubit = ProductCubit(DependencyInjection.productRepository);
    final product = await productCubit.getProductById(widget.productId);
    
    if (product != null) {
      setState(() {
        productData = product;
        basePrice = (product['price'] as num?)?.toDouble() ?? 0.0;
        // Get available weights from product_weights
        final weights = product['weights'] as List<dynamic>? ?? [];
        availableWeights = weights
            .where((w) {
              final weightData = w as Map<String, dynamic>;
              return weightData['is_available'] == true || weightData['is_available'] == 1;
            })
            .map((w) => (w as Map<String, dynamic>)['weight_value'] as String)
            .toList();
        if (availableWeights.isNotEmpty) {
          selectedWeight = availableWeights.first;
        }
      });
      
      // Load reviews
      final productReviews = await productCubit.getProductReviews(widget.productId);
      setState(() {
        reviews = productReviews;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (productData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final product = productData!;
    final category = product['category'] as String? ?? '';
    final origin = product['origin'] as String? ?? '';
    final harvestSeason = product['harvest_season'] as String? ?? '';
    final isOrganic = product['is_organic'] == 1 || product['is_organic'] == true;
    final storageInstructions = product['storage_instructions'] as String? ?? '';
    // Calculate price based on selected weight
    final price = _calculatePriceForWeight(selectedWeight);
    final rating = (product['rating'] as num?)?.toDouble() ?? 0.0;
    final reviewCount = product['review_count'] as int? ?? 0;
    final farmer = product['farmer'] as Map<String, dynamic>?;
    final farmName = farmer?['farm_name'] as String? ?? '';
    final imagePath = product['image_path'] as String? ?? 'lib/assets/tomato_bg.png';
    
    // Format reviews
    final reviewItems = reviews.map((r) {
      final userName = r['user']?['full_name'] as String? ?? l10n.anonymous;
      final rating = (r['rating'] as num?)?.toInt() ?? 5;
      final comment = r['comment'] as String? ?? '';
      final createdAt = r['created_at'] as int?;
      final date = createdAt != null 
          ? DateTime.fromMillisecondsSinceEpoch(createdAt)
          : DateTime.now();
      final daysAgo = DateTime.now().difference(date).inDays;
      
      String timeText;
      if (daysAgo == 0) {
        timeText = l10n.today;
      } else if (daysAgo == 1) {
        timeText = l10n.yesterday;
      } else {
        // Use simple format for days ago
        timeText = '$daysAgo ${daysAgo == 1 ? 'day' : 'days'} ago';
      }
      
      return ReviewItem(
        name: userName,
        rating: rating,
        time: timeText,
        comment: comment,
      );
    }).toList();
    
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Section
              ProductHeroImage(
                imagePath: imagePath,
                title: category,
                description: isOrganic ? l10n.organic : '',
                onBackPressed: () => Navigator.pop(context),
              ),

              // Product Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Cards Row
                    Row(
                      children: [
                        ProductInfoCard(
                          svgPath: 'lib/assets/first-svg.svg',
                          text: '${rating.toStringAsFixed(1)} ± ${(rating * 0.1).toStringAsFixed(2)}',
                        ),
                        SizedBox(width: 8),
                        ProductInfoCard(
                          svgPath: 'lib/assets/second-svg.svg',
                          text: selectedWeight.isNotEmpty ? selectedWeight : l10n.nA,
                        ),
                        SizedBox(width: 8),
                        ProductInfoCard(
                          svgPath: 'lib/assets/third-svg.svg',
                          text: origin.isNotEmpty ? origin : l10n.nA,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Available Weights
                    if (availableWeights.isNotEmpty)
                      WeightSelector(
                        selectedWeight: selectedWeight,
                        weights: availableWeights,
                        onWeightSelected: (weight) {
                          setState(() {
                            selectedWeight = weight;
                          });
                        },
                      ),
                    if (availableWeights.isNotEmpty) const SizedBox(height: 24),

                    // Price and Delivery
                    PriceSummaryCard(
                      subtotal: '${price.toStringAsFixed(2)} ${l10n.da}',
                      deliveryFee: l10n.free,
                    ),
                    const SizedBox(height: 20),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          // Get customerId from AuthCubit
                          final authState = context.read<AuthCubit>().state;
                          if (authState is AuthAuthenticated && authState.userType == 'customer') {
                            // Validate weight is selected
                            if (selectedWeight.isEmpty && availableWeights.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.pleaseSelectWeight),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }
                            
                            // Add to cart using CartCubit
                            final cartCubit = CartCubit(DependencyInjection.cartRepository, authState.userId);
                            try {
                              await cartCubit.addToCart(
                                widget.productId,
                                selectedWeight.isNotEmpty ? selectedWeight : '1kg', // Default weight if none available
                                1, // Quantity
                              );
                              
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.productAddedToCart),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              
                              // Wait for cart to reload after adding item
                              await Future.delayed(const Duration(milliseconds: 300));
                              
                              // Navigate to cart using the same cubit that added the item
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: cartCubit,
                                    child: MahsoulOrderScreen(customerId: authState.userId),
                                  ),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${l10n.failedToAddToCart}: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.pleaseLoginToAddToCart),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.addToCart,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Seller Info
                    if (farmName.isNotEmpty)
                      SellerInfoCard(
                        farmName: farmName,
                        initials: farmName.isNotEmpty 
                            ? farmName.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
                            : 'F',
                        rating: rating,
                        reviewCount: reviewCount,
                        isVerified: farmer?['is_verified'] == 1 || farmer?['is_verified'] == true,
                      ),
                    if (farmName.isNotEmpty) const SizedBox(height: 24),

                    // Product Details Section
                    ProductDetailsCard(
                      origin: origin.isNotEmpty ? origin : l10n.nA,
                      harvestDate: harvestSeason.isNotEmpty ? harvestSeason : l10n.nA,
                      isOrganic: isOrganic,
                      storage: storageInstructions.isNotEmpty ? storageInstructions : l10n.nA,
                    ),
                    const SizedBox(height: 16),

                    // Customer Reviews Section
                    CustomerReviewsCard(
                      reviewCount: reviewItems.length,
                      averageRating: rating,
                      totalRatings: reviewCount,
                      reviews: reviewItems,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
