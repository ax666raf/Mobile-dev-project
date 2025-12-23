import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'dart:ui';
import 'package:mahsoul_dz/presentation/widgets/customerSide/categories.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/featuredFarmer.dart';
import 'package:mahsoul_dz/presentation/widgets/common/Logo.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/customer_side_screens.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 26.0,
              vertical: 15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // logo
                Logo(),

                SizedBox(height: 35),

                // discount panel
                SizedBox(
                  height: 180, // Fixed height to contain the image
                  child: Stack(
                    clipBehavior: Clip.none, // Allow overflow
                    children: [
                      // Full width container
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor,
                              primaryColor.withOpacity(0.8),
                              primaryColor.withOpacity(0.9),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              offset: const Offset(4, 4),
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.only(
                          left:
                              15, // Reduced left padding to move text more to the left
                          right:
                              200, // Fixed right padding to make room for image
                          top: 20,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.shopSmarter,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              l10n.saveMore,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                // Handle discount code
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white.withOpacity(0.3),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      l10n.getDiscount,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Discount image positioned on the right side for both RTL and LTR
                      Positioned(
                        right:
                            -60, // Position on right side, further out to avoid text overlap
                        top: -47, // Head and hat extend above
                        child: Image.asset(
                          'lib/assets/discountImage.png',
                          width: 260,
                          height: 260,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      l10n.categories,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                // categories
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.85,
                  children: [
                    CategoriesCard(
                      imagePath: 'lib/assets/vegetables.png',
                      title: l10n.vegetables,
                      count: l10n.farmersCount('120'),
                    ),
                    CategoriesCard(
                      imagePath: 'lib/assets/fruits.png',
                      title: l10n.fruits,
                      count: l10n.farmersCount('85'),
                    ),
                    CategoriesCard(
                      imagePath: 'lib/assets/wheat-sack.png',
                      title: l10n.cereals,
                      count: l10n.farmersCount('120'),
                    ),
                    CategoriesCard(
                      imagePath: 'lib/assets/cotton.png',
                      title: l10n.cotton,
                      count: l10n.farmersCount('85'),
                    ),
                  ],
                ),

                // discover the market button
                SizedBox(height: 20),
                MyButton(
                  text: l10n.discoverMarket,
                  onPressed: () {
                    // Navigate to Market with navbar
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MarketWithNav(),
                      ),
                    );
                  },
                ),

                // featured farmers
                SizedBox(height: 20),
                Text(
                  l10n.featuredFarmers,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                FeaturedFarmer(
                  profileImage: 'lib/assets/farmerpfp.png',
                  name: 'John Doe',
                  rating: '4.5',
                  availability: l10n.available,
                  location: l10n.distanceAway('2.5'),
                  products: l10n.productsCount('100'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
