import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mahsoul_dz/controllers/checkout_controller.dart';
import 'package:mahsoul_dz/models/customer.dart';
import 'package:mahsoul_dz/models/cart_model.dart';

class CheckoutScreen extends StatefulWidget {
  final Customer customer;
  
  const CheckoutScreen({
    super.key,
    required this.customer,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutController _controller = CheckoutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mahasol',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Products List
          _buildProductsList(),
          
          const SizedBox(height: 32),
          
          // Order Summary Section
          _buildOrderSummarySection(),
          
          const SizedBox(height: 32),
          
          // Process to Checkout Section
          _buildCheckoutProcessSection(),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    if (_controller.cart.items.isEmpty) {
      return const Center(
        child: Text('Your cart is empty'),
      );
    }
    
    return Column(
      children: List.generate(_controller.cart.items.length, (index) {
        final cartItem = _controller.cart.items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCartItem(cartItem, index),
        );
      }),
    );
  }

  Widget _buildCartItem(CartItem cartItem, int index) {
    final product = cartItem.product;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Placeholder for product image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.image,
              color: Colors.grey,
              size: 40,
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  cartItem.selectedWeight,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  '${product.currency}${(product.price / 100).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          
          // Quantity selector
          _buildQuantitySelector(cartItem, index),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(CartItem cartItem, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _controller.decreaseQuantity(index);
              });
            },
            child: Icon(Icons.remove, size: 16, color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
          Text('${cartItem.quantity}', style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                _controller.increaseQuantity(index);
              });
            },
            child: Icon(Icons.add, size: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection() {
    final cart = _controller.cart;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          
          const SizedBox(height: 16),
          
          _buildSummaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
          
          const SizedBox(height: 8),
          
          _buildSummaryRow('Delivery Fee', 'FREE', isFree: true),
          
          const SizedBox(height: 16),
          
          Container(
            height: 1,
            color: Colors.grey[300],
          ),
          
          const SizedBox(height: 16),
          
          _buildSummaryRow('Total', '\$${cart.total.toStringAsFixed(2)}', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isFree = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isFree ? Colors.green : (isTotal ? Colors.green : Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutProcessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Process to Checkout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Placeholder for checkout process animation/illustration
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: const Center(
            child: Icon(
              Icons.animation,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Continue Shopping Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _controller.continueShopping();
              Navigator.pop(context); // Go back to products screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Continue Shopping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Proceed to Checkout Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              final order = _controller.createOrder(widget.customer, 'Organic Farms');
              _controller.proceedToCheckout();
              // Navigate to payment screen with the order
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => PaymentScreen(order: order),
              // ));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}