import 'package:flutter/material.dart';
import 'package:mahsoul_dz/controllers/market_controller.dart';
import 'package:mahsoul_dz/widgets/Cards/product_card.dart';
import 'package:mahsoul_dz/pages/main_navigation.dart';

class Market extends StatefulWidget {
  const Market({super.key});

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  final MarketController controller = MarketController();
  
  List<String> categories = ['All', 'Vegetables', 'Fruits', 'Grains', 'Others']; // Add 'All'
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedCategory = categories[selectedIndex];
    final products = controller.getByCategory(selectedCategory);

    return Scaffold(
      bottomNavigationBar: const MainNavigation(),
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildCategoryChips(),
              const SizedBox(height: 10),
              Text(
                selectedCategory,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Discover Fresh $selectedCategory from different farms",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildProductGrid(products),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search for products or farmers...',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(categories.length, (index) {
        bool isSelected = selectedIndex == index;
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ChoiceChip(
            label: Text(categories[index]),
            selected: isSelected,
            selectedColor: Colors.green,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
            onSelected: (_) {
              setState(() => selectedIndex = index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildProductGrid(List products) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final crop = products[index];
         return ProductCard(product: crop);
      },
    );
  }
}
