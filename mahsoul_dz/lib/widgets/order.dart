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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Weight: ${order.weight} kg',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  // TODO: Implement call functionality
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    child: Row(
                      children: [
                        Icon(
                          Icons.call,
                          color: Colors.grey[600],
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'call',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    
                    color: order.status == OrderStatus.pending
                        ? const Color.fromARGB(255, 235, 188, 119)
                        : order.status == OrderStatus.confirmed
                        ? Colors.green
                        : order.status == OrderStatus.processing
                        ? const Color.fromARGB(255, 222, 120, 94)
                        : order.status == OrderStatus.shipped
                        ? Colors.purple
                        : order.status == OrderStatus.delivered
                        ? const Color.fromARGB(255, 87, 123, 213)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    child: Text(
                      '${order.statusString}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              

              Text(
                '${order.totalPrice} DA',
                style: TextStyle(fontSize: 14, color: primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
