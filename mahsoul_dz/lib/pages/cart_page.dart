import 'package:flutter/material.dart';
import 'package:mahsoul_dz/pages/cart-proceed.dart';
import 'package:mahsoul_dz/pages/market.dart';
class MahsoulOrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Mahsoul',
          style: TextStyle(
            fontSize: 20, // Slightly smaller
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Organic Tomatoes Section
              _buildProductSection(
                'Organic Tomatoes',
                'Green Valley Farm',
                '\$28.80', // Fixed price to match design
                'lib/assets/carrot.png',
              ),
              
              SizedBox(height: 12), // Reduced spacing
              
              // Organic Carrots Section
              _buildProductSection(
                'Organic Carrots',
                'Green Valley Farm',
                '\$27.00',
                'lib/assets/carrot.png',
              ),
              
              SizedBox(height: 20), // Reduced spacing
              
              // Divider
              Divider(thickness: 1),
              
              SizedBox(height: 20), // Reduced spacing
              
              // Order Summary
              _buildOrderSummary(),
              
              SizedBox(height: 20), // Reduced spacing
              
              // Divider
              Divider(thickness: 1),
              
              SizedBox(height: 20), // Reduced spacing
              
              // Payment in delivery
              Center(
                child: Text(
                  'Requested as Delivery', // Updated text to match design
                  style: TextStyle(
                    fontSize: 14, // Smaller font
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              
              SizedBox(height: 24), // Reduced spacing
              
              // Buttons Section
              _buildButtonSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductSection(String title, String farm, String price, String imagePath) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Smaller radius
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2, // Reduced blur
            offset: Offset(0, 1), // Smaller offset
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image - Exactly 60x60
          Container(
            width: 80, // Fixed width
            height: 80, // Fixed height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover, // Ensures image fits the entire container
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.shopping_bag,
                    color: Colors.grey[400],
                    size: 24, // Smaller icon to fit container
                  );
                },
              ),
            ),
          ),
          
          SizedBox(width: 12), // Reduced spacing
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16, // Smaller font
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2), // Reduced spacing
                Text(
                  farm,
                  style: TextStyle(
                    fontSize: 12, // Smaller font
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4), // Reduced spacing
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16, // Smaller font
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: TextStyle(
            fontSize: 18, // Slightly smaller
            fontWeight: FontWeight.bold,
          ),
        ),
        
        SizedBox(height: 12), // Reduced spacing
        
        _buildSummaryRow('Subtotal', '\$55.50'),
        _buildSummaryRow('Delivery Fee', 'FREE', isFree: true),
        
        SizedBox(height: 12), // Reduced spacing
        
        // Total
        Container(
          padding: EdgeInsets.symmetric(vertical: 6), // Reduced padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16, // Smaller font
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '\$55.50',
                style: TextStyle(
                  fontSize: 18, // Smaller font
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isFree = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2), // Reduced padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14, // Smaller font
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14, // Smaller font
              fontWeight: FontWeight.w600,
              color: isFree ? Colors.green : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSection(BuildContext context) {
    return Column(
      children: [
        // Proceed to Checkout Button
        SizedBox(
          width: double.infinity,
          height: 45, // Slightly smaller button
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderConfirmationPage()),
    );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Smaller radius
              ),
            ),
            child: Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 14, // Smaller font
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        SizedBox(height: 10), // Reduced spacing
        
        // Continue Shopping Button
        SizedBox(
          width: double.infinity,
          height: 45, // Slightly smaller button
          child: OutlinedButton(
            onPressed: () {
              Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Market()),
    );
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Smaller radius
              ),
              side: BorderSide(color: Colors.green),
            ),
            child: Text(
              'Continue Shopping',
              style: TextStyle(
                fontSize: 14, // Smaller font
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    );
  }
}