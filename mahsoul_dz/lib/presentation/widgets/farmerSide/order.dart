import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/models/farmerSide/order.dart';
import 'package:mahsoul_dz/presentation/themes/colors.dart';
import 'package:mahsoul_dz/presentation/widgets/farmerSide/order_details.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_order_cubit.dart';
import 'package:mahsoul_dz/presentation/cubits/farmer/farmer_order_state.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final VoidCallback? onStatusChanged;
  const OrderTile({
    super.key, 
    required this.order,
    this.onStatusChanged,
  });

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer: ${order.customer.fullName}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                'Weight: ${order.weight} kg',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 5),

              Row(
                children: [
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.call, color: Colors.grey[600], size: 16),
                            SizedBox(width: 5),
                            Text(
                              'call',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),

                  // view order details button
                  GestureDetector(
                    onTap: () {
                      // show the order details
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: OrderDetailsWidget(order: order),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primaryColor),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      child: Text(
                        'View Details',
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,

            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 7.0),
                child: GestureDetector(
                  onTap: () {
                    _showStatusChangeDialog(context);
                  },
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 3,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            order.statusString,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                        ],
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

  void _showStatusChangeDialog(BuildContext context) {
    final cubit = context.read<FarmerOrderCubit>();
    final orderId = order.id;
    
    if (orderId == null || orderId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ID is missing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: BlocConsumer<FarmerOrderCubit, FarmerOrderState>(
          listener: (context, state) {
            if (state is FarmerOrderStatusUpdated) {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order status updated successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              if (onStatusChanged != null) {
                onStatusChanged!();
              }
            } else if (state is FarmerOrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is FarmerOrderLoading;
            
            return AlertDialog(
              title: Text(
                'Change Order Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Current status: ${order.statusString}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Select new status:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Status options based on current status
                  if (order.status == OrderStatus.pending) ...[
                    _buildStatusOption(
                      context,
                      'Confirmed',
                      'confirmed',
                      orderId,
                      isLoading,
                      Colors.green,
                    ),
                    _buildStatusOption(
                      context,
                      'Cancelled',
                      'cancelled',
                      orderId,
                      isLoading,
                      Colors.red,
                    ),
                  ] else if (order.status == OrderStatus.confirmed) ...[
                    _buildStatusOption(
                      context,
                      'Processing',
                      'processing',
                      orderId,
                      isLoading,
                      Colors.orange,
                    ),
                    _buildStatusOption(
                      context,
                      'Cancelled',
                      'cancelled',
                      orderId,
                      isLoading,
                      Colors.red,
                    ),
                  ] else if (order.status == OrderStatus.processing) ...[
                    _buildStatusOption(
                      context,
                      'Shipped',
                      'shipped',
                      orderId,
                      isLoading,
                      Colors.purple,
                    ),
                    _buildStatusOption(
                      context,
                      'Cancelled',
                      'cancelled',
                      orderId,
                      isLoading,
                      Colors.red,
                    ),
                  ] else if (order.status == OrderStatus.shipped) ...[
                    _buildStatusOption(
                      context,
                      'Delivered',
                      'delivered',
                      orderId,
                      isLoading,
                      Colors.blue,
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                  child: Text('Cancel'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    String label,
    String statusValue,
    String orderId,
    bool isLoading,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: isLoading ? null : () {
          context.read<FarmerOrderCubit>().updateOrderStatus(orderId, statusValue);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
