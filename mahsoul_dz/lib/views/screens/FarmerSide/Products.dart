import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/models/farmerSide/product.dart';
import 'package:mahsoul_dz/views/themes/colors.dart';
import 'package:mahsoul_dz/views/widgets/common/Logo.dart';
import 'package:mahsoul_dz/views/widgets/farmerSide/product_tile.dart';
import 'package:mahsoul_dz/views/widgets/farmerSide/product_type.dart';
import 'package:mahsoul_dz/views/widgets/farmerSide/add_product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // variable to handle the filter buttons
  String selectedCategory = 'All';
  List<Product> products = [
    Product(
      id: '1',
      name: 'Apple',
      quantity: 100,
      category: 'Fruits',
      price: 100,
      status: 'available',
    ),
    Product(
      id: '2',
      name: 'Banana',
      quantity: 200,
      category: 'Fruits',
      price: 200,
      status: 'available',
    ),
    Product(
      id: '3',
      name: 'tomato',
      quantity: 300,
      category: 'Vegetables',
      price: 300,
      status: 'available',
    ),
    Product(
      id: '4',
      name: 'rice',
      quantity: 400,
      category: 'Grains',
      price: 400,
      status: 'available',
    ),
    Product(
      id: '5',
      name: 'cereals',
      quantity: 500,
      category: 'Out of stock',
      price: 500,
      status: 'out of stock',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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

                // filter buttons 
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ProductType(
                        Category: 'All',
                        isSelected: selectedCategory == 'All',
                        onTap: () => setState(() => selectedCategory = 'All'),
                      ),
                      SizedBox(width: 8),

                      ProductType(
                        Category: 'Vegetables',
                        isSelected: selectedCategory == 'Vegetables',
                        onTap: () =>
                            setState(() => selectedCategory = 'Vegetables'),
                      ),
                      SizedBox(width: 8),

                      ProductType(
                        Category: 'Fruits',
                        isSelected: selectedCategory == 'Fruits',
                        onTap: () => setState(() => selectedCategory = 'Fruits'),
                      ),
                      SizedBox(width: 8),

                      ProductType(
                        Category: 'Grains',
                        isSelected: selectedCategory == 'Grains',
                        onTap: () => setState(() => selectedCategory = 'Grains'),
                      ),
                      SizedBox(width: 8),

                      ProductType(
                        Category: 'Out of stock',
                        isSelected: selectedCategory == 'Out of stock',
                        onTap: () =>
                            setState(() => selectedCategory = 'Out of stock'),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 15),

                // products list
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filterProducts(selectedCategory, products).length,
                  itemBuilder: (context, index) {
                    final filteredProducts = filterProducts(
                      selectedCategory,
                      products,
                    );
                    return Column(
                      children: [
                        ProductTile(
                          product: filteredProducts[index],
                          imagePath: 'lib/assets/IMAGE.png',
                        ),
                        SizedBox(height: 10),
                      ],
                    );
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
                      onPressed: () {
                        // the add product widget will apear on top
                        // of the screen
                        // ill use showModalBottomSheet
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: AddProductWidget()),
                        );
                      },
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
