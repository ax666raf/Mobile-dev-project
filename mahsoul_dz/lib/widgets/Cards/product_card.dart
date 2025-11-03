import 'package:flutter/material.dart';
import 'package:mahsoul_dz/widgets/button.dart';
import 'package:mahsoul_dz/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onPressed;

  const ProductCard({
    super.key,
    required this.product,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 100,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(product.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Product Name
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            
            // Product Description
            Text(
              product.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            
            // Farm Name
            Text(
              product.farmName,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            // Discover More Button
            SizedBox(
              height: 38,
              width: double.infinity,
              child: MyButton(
                text: "Discover More",
                onPressed: onPressed,
                backgroundColor: Colors.green,
                borderColor: Colors.green,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}