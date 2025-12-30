import 'package:flutter/material.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';

class OrderType extends StatelessWidget {
  final String orderType;
  final bool isSelected;
  final Function() onTap;
  const OrderType({super.key, required this.orderType, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
            ),
          color: isSelected ? primaryColor : Colors.grey[300]!,
        ),
        child: Text(
          orderType,
          style: TextStyle(fontSize: 16, 
          color: isSelected ? Colors.white : Colors.grey[700]),
        ),
      ),
    );
  }
}