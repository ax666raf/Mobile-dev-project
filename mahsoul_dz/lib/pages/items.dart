import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mahsoul_dz/controllers/items_controll.dart';
import 'package:mahsoul_dz/models/product_model.dart';

class TomatoProductScreen extends StatelessWidget {
  const TomatoProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = ProductModel(
      name: 'Tomatoes',
      description: 'Organic tomatoes grown with sustainable farming practices. Locally-picked, Bilaalo, Algeria. Family-owned farm since 1987.',
      rating: 4.8,
      reviews: 5,
      price: 100,
      currency: 'DA',
      deliveryFee: 'FREE',
      category: "Fruits",
      weights: [
        WeightOption(value: '5kg', available: true),
        WeightOption(value: '10kg', available: true),
        WeightOption(value: '20kg', available: true),
      ],
      seller: SellerInfo(
        name: "Adam's Organic Farm",
        type: 'Verified Farmer',
        rating: 4.8,
        reviews: 8,
      ),
      features: [
        FeatureItem(icon: '🏆', label: '1000 SA'),
        FeatureItem(icon: '📦', label: '10 KG'),
        FeatureItem(icon: '🏪', label: 'Store'),
      ],
    );

    return ChangeNotifierProvider(
      create: (context) => ProductController(product: product),
      child: const _TomatoProductView(),
    );
  }
}

class _TomatoProductView extends StatelessWidget {
  const _TomatoProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ProductController>(context);
    
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 290,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/assets/tomato_bg.png'), 
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.product.name,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.product.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Features Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: controller.product.features.map((feature) {
                      return Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                feature.icon,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            feature.label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     const Text(
  'Available Weights',
  style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  ),
),
const SizedBox(height: 12),

Consumer<ProductController>(
  builder: (context, controller, child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: controller.product.weights.map((weight) {
        final isSelected = controller.selectedWeight == weight.value;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: 80, // fixed width so they don’t flex
            height: 40,
            child: ElevatedButton(
              onPressed: () => controller.selectWeight(weight.value),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected
                    ? Colors.green.shade600
                    : Colors.grey.shade100,
                foregroundColor: isSelected
                    ? Colors.white
                    : Colors.black87,
                elevation: isSelected ? 2 : 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                weight.value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  },
),

                      const SizedBox(height: 24),

                      // Price
                      Container(
  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
  decoration: BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Subtotal',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          Text(
            '100 DA',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Delivery Fee',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          Text(
            controller.product.deliveryFee,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade600,
            ),
          ),
        ],
      ),
    ],
  ),
),

                      const SizedBox(height: 24),

                      // Add to Cart Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Seller Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text('🌱', style: TextStyle(fontSize: 24)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.product.seller.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        controller.product.seller.type,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        ' • ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber.shade600,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${controller.product.seller.rating}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        ' (${controller.product.seller.reviews} reviews)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}