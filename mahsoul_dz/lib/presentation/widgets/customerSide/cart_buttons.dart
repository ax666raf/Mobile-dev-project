import 'package:flutter/material.dart';

/// Cart Buttons Widget
/// Contains Proceed to Checkout and Continue Shopping buttons
class CartButtons extends StatelessWidget {
  final VoidCallback onProceed;
  final VoidCallback onContinueShopping;
  final bool isCartEmpty;

  const CartButtons({
    super.key,
    required this.onProceed,
    required this.onContinueShopping,
    this.isCartEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Proceed to Checkout Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isCartEmpty ? null : onProceed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Continue Shopping Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: onContinueShopping,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Continue Shopping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
