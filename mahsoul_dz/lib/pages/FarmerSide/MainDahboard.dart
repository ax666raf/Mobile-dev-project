import 'package:flutter/material.dart';
import 'package:mahsoul_dz/widgets/button.dart';
import 'package:mahsoul_dz/pages/FarmerSide/Products.dart';
import 'package:mahsoul_dz/widgets/order.dart';
import 'package:mahsoul_dz/models/order.dart';
import 'package:mahsoul_dz/models/customer.dart';
import 'package:mahsoul_dz/themes/colors.dart';

class MainDashboard extends StatefulWidget {
  final List<Order> orders = [
    Order(
      customer: Customer(id: '1', fullName: 'John Doe'),
      farmer: 'John Doe',
      weight: 10,
      totalPrice: 100,
      status: OrderStatus.pending,
    ),
    Order(
      customer: Customer(id: '2', fullName: 'Jane Doe'),
      farmer: 'Jane Doe',
      weight: 20,
      totalPrice: 200,
      status: OrderStatus.confirmed,
    ),
    Order(
      customer: Customer(id: '3', fullName: 'Jim Doe'),
      farmer: 'Jim Doe',
      weight: 30,
      totalPrice: 300,
      status: OrderStatus.processing,
    ),
  ];

  MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 26.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // header
                Text(
                  'Mahsoul',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    // hi icon
                    Image.asset('lib/assets/hi.png'),

                    SizedBox(width: 10),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning,',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Here's how your farm is doing today.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          MyButton(
                             backgroundColor: Colors.transparent,
                            textColor: primaryColor,
                            borderColor: primaryColor,
                            icon: Icons.add,
                            text: 'Add product',
                            onPressed: () {},
                           ),
                           SizedBox(width: 10),
                          MyButton(
                             backgroundColor: Colors.transparent,
                            textColor: primaryColor,
                            borderColor: primaryColor,
                            icon: Icons.store,
                            text: 'My Products',
                            onPressed: () {
                              Navigator.pushNamed(context, '/ProductsPage');},
                          ),
                       ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          MyButton(
                            backgroundColor: Colors.transparent,
                            textColor: primaryColor,
                            borderColor: primaryColor,
                            icon: Icons.shopping_bag,
                            text: 'View Orders',
                            onPressed: () {
                              Navigator.pushNamed(context, '/OrdersPage');
                        },
                      ),
                          SizedBox(width: 10),
                          MyButton(
                            backgroundColor: Colors.transparent,
                            textColor: primaryColor,
                            borderColor: primaryColor,
                            icon: Icons.message,
                            text: 'My Messages',
                            onPressed: () {
                              Navigator.pushNamed(context, '/ProductsPage');
                            },
                          ),
                  
                        ],
                      ),
                    ],
                  ),
                ),
              

                SizedBox(height: 20),
                // recent orders
                Text(
                  'Recent Orders',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),
                Column(
                  children:
                      widget.orders
                          .expand(
                            (order) => [
                              OrderTile(order: order),
                              SizedBox(height: 10),
                            ],
                          )
                          .toList()
                        ..removeLast(), // Remove trailing SizedBox
                ),

                // bottom navigation bar
              ],
            ),
          ),
        ),
      ),
    );
  }
}
