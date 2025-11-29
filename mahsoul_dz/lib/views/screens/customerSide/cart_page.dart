import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/screens/customerSide/cart-proceed.dart';
import 'package:mahsoul_dz/views/screens/customerSide/market.dart';
import 'package:mahsoul_dz/views/widgets/common/page_with_nav.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/cart_product_card.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/order_summary_card.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/cart_buttons.dart';

class MahsoulOrderScreen extends StatefulWidget {
  const MahsoulOrderScreen({super.key});

  @override
  State<MahsoulOrderScreen> createState() => _MahsoulOrderScreenState();
}

class _MahsoulOrderScreenState extends State<MahsoulOrderScreen> {
  // Product list
  List<Map<String, dynamic>> products = [
    {
      'title': 'Organic Tomatoes',
      'farm': 'Green Valley Farm',
      'price': 28.80,
      'imagePath': 'lib/assets/tomate.png',
    },
    {
      'title': 'Organic Carrots',
      'farm': 'Green Valley Farm',
      'price': 27.00,
      'imagePath': 'lib/assets/carrot.png',
    },
  ];

  void _removeItem(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  double get _subtotal {
    return products.fold(0.0, (sum, item) => sum + (item['price'] as double));
  }

  double get _total => _subtotal; // Delivery is free

  @override
  Widget build(BuildContext context) {
    return PageWithNav(
      currentIndex: 0, // Home tab
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mahsoul',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.eco,
                color: Colors.green,
                size: 20,
              ),
            ],
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Products List - Each in its own card
              ...List.generate(products.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CartProductCard(
                    title: products[index]['title'],
                    farm: products[index]['farm'],
                    price: products[index]['price'],
                    imagePath: products[index]['imagePath'],
                    onRemove: () => _removeItem(index),
                  ),
                );
              }),

              const SizedBox(height: 8),

              // Order Summary Card - Separate card
              OrderSummaryCard(
                subtotal: _subtotal,
                total: _total,
              ),

              const SizedBox(height: 20),

              // Payment in delivery
              Center(
                child: Text(
                  'Payment in Delivery',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Buttons Section
              CartButtons(
                isCartEmpty: products.isEmpty,
                onProceed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderConfirmationPage(),
                    ),
                  );
                },
                onContinueShopping: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Market()),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


}
