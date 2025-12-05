import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/widgets/common/page_with_nav.dart';
import 'package:mahsoul_dz/data/models/customerSide/order_model.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/order_filter_tabs.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/order_card.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/order_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/order_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';

class MyOrdersPage extends StatefulWidget {
  final String customerId;
  
  const MyOrdersPage({super.key, required this.customerId});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  // UI State
  String _selectedFilter = '';

  @override
  void initState() {
    super.initState();
  }

  /// Handle filter selection
  void _onFilterSelected(String filter) {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _selectedFilter = filter;
    });
    final orderCubit = context.read<OrderCubit>();
    
    // Always load all orders - filtering will be done in the UI
    // This ensures proper filtering regardless of language (Arabic/English/French)
    // The UI filter compares localized strings with backend status values
    orderCubit.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocProvider(
      create: (context) {
        final cubit = OrderCubit(DependencyInjection.orderRepository, widget.customerId);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final l10n = AppLocalizations.of(context)!;
          setState(() {
            _selectedFilter = l10n.allOrders;
          });
          cubit.loadOrders();
        });
        return cubit;
      },
      child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),

                _buildFilterTabs(),

                Expanded(
                  child: BlocBuilder<OrderCubit, OrderState>(
                    builder: (context, state) {
                      if (state is OrderLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (state is OrderError) {
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

                      if (state is OrderLoaded) {
                        final orders = state.orders;
                        
                             final orderModels = orders.map((o) {
                               final orderData = o;
                          final orderItems = orderData['items'] as List<dynamic>? ?? [];
                          final firstItem = orderItems.isNotEmpty ? orderItems.first as Map<String, dynamic>? : null;
                          
                          return OrderModel(
                            id: orderData['id'] as String? ?? '',
                            productName: firstItem?['product_name'] as String? ?? '',
                            farmName: orderData['farmer']?['farm_name'] as String? ?? '',
                            price: (orderData['total_price'] as num?)?.toString() ?? '0',
                            status: orderData['status'] as String? ?? '',
                            imagePath: firstItem?['product']?['image_path'] as String? ?? 'lib/assets/tomate.png',
                            orderDate: orderData['order_date'] != null
                                ? DateTime.fromMillisecondsSinceEpoch(orderData['order_date'] as int)
                                : DateTime.now(),
                          );
                        }).toList();

                        final l10n = AppLocalizations.of(context)!;
                        final filteredOrders = orderModels.where((order) {
                          // If "All Orders" is selected, show all
                          if (_selectedFilter == l10n.allOrders) return true;
                          
                          // Map localized filter to backend status values
                          final orderStatus = order.status.toLowerCase();
                          
                          if (_selectedFilter == l10n.ongoing) {
                            // "Ongoing" includes: pending, ongoing, processing, shipped, awaiting confirmation, confirmed
                            return orderStatus == 'pending' ||
                                   orderStatus == 'ongoing' ||
                                   orderStatus == 'on going' ||
                                   orderStatus == 'processing' ||
                                   orderStatus == 'shipped' ||
                                   orderStatus == 'awaiting confirmation' ||
                                   orderStatus == 'confirmed';
                          } else if (_selectedFilter == l10n.delivered) {
                            // "Delivered" only matches delivered status
                            return orderStatus == 'delivered';
                          }
                          
                          // Default: show all if filter doesn't match (shouldn't happen, but safe fallback)
                          return true;
                        }).toList();

                        return ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: filteredOrders.length,
                          itemBuilder: (context, index) {
                            return _buildOrderCard(filteredOrders[index]);
                          },
                        );
                      }

                      return Center(child: Text(l10n.noProductsFound));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildHeader() {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.myOrders,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  /// Filter tabs for order status
  Widget _buildFilterTabs() {
    final l10n = AppLocalizations.of(context)!;
    final filters = [l10n.allOrders, l10n.ongoing, l10n.delivered];
    
    return OrderFilterTabs(
      filters: filters,
      selectedFilter: _selectedFilter,
      onFilterSelected: _onFilterSelected,
    );
  }


  /// Individual order card
  Widget _buildOrderCard(OrderModel order) {
    return OrderCard(
      order: order,
      onCall: () {
        // TODO: Implement call with Cubit will be implemented later
      },
      onWhatsApp: () {
        // TODO: Implement WhatsApp with Cubit will be implemented later
      },
    );
  }
}
