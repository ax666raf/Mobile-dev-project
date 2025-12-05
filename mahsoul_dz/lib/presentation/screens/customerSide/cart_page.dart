import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/cart-proceed.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/market.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/cart_product_card.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/order_summary_card.dart';
import 'package:mahsoul_dz/presentation/widgets/customerSide/cart_buttons.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/cart_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/cart_state.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/main_navigation.dart';

class MahsoulOrderScreen extends StatefulWidget {
  final String customerId;
  
  const MahsoulOrderScreen({super.key, required this.customerId});

  @override
  State<MahsoulOrderScreen> createState() => _MahsoulOrderScreenState();
}

class _MahsoulOrderScreenState extends State<MahsoulOrderScreen> {
  @override
  void initState() {
    super.initState();
    // Load cart when screen opens (only if not already loaded from product detail)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final cartCubit = context.read<CartCubit>();
        final currentState = cartCubit.state;
        // Only load if cart is in initial state (not already loaded from adding item)
        if (currentState is CartInitial) {
          cartCubit.loadCart();
        }
      } catch (e) {
        // CartCubit not found, will be created in build method
      }
    });
  }

  Widget _buildCartContent(BuildContext context, AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.appName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.eco,
              color: Colors.green,
              size: 20,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // Check if we can pop (if accessed from a route)
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // If accessed from MainNavigation tab, navigate to Home tab
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigation()),
              );
            }
          },
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is CartError) {
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

          if (state is CartLoaded) {
            final cartItems = state.items;
            final total = state.total;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Products List - Each in its own card
                  ...List.generate(cartItems.length, (index) {
                    final item = cartItems[index];
                    final product = item['product'] as Map<String, dynamic>?;
                    final productName = product?['name'] as String? ?? l10n.unknownProduct;
                    // Try to get farm name from product's farmer data, or use a default
                    final farmerData = product?['farmer'] as Map<String, dynamic>?;
                    final farmName = farmerData?['farm_name'] as String? ?? 
                                    product?['farmer_name'] as String? ?? 
                                    l10n.unknownFarm;
                    // Use unit_price from backend (weight-adjusted price) or fallback to product price
                    final unitPrice = (item['unit_price'] as num?)?.toDouble() ?? 
                                     (product?['price'] as num?)?.toDouble() ?? 0.0;
                    final quantity = (item['quantity'] as int?) ?? 1;
                    final selectedWeight = item['selected_weight'] as String? ?? '';
                    final subtotal = (item['subtotal'] as num?)?.toDouble() ?? (unitPrice * quantity);
                    final imagePath = product?['image_path'] as String? ?? 'lib/assets/tomate.png';
                    final itemId = item['id'] as String? ?? '';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CartProductCard(
                        title: productName,
                        farm: farmName,
                        price: subtotal, // Use subtotal (unit_price * quantity) for display
                        unitPrice: unitPrice, // Store unit price for reference
                        selectedWeight: selectedWeight,
                        quantity: quantity,
                        imagePath: imagePath,
                        onRemove: () {
                          context.read<CartCubit>().removeFromCart(itemId);
                        },
                      ),
                    );
                  }),

                  const SizedBox(height: 8),

                  // Order Summary Card - Separate card
                  OrderSummaryCard(
                    subtotal: total,
                    total: total,
                  ),

                  const SizedBox(height: 20),

                  // Payment in delivery
                  Center(
                    child: Text(
                      l10n.paymentInDelivery,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Buttons Section
                  CartButtons(
                    isCartEmpty: cartItems.isEmpty,
                    onProceed: () {
                      // Get customerId from AuthCubit
                      final authState = context.read<AuthCubit>().state;
                      if (authState is AuthAuthenticated && authState.userType == 'customer') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderConfirmationPage(customerId: authState.userId),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.pleaseLoginToProceed)),
                        );
                      }
                    },
                    onContinueShopping: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MarketWithNav()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return Center(child: Text(l10n.noProductsFound));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Validate customerId
    if (widget.customerId.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                l10n.pleaseLoginToViewCart,
                style: TextStyle(color: Colors.red.shade600),
              ),
            ],
          ),
        ),
      );
    }
    
    // Check if CartCubit already exists in the widget tree (passed from product detail)
    try {
      context.read<CartCubit>();
      // CartCubit exists, use it directly
      return _buildCartContent(context, l10n);
    } catch (e) {
      // CartCubit doesn't exist, create new one (when accessed from MainNavigation tab)
      return BlocProvider(
        create: (context) => CartCubit(DependencyInjection.cartRepository, widget.customerId)..loadCart(),
        child: _buildCartContent(context, l10n),
      );
    }
  }
}
