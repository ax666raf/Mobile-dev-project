import 'package:flutter/material.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/views/widgets/common/page_with_nav.dart';
import 'package:mahsoul_dz/logic/order_controller.dart';
import 'package:mahsoul_dz/views/models/customerSide/order_model.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/order_filter_tabs.dart';
import 'package:mahsoul_dz/views/widgets/customerSide/order_card.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  // Controller instance
  final OrderController _controller = OrderController();
  
  // UI State
  String _selectedFilter = '';
  List<OrderModel> _displayedOrders = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _selectedFilter = l10n.allOrders;
        _loadOrders();
      });
    });
  }

  /// Load orders from controller based on selected filter
  void _loadOrders() {
    setState(() {
      _displayedOrders = _controller.getFilteredOrders(_selectedFilter);
    });
  }

  /// Handle filter selection
  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
      _loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWithNav(
      currentIndex: 2, // Profile tab
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Filter Tabs
              _buildFilterTabs(),

              // Orders List
              Expanded(
                child: _buildOrdersList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header with back button and title
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

  /// Orders list with cards
  Widget _buildOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _displayedOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(_displayedOrders[index]);
      },
    );
  }

  /// Individual order card
  Widget _buildOrderCard(OrderModel order) {
    return OrderCard(
      order: order,
      onCall: () => _controller.callFarmer(order),
      onWhatsApp: () => _controller.messageOnWhatsApp(order),
    );
  }
}
