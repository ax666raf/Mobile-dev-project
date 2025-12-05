import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/models/customerSide/customer.dart';
import 'package:mahsoul_dz/data/models/farmerSide/order.dart';
import 'package:mahsoul_dz/presentation/widgets/common/Logo.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/order.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/order_type.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_order_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_order_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // variable the filter
  String selectedOrderType = 'All';
  
  @override
  void initState() {
    super.initState();
    // Check if filter argument was passed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['filter'] != null) {
        setState(() {
          selectedOrderType = args['filter'] as String;
        });
      }
    });
  }

  // Convert backend order data to Order model
  Order _convertOrderFromBackend(Map<String, dynamic> orderData, AppLocalizations l10n) {
    // Backend includes customer data in the response
    final customerId = orderData['customer_id'] as String? ?? '';
    String customerName = l10n.unknownCustomer;
    
    // Get customer data from response
    if (orderData.containsKey('customer')) {
      final customerData = orderData['customer'] as Map<String, dynamic>? ?? {};
      customerName = customerData['full_name'] as String? ?? 
                    customerData['fullName'] as String? ?? 
                    'Customer';
    }
    
    final customer = Customer(
      id: customerId,
      fullName: customerName,
    );

    return Order(
      id: orderData['id'] as String?,
      customer: customer,
      farmer: orderData['farmer_id'] as String? ?? '',
      weight: (orderData['total_weight'] as num?)?.toDouble() ?? 
              (orderData['weight'] as num?)?.toDouble() ?? 0.0,
      totalPrice: (orderData['total_price'] as num?)?.toDouble() ?? 
                  (orderData['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: Order.statusFromString(orderData['status'] as String? ?? 'pending'),
      deliveryMethod: orderData['delivery_method'] as String? ?? 
                     orderData['deliveryMethod'] as String? ?? 
                     l10n.homeDelivery,
      address: orderData['delivery_address'] as String? ?? 
               orderData['address'] as String? ?? 
               l10n.nA,
      paymentMethod: orderData['payment_method'] as String? ?? 
                    orderData['paymentMethod'] as String? ?? 
                    l10n.cash,
      paymentStatus: orderData['payment_status'] as String? ?? 
                    orderData['paymentStatus'] as String? ?? 
                    l10n.pending,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        String? farmerId;
        if (authState is AuthAuthenticated && authState.userType == 'farmer') {
          farmerId = authState.userId;
        }
        
        if (farmerId == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text(l10n.pleaseLoginToViewOrders),
            ),
          );
        }
        
        return BlocProvider(
          create: (context) => FarmerOrderCubit(DependencyInjection.farmerRepository, farmerId!)..loadOrders(),
          child: Scaffold(
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
                            onTap: () {
                              setState(() => selectedOrderType = 'All');
                              context.read<FarmerOrderCubit>().loadOrders();
                            },
                          ),
                          OrderType(
                            orderType: 'Pending',
                            isSelected: selectedOrderType == 'Pending',
                            onTap: () {
                              setState(() => selectedOrderType = 'Pending');
                              context.read<FarmerOrderCubit>().loadOrdersByStatus('pending');
                            },
                          ),
                          OrderType(
                            orderType: 'Confirmed',
                            isSelected: selectedOrderType == 'Confirmed',
                            onTap: () {
                              setState(() => selectedOrderType = 'Confirmed');
                              context.read<FarmerOrderCubit>().loadOrdersByStatus('confirmed');
                            },
                          ),
                          OrderType(
                            orderType: 'Cancelled',
                            isSelected: selectedOrderType == 'Cancelled',
                            onTap: () {
                              setState(() => selectedOrderType = 'Cancelled');
                              context.read<FarmerOrderCubit>().loadOrdersByStatus('cancelled');
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      // orders list
                      BlocBuilder<FarmerOrderCubit, FarmerOrderState>(
                        builder: (context, state) {
                          if (state is FarmerOrderLoading) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (state is FarmerOrderError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.message,
                                    style: TextStyle(color: Colors.red.shade600),
                                  ),
                                ],
                              ),
                            );
                          }

                          if (state is FarmerOrderLoaded) {
                            final ordersData = state.orders;
                            
                            // Convert to Order model
                            List<Order> orders = ordersData.map((o) {
                              return _convertOrderFromBackend(o as Map<String, dynamic>, l10n);
                            }).toList();
                            
                            // Filter by selected order type (if needed, backend already filters)
                            final filteredOrders = filterOrders(selectedOrderType, orders);
                            
                            if (filteredOrders.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40.0),
                                  child: Text(l10n.noOrdersFound),
                                ),
                              );
                            }
                            
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredOrders.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    OrderTile(
                                      order: filteredOrders[index],
                                      onStatusChanged: () {
                                        // Reload orders after status change
                                        if (selectedOrderType == 'All') {
                                          context.read<FarmerOrderCubit>().loadOrders();
                                        } else {
                                          context.read<FarmerOrderCubit>().loadOrdersByStatus(selectedOrderType.toLowerCase());
                                        }
                                      },
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                );
                              },
                            );
                          }

                          return Center(child: Text(l10n.noOrdersAvailable));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
          (order) => order.statusString.toLowerCase() == selectedOrderType.toLowerCase(),
        )
        .toList();
  }
}
