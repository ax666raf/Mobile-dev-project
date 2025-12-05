import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/farmer_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'farmer_order_state.dart';

class FarmerOrderCubit extends Cubit<FarmerOrderState> {
  final FarmerRepository _farmerRepository;
  final String farmerId;

  FarmerOrderCubit(this._farmerRepository, this.farmerId) : super(FarmerOrderInitial());

  // Load all orders for farmer
  Future<void> loadOrders() async {
    emit(FarmerOrderLoading());

    try {
      final orders = await _farmerRepository.getFarmerOrders(farmerId);
      emit(FarmerOrderLoaded(orders.cast<Map<String, dynamic>>()));
    } on ApiException catch (e) {
      emit(FarmerOrderError(e.message));
    } catch (e) {
      emit(FarmerOrderError('Failed to load orders: ${e.toString()}'));
    }
  }

  // Load orders by status
  Future<void> loadOrdersByStatus(String status) async {
    emit(FarmerOrderLoading());

    try {
      final orders = await _farmerRepository.getFarmerOrders(farmerId);
      final filteredOrders = orders.where((order) => 
        (order as Map<String, dynamic>)['status'] == status
      ).toList();
      emit(FarmerOrderLoaded(filteredOrders.cast<Map<String, dynamic>>()));
    } on ApiException catch (e) {
      emit(FarmerOrderError(e.message));
    } catch (e) {
      emit(FarmerOrderError('Failed to load orders: ${e.toString()}'));
    }
  }

  // Get order details with items
  // Note: Using OrderRepository's getOrderById since it includes all details
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      // We need to import OrderRepository or use a shared method
      // For now, we'll get it from the orders list
      final orders = await _farmerRepository.getFarmerOrders(farmerId);
      final order = orders.firstWhere(
        (o) => (o as Map<String, dynamic>)['id'] == orderId,
        orElse: () => null,
      );
      return order as Map<String, dynamic>?;
    } on ApiException {
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await _farmerRepository.updateOrderStatus(
        orderId: orderId,
        status: status,
      );
      final order = response['order'] as Map<String, dynamic>;
      emit(FarmerOrderStatusUpdated(order));
      loadOrders(); // Reload orders list
    } on ApiException catch (e) {
      emit(FarmerOrderError(e.message));
    } catch (e) {
      emit(FarmerOrderError('Failed to update order status: ${e.toString()}'));
    }
  }

  // Mark as delivered
  Future<void> markAsDelivered(String orderId) async {
    await updateOrderStatus(orderId, 'delivered');
  }

  // Mark as cancelled
  Future<void> markAsCancelled(String orderId) async {
    await updateOrderStatus(orderId, 'cancelled');
  }
}



