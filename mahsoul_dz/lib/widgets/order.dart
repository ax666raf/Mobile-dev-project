import 'package:flutter/material.dart';
import 'package:mahsoul_dz/models/order.dart';
import 'package:mahsoul_dz/themes/colors.dart';



class OrderTile extends StatelessWidget {
  final Order order;
  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer: ${order.customer.fullName}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Weight: ${order.weight} kg',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${order.statusString}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${order.totalPrice} DA',
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}