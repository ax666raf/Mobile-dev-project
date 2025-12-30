import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/l10n/app_localizations.dart';
import 'package:mahsoul_dz/presentation/screens/customerSide/customer_side_screens.dart';
import 'package:mahsoul_dz/presentation/widgets/common/page_with_nav.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/cart_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/cart_state.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/customer_profile_state.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/delivery_address_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/delivery_address_state.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/order_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/customer/order_state.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/auth/auth_state.dart';
import 'package:mahsoul_dz/core/di/dependency_injection.dart';

/// Order Proceed Page - Shows customer information and order summary before confirmation
class OrderConfirmationPage extends StatelessWidget {
  final String customerId;

  const OrderConfirmationPage({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CartCubit(DependencyInjection.cartRepository, customerId)
                ..loadCart(),
        ),
        BlocProvider(
          create: (context) => CustomerProfileCubit(
            DependencyInjection.profileRepository,
            customerId,
          )..loadProfile(),
        ),
        BlocProvider(
          create: (context) => DeliveryAddressCubit(
            DependencyInjection.deliveryAddressRepository,
            customerId,
          )..loadAddresses(),
        ),
        BlocProvider(
          create: (context) =>
              OrderCubit(DependencyInjection.orderRepository, customerId),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            l10n.checkout,
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            if (cartState is CartLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (cartState is CartError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      cartState.message,
                      style: TextStyle(color: Colors.red.shade600),
                    ),
                  ],
                ),
              );
            }

            if (cartState is CartLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer Information Card
                    _buildCustomerInfoCard(context, l10n),
                    const SizedBox(height: 20),

                    // Order Summary
                    Text(
                      l10n.orderSummary,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Cart Items
                    ...cartState.items.map((item) {
                      final product = item['product'] as Map<String, dynamic>?;
                      final productName = product?['name'] as String? ?? '';
                      final farmName =
                          product?['farmer']?['farm_name'] as String? ?? '';
                      final quantity = item['quantity'] as int? ?? 1;
                      final weight = item['selected_weight'] as String? ?? '';
                      final price =
                          (product?['price'] as num?)?.toDouble() ?? 0.0;
                      final imagePath =
                          product?['image_path'] as String? ??
                          'lib/assets/carrot.png';
                      final totalPrice = price * quantity;

                      return _buildOrderItem(
                        title: productName,
                        subtitle: farmName,
                        quantity: '$quantity x $weight',
                        price: '${totalPrice.toStringAsFixed(2)} ${l10n.da}',
                        imagePath: imagePath,
                      );
                    }),

                    const SizedBox(height: 20),

                    // Totals
                    _buildTotalSection(l10n, cartState.total),

                    const SizedBox(height: 30),

                    // Confirm Order Button
                    BlocListener<OrderCubit, OrderState>(
                      listener: (context, state) {
                        if (state is OrderPlaced) {
                          // Order placed successfully - clear cart and show confirmation
                          context.read<CartCubit>().clearCart();
                          Navigator.pop(context); // Close checkout page
                          OrderConfirmationDialog.show(context);
                        } else if (state is OrderError) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<OrderCubit, OrderState>(
                        builder: (context, orderState) {
                          final isLoading = orderState is OrderLoading;

                          return SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      // Get delivery address and place order
                                      final addressCubit = context
                                          .read<DeliveryAddressCubit>();
                                      final addressState = addressCubit.state;

                                      String deliveryAddress = '';
                                      if (addressState
                                          is DeliveryAddressLoaded) {
                                        final defaultAddress = addressState
                                            .addresses
                                            .firstWhere(
                                              (addr) =>
                                                  addr['is_default'] == true ||
                                                  addr['is_default'] == 1,
                                              orElse: () =>
                                                  addressState
                                                      .addresses
                                                      .isNotEmpty
                                                  ? addressState.addresses.first
                                                  : {},
                                            );

                                        if (defaultAddress.isNotEmpty) {
                                          final address =
                                              defaultAddress['address']
                                                  as String? ??
                                              '';
                                          final city =
                                              defaultAddress['city']
                                                  as String? ??
                                              '';
                                          final postalCode =
                                              defaultAddress['postal_code']
                                                  as String? ??
                                              '';
                                          deliveryAddress =
                                              '$address, $city${postalCode.isNotEmpty ? ', $postalCode' : ''}';
                                        }
                                      }

                                      if (deliveryAddress.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              l10n.pleaseAddDeliveryAddress,
                                            ),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                        return;
                                      }

                                      // Place order
                                      final orderCubit = context
                                          .read<OrderCubit>();
                                      orderCubit.placeOrder(
                                        deliveryAddress,
                                        l10n.homeDelivery, // Default delivery method
                                        paymentMethod:
                                            l10n.cash, // Default payment method
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      l10n.confirmOrder,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text(l10n.noProductsFound));
          },
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(BuildContext context, AppLocalizations l10n) {
    return BlocBuilder<CustomerProfileCubit, CustomerProfileState>(
      builder: (context, profileState) {
        return BlocBuilder<DeliveryAddressCubit, DeliveryAddressState>(
          builder: (context, addressState) {
            String fullName = l10n.addNotes;
            String phoneNumber = '';
            String deliveryAddress = l10n.addNotes;

            if (profileState is CustomerProfileLoaded) {
              final profile = profileState.profile;
              fullName = profile['full_name'] as String? ?? '';
              phoneNumber = profile['phone_number'] as String? ?? '';
            }

            if (addressState is DeliveryAddressLoaded) {
              final defaultAddress = addressState.addresses.firstWhere(
                (addr) => addr['is_default'] == true || addr['is_default'] == 1,
                orElse: () => addressState.addresses.isNotEmpty
                    ? addressState.addresses.first
                    : {},
              );

              if (defaultAddress.isNotEmpty) {
                final address = defaultAddress['address'] as String? ?? '';
                final city = defaultAddress['city'] as String? ?? '';
                final postalCode =
                    defaultAddress['postal_code'] as String? ?? '';
                deliveryAddress =
                    '$address\n$city${postalCode.isNotEmpty ? ', $postalCode' : ''}';
              }
            }

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.personalInfo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow(
                    context,
                    Icons.person_outline,
                    l10n.fullName,
                    fullName,
                    l10n,
                    onEdit: () {
                      // Open edit profile dialog
                      final profileCubit = context.read<CustomerProfileCubit>();
                      final profileState = profileCubit.state;
                      if (profileState is CustomerProfileLoaded) {
                        EditProfileDialog.show(context, profileState.profile);
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildInfoRow(
                    context,
                    Icons.phone_outlined,
                    l10n.phoneNumber,
                    phoneNumber,
                    l10n,
                    onEdit: () {
                      // Open edit profile dialog
                      final profileCubit = context.read<CustomerProfileCubit>();
                      final profileState = profileCubit.state;
                      if (profileState is CustomerProfileLoaded) {
                        EditProfileDialog.show(context, profileState.profile);
                      }
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildInfoRow(
                    context,
                    Icons.location_on_outlined,
                    l10n.deliveryAddress,
                    deliveryAddress,
                    l10n,
                    onEdit: () {
                      // Open delivery address dialog
                      DeliveryAddressDialog.show(context);
                    },
                  ),
                  const SizedBox(height: 18),
                  _buildInfoRow(
                    context,
                    Icons.note_outlined,
                    l10n.orderNotes,
                    l10n.addNotes,
                    l10n,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    AppLocalizations l10n, {
    VoidCallback? onEdit,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF4CAF50), size: 22),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF757575),
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF1A1A1A),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (onEdit != null)
          GestureDetector(
            onTap: onEdit,
            child: Text(
              l10n.edit,
              style: TextStyle(
                color: const Color(0xFF4CAF50),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderItem({
    required String title,
    required String subtitle,
    required String quantity,
    required String price,
    String? imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Placeholder for image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: imagePath != null
                  ? Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.shopping_bag,
                          color: Colors.grey.shade400,
                          size: 30,
                        );
                      },
                    )
                  : Icon(
                      Icons.shopping_bag,
                      color: Colors.grey.shade400,
                      size: 30,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  quantity,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(AppLocalizations l10n, double total) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _TotalRow(l10n.subtotal, '${total.toStringAsFixed(2)} ${l10n.da}'),
          SizedBox(height: 12),
          _TotalRow(l10n.deliveryFee, l10n.free, isFree: true),
          SizedBox(height: 12),
          Divider(thickness: 1),
          SizedBox(height: 12),
          _TotalRow(
            l10n.total,
            '${total.toStringAsFixed(2)} ${l10n.da}',
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isFree;

  const _TotalRow(
    this.label,
    this.value, {
    this.isBold = false,
    this.isFree = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isFree ? Colors.green : Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
