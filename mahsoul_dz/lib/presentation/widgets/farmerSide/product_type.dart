import 'package:flutter/material.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';

class ProductType extends StatelessWidget {
  final String Category;
  final bool isSelected;
  final Function() onTap;
  const ProductType({
    super.key,
    required this.Category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
          ),
          color: isSelected ? primaryColor : Colors.grey[300]!,
        ),
        child: Center(
          child: Text(
            Category,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
