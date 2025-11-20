import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/product_card.dart';
import 'package:mahsoul_dz/views/screens/customerSide/main_navigation.dart';
import 'package:mahsoul_dz/views/screens/customerSide/product_detail.dart';
import 'package:mahsoul_dz/views/models/customerSide/product.dart';

class Market extends StatefulWidget {
  const Market({super.key});

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  List<String> categories = ['Vegetables', 'Fruits', 'Guns', 'Others'];
  String selectedCategory = "Vegetables";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35.0,
              vertical: 30.0,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Changed from default center
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey[300]!, width: 1.0),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for products or farmers...',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryChip("Vegetables"),
                    _buildCategoryChip("Fruits"),
                    _buildCategoryChip("Grains"),
                    _buildCategoryChip("Others"),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  selectedCategory,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Discover Fresh $selectedCategory from different farms",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: Product(
                        id: '1',
                        name: 'Tomatoes',
                        description: 'Fresh Tomatoes starting from 10kg',
                        imagePath: 'lib/assets/tomate.png',
                        farmName: 'Adam Farm',
                        price: 250.0,
                        category: 'Vegetables',
                        rating: 4.5,
                        reviewCount: 150,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
