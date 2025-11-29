import 'package:flutter/material.dart';

/// Category Header Widget
/// Displays category title and description
class CategoryHeader extends StatelessWidget {
  final String categoryName;

  const CategoryHeader({
    super.key,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D5F3F),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Discover Fresh $categoryName from different farms",
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
