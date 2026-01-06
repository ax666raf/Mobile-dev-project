import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/bar_graph.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/farmer_card.dart';
import 'package:mahsoul_dz/presentation/widgets/common/button.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/order.dart';
import 'package:mahsoul_dz/data/models/farmerSide/order.dart';
import 'package:mahsoul_dz/data/models/customerSide/customer.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/widgets/common/Logo.dart';
import 'package:mahsoul_dz/presentation/screens/FarmerSide/FarmerNavigation.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_dashboard_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_dashboard_state.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_order_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_order_state.dart';
import 'package:mahsoul_dz/presentation/cubits/notification/notification_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/notification/notification_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';

String deliveryMan = 'lib/assets/delivery-man.png';
String totalEarnings = 'lib/assets/earning.png';

class MainDashboard extends StatefulWidget {
  final List weeklySummary = [4.40, 20.0, 42.0, 10.5, 100.0, 88.0, 90.5];

  MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data and orders when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated && authState.userType == 'farmer') {
        context.read<FarmerDashboardCubit>().loadDashboardData();
        context.read<FarmerOrderCubit>().loadOrders();
      }
    });
  }

  // Convert backend order data to Order model
  Order _convertOrderFromBackend(
    Map<String, dynamic> orderData,
    AppLocalizations l10n,
  ) {
    // Backend now includes customer data in the response
    final customerId = orderData['customer_id'] as String? ?? '';
    String customerName = l10n.unknownCustomer;

    // Get customer data from response (backend now includes it)
    String? customerPhone;
    if (orderData.containsKey('customer')) {
      final customerData = orderData['customer'] as Map<String, dynamic>? ?? {};
      customerName =
          customerData['full_name'] as String? ??
          customerData['fullName'] as String? ??
          l10n.unknownCustomer;
      customerPhone = customerData['phone_number'] as String?;
    }

    final customer = Customer(
      id: customerId,
      fullName: customerName,
      phoneNumber: customerPhone,
    );

    return Order(
      id: orderData['id'] as String?,
      customer: customer,
      farmer: orderData['farmer_id'] as String? ?? '',
      weight:
          (orderData['total_weight'] as num?)?.toDouble() ??
          (orderData['weight'] as num?)?.toDouble() ??
          0.0,
      totalPrice:
          (orderData['total_price'] as num?)?.toDouble() ??
          (orderData['totalPrice'] as num?)?.toDouble() ??
          0.0,
      status: Order.statusFromString(
        orderData['status'] as String? ?? 'pending',
      ),
      deliveryMethod:
          orderData['delivery_method'] as String? ??
          orderData['deliveryMethod'] as String? ??
          l10n.homeDelivery,
      address:
          orderData['delivery_address'] as String? ??
          orderData['address'] as String? ??
          l10n.nA,
      paymentMethod:
          orderData['payment_method'] as String? ??
          orderData['paymentMethod'] as String? ??
          l10n.cash,
      paymentStatus:
          orderData['payment_status'] as String? ??
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
            body: Center(child: Text(l10n.pleaseLoginToViewDashboard)),
          );
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => FarmerDashboardCubit(
                DependencyInjection.farmerRepository,
                farmerId!,
              )..loadDashboardData(),
            ),
            BlocProvider(
              create: (context) => FarmerOrderCubit(
                DependencyInjection.farmerRepository,
                farmerId!,
              )..loadOrders(),
            ),
            BlocProvider(
              create: (context) =>
                  NotificationCubit(DependencyInjection.notificationRepository)
                    ..loadNotifications(farmerId!),
            ),
          ],
          child: BlocBuilder<FarmerDashboardCubit, FarmerDashboardState>(
            builder: (context, dashboardState) {
              return BlocBuilder<FarmerOrderCubit, FarmerOrderState>(
                builder: (context, orderState) {
                  // Get dashboard stats
                  int ordersToday = 0;
                  double totalEarningsValue = 0.0;
                  int pendingDeliveriesCount = 0;

                  if (dashboardState is FarmerDashboardLoaded) {
                    final dashboard = dashboardState.data;
                    ordersToday =
                        dashboard['total_orders'] as int? ??
                        dashboard['orders_today'] as int? ??
                        0;
                    totalEarningsValue =
                        (dashboard['total_earnings'] as num?)?.toDouble() ??
                        0.0;
                    pendingDeliveriesCount =
                        dashboard['pending_deliveries'] as int? ?? 0;
                  }

                  // Get recent orders and calculate stats from orders if needed
                  List<Order> recentOrders = [];
                  if (orderState is FarmerOrderLoaded) {
                    final ordersData = orderState.orders;

                    // Calculate total orders if not provided by dashboard
                    if (ordersToday == 0) {
                      ordersToday = ordersData.length;
                    }

                    // Calculate total earnings from orders if not provided by dashboard
                    if (totalEarningsValue == 0.0 && ordersData.isNotEmpty) {
                      totalEarningsValue = ordersData.fold<double>(0.0, (
                        sum,
                        order,
                      ) {
                        final orderData = order;
                        final price =
                            (orderData['total_price'] as num?)?.toDouble() ??
                            (orderData['totalPrice'] as num?)?.toDouble() ??
                            0.0;
                        return sum + price;
                      });
                    }

                    // Calculate pending deliveries from orders if not in dashboard
                    if (pendingDeliveriesCount == 0) {
                      pendingDeliveriesCount = ordersData.where((order) {
                        final status =
                            (order)['status']
                                as String? ??
                            '';
                        return status.toLowerCase() == 'pending';
                      }).length;
                    }

                    // Get recent orders (last 5)
                    recentOrders = ordersData.take(5).map((orderData) {
                      return _convertOrderFromBackend(
                        orderData,
                        l10n,
                      );
                    }).toList();
                  }

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
                              // Header with centered Logo and notification bell on top right
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Centered Logo
                                  Logo(),
                                  // Notification bell positioned on the right
                                  Positioned(
                                    right: 0,
                                    child:
                                        BlocBuilder<
                                          NotificationCubit,
                                          NotificationState
                                        >(
                                          builder: (context, state) {
                                            final unreadCount =
                                                state is NotificationLoaded
                                                ? state.unreadCount
                                                : 0;
                                            return Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    unreadCount > 0
                                                        ? Icons.notifications
                                                        : Icons
                                                              .notifications_outlined,
                                                    color: Colors.black,
                                                    size: 28,
                                                  ),
                                                  onPressed: () async {
                                                    // Mark all as read
                                                    await context
                                                        .read<
                                                          NotificationCubit
                                                        >()
                                                        .markAllAsRead(
                                                          farmerId!,
                                                        );

                                                    // Navigate to orders page using the global key
                                                    Farmernavigation
                                                        .navigationKey
                                                        .currentState
                                                        ?.changeTab(2);
                                                  },
                                                ),
                                                if (unreadCount > 0)
                                                  Positioned(
                                                    right: 8,
                                                    top: 8,
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                        4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      constraints:
                                                          BoxConstraints(
                                                            minWidth: 16,
                                                            minHeight: 16,
                                                          ),
                                                      child: Text(
                                                        unreadCount > 99
                                                            ? '99+'
                                                            : '$unreadCount',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          },
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),

                              Row(
                                children: [
                                  // hi icon
                                  Image.asset('lib/assets/hi.png'),

                                  SizedBox(width: 10),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.goodMorning,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        l10n.farmStatus,
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

                              // Top stats cards
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FarmerCard(
                                    image: 'lib/assets/groceryCart.png',
                                    title: l10n.ordersToday,
                                    value: ordersToday.toString(),
                                  ),

                                  FarmerCard(
                                    image: totalEarnings,
                                    title: l10n.totalEarnings,
                                    value:
                                        '${totalEarningsValue.toStringAsFixed(0)} DA',
                                  ),
                                ],
                              ),

                              SizedBox(height: 15),

                              // Pending Deliveries - clickable
                              GestureDetector(
                                onTap: () {
                                  // Navigate to Orders page filtered by Pending
                                  Navigator.pushNamed(
                                    context,
                                    '/OrdersPage',
                                    arguments: {'filter': 'Pending'},
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9.0,
                                      vertical: 7.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          deliveryMan,
                                          width: 40,
                                          height: 40,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            l10n.pendingDeliveries,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          pendingDeliveriesCount.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Action cards
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MyButton(
                                          backgroundColor: Colors.transparent,
                                          textColor: primaryColor,
                                          borderColor: primaryColor,
                                          icon: Icons.add,
                                          text: l10n.addProduct,
                                          onPressed: () {
                                            // Navigate to Products page with flag to open add dialog
                                            Navigator.pushNamed(
                                              context,
                                              '/ProductsPage',
                                              arguments: {
                                                'openAddDialog': true,
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: MyButton(
                                          backgroundColor: Colors.transparent,
                                          textColor: primaryColor,
                                          borderColor: primaryColor,
                                          icon: Icons.store,
                                          text: l10n.myProducts,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/ProductsPage',
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MyButton(
                                          backgroundColor: Colors.transparent,
                                          textColor: primaryColor,
                                          borderColor: primaryColor,
                                          icon: Icons.shopping_bag,
                                          text: l10n.viewOrders,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/OrdersPage',
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 20),

                              // Recent orders
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.recentOrders,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  if (orderState is FarmerOrderLoading)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  else if (orderState is FarmerOrderError)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          '${l10n.errorLoadingOrders}: ${orderState.message}',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    )
                                  else if (recentOrders.isEmpty)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          l10n.noRecentOrders,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    ...recentOrders
                                        .expand(
                                          (order) => [
                                            OrderTile(order: order),
                                            SizedBox(height: 10),
                                          ],
                                        )
                                        .toList()
                                      ..removeLast(),

                                  SizedBox(height: 30),
                                  Text(
                                    l10n.weeklySummary,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Center(
                                    child: SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: MyBarGraph(
                                        weeklySummary: widget.weeklySummary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
