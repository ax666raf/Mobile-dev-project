import 'package:flutter/material.dart';
import 'package:mahsoul_dz/views/models/customerSide/customer.dart';
import 'package:mahsoul_dz/views/models/farmerSide/order.dart';
import 'package:mahsoul_dz/views/widgets/common/Logo.dart';
import 'package:mahsoul_dz/views/widgets/farmerSide/order.dart';
import 'package:mahsoul_dz/views/widgets/farmerSide/order_type.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // variable the filter
  String selectedOrderType = 'All';
  List<Order> orders = [
    Order(
      customer: Customer(id: '1', fullName: 'sofia lalam'),
      farmer: 'sofia lalam',
      weight: 10,
      totalPrice: 100,
      status: OrderStatus.pending,
      deliveryMethod: 'Home Delivery',
      address: '123 Main St, Anytown, USA',
      paymentMethod: 'Cash',
      paymentStatus: 'Pending',
    ),
    Order(
      customer: Customer(id: '1', fullName: 'sofia lalam'),
      farmer: 'sofia lalam',
      weight: 10,
      totalPrice: 100,
      status: OrderStatus.confirmed,
      deliveryMethod: 'Home Delivery',
      address: '123 Main St, Anytown, USA',
      paymentMethod: 'Cash',
      paymentStatus: 'Pending',
    ),
    Order(
      customer: Customer(id: '1', fullName: 'sofia lalam'),
      farmer: 'sofia lalam',
      weight: 10,
      totalPrice: 100,
      status: OrderStatus.cancelled,
      deliveryMethod: 'Home Delivery',
      address: '123 Main St, Anytown, USA',
      paymentMethod: 'Cash',
      paymentStatus: 'Pending',
    ),
    Order(
      customer: Customer(id: '1', fullName: 'sofia lalam'),
      farmer: 'sofia lalam',
      weight: 10,
      totalPrice: 100,
      status: OrderStatus.confirmed,
      deliveryMethod: 'Home Delivery',
      address: '123 Main St, Anytown, USA',
      paymentMethod: 'Cash',
      paymentStatus: 'Pending',
    ),
    Order(
      customer: Customer(id: '1', fullName: 'sofia lalam'),
      farmer: 'sofia lalam',
      weight: 10,
      totalPrice: 100,
      status: OrderStatus.pending,
      deliveryMethod: 'Home Delivery',
      address: '123 Main St, Anytown, USA',
      paymentMethod: 'Cash',
      paymentStatus: 'Pending',
    ),
  ];
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
                Logo(),

                SizedBox(height: 35),

                // filter buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OrderType(
                      orderType: 'All',
                      isSelected: selectedOrderType == 'All',
                      onTap: () => setState(() => selectedOrderType = 'All'),
                    ),
                    OrderType(
                      orderType: 'Pending',
                      isSelected: selectedOrderType == 'Pending',
                      onTap: () =>
                          setState(() => selectedOrderType = 'Pending'),
                    ),
                    OrderType(
                      orderType: 'Confirmed',
                      isSelected: selectedOrderType == 'Confirmed',
                      onTap: () =>
                          setState(() => selectedOrderType = 'Confirmed'),
                    ),
                    OrderType(
                      orderType: 'Cancelled',
                      isSelected: selectedOrderType == 'Cancelled',
                      onTap: () =>
                          setState(() => selectedOrderType = 'Cancelled'),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                // orders list
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filterOrders(selectedOrderType, orders).length,
                  itemBuilder: (context, index) {
                    final filteredOrders = filterOrders(
                      selectedOrderType,
                      orders,
                    );
                    return Column(
                      children: [
                        OrderTile(
                          order: filteredOrders[index],
                        ),
                        SizedBox(height: 10),
                    ],);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// function to filter the orders based on the selected order type
List<Order> filterOrders(String selectedOrderType, List<Order> orders) {
  if (selectedOrderType == 'All') {
    return orders;
  } else {
    return orders
        .where(
          (order) => order.status.toString().toLowerCase().contains(
            selectedOrderType.toLowerCase(),
          ),
        )
        .toList();
  }
}
