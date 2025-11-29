import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/screens/customerSide/cart_page.dart';
import 'package:mahsoul_dz/views/widgets/common/page_with_nav.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/product_hero_image.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/product_info_card.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/weight_selector.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/price_summary_card.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/seller_info_card.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/product_details_card.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/customer_reviews_card.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String selectedWeight = '5kg';
  final List<String> availableWeights = ['5kg', '10kg', '20kg'];

  @override
  Widget build(BuildContext context) {
    return PageWithNav(
      currentIndex: 1, // Market tab
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Section
              ProductHeroImage(
                imagePath: 'lib/assets/tomato_bg.png',
                title: 'Tomatoes',
                description:
                    'Organic tomatoes grown with sustainable farming practices (Blida, Algeria, family-owned farm)',
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
                      children: const [
                        ProductInfoCard(
                          svgPath: 'lib/assets/first-svg.svg',
                          text: '23 ± 21.69',
                        ),
                        SizedBox(width: 8),
                        ProductInfoCard(
                          svgPath: 'lib/assets/second-svg.svg',
                          text: '10 KG',
                        ),
                        SizedBox(width: 8),
                        ProductInfoCard(
                          svgPath: 'lib/assets/third-svg.svg',
                          text: 'Blida',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Available Weights
                    WeightSelector(
                      selectedWeight: selectedWeight,
                      weights: availableWeights,
                      onWeightSelected: (weight) {
                        setState(() {
                          selectedWeight = weight;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Price and Delivery
                    const PriceSummaryCard(
                      subtotal: '100 DA',
                      deliveryFee: 'FREE',
                    ),
                    const SizedBox(height: 20),

                    // Add to Cart Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MahsoulOrderScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Add to Cart',
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
                    const SellerInfoCard(
                      farmName: "Adam's Organic Farm",
                      initials: 'AF',
                      rating: 4.9,
                      reviewCount: 234,
                      isVerified: true,
                    ),
                    const SizedBox(height: 24),

                    // Product Details Section
                    const ProductDetailsCard(
                      origin: 'Blida, Algeria',
                      harvestDate: '25th October',
                      isOrganic: true,
                      storage: 'Room Temperature',
                    ),
                    const SizedBox(height: 16),

                    // Customer Reviews Section
                    CustomerReviewsCard(
                      reviewCount: 3,
                      averageRating: 4.9,
                      totalRatings: 234,
                      reviews: [
                        ReviewItem(
                          name: 'Sarah Ahmed',
                          rating: 5,
                          time: '2 days ago',
                          comment:
                              'Amazing quality vegetables! Fresh and organic as promised. The delivery was quick and the packaging was perfect.',
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
