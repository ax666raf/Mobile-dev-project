import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/themes/colors.dart';
import 'dart:ui';
import 'package:mahsoul_dz/views/widgets/customerSide/categories.dart';
import 'package:mahsoul_dz/views/widgets/common/button.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/featuredFarmer.dart';
import 'package:mahsoul_dz/views/widgets/common/Logo.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
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
                      Container(
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            // title and button
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Shop Smarter',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Save More!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      // TODO: Implement the discount code
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          child: Text(
                                            'Get 30% off ✨',
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
                            // Spacer to push image to the right
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                      // Discount image positioned to extend beyond container
                      Positioned(
                        right: -30,
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

                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Categories",
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
                      title: 'Vegetables',
                      count: '120+ farmers',
                    ),
                    CategoriesCard(
                      imagePath: 'lib/assets/fruits.png',
                      title: 'Fruits',
                      count: '85+ farmers',
                    ),
                    CategoriesCard(
                      imagePath: 'lib/assets/wheat-sack.png',
                      title: 'Cereals',
                      count: '120+ farmers',
                    ),
                    CategoriesCard(
                      imagePath: 'lib/assets/cotton.png',
                      title: 'Cotton',
                      count: '85+ farmers',
                    ),
                  ],
                ),

                // discover the market button
                SizedBox(height: 20),
                MyButton(
                  text: 'Discover The Market',
                  onPressed: () {
                    // TODO: Implement the discover the market button
                  },
                ),

                // featured farmers
                SizedBox(height: 20),
                Text(
                  'Featured Farmers',
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
                  availability: 'Available',
                  location: '2.5 km away',
                  products: '100+ products',
                )

                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
