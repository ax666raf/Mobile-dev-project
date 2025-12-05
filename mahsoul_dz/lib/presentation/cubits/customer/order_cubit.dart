import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/repositories/order_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;
  final String customerId;

  OrderCubit(this._orderRepository, this.customerId) : super(OrderInitial());

  // Load all orders for customer
  Future<void> loadOrders() async {
    emit(OrderLoading());

    try {
      final orders = await _orderRepository.getCustomerOrders(customerId);
      emit(OrderLoaded(orders.cast<Map<String, dynamic>>()));
    } on ApiException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('Failed to load orders: ${e.toString()}'));
    }
  }

  // Load orders by status
  Future<void> loadOrdersByStatus(String status) async {
    emit(OrderLoading());

    try {
      final orders = await _orderRepository.getCustomerOrders(customerId);
      final filteredOrders = orders.where((order) => 
        (order as Map<String, dynamic>)['status'] == status
      ).toList();
      emit(OrderLoaded(filteredOrders.cast<Map<String, dynamic>>()));
    } on ApiException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('Failed to load orders: ${e.toString()}'));
    }
  }

  // Place order from cart
  // Note: deliveryAddress should be the full address string
  Future<void> placeOrder(String deliveryAddress, String deliveryMethod, {String? paymentMethod}) async {
    emit(OrderLoading());

    try {
      final response = await _orderRepository.createOrder(
        customerId: customerId,
        deliveryAddress: deliveryAddress,
        deliveryMethod: deliveryMethod,
        paymentMethod: paymentMethod,
      );
      
      final order = response['order'] as Map<String, dynamic>;
      emit(OrderPlaced(order));
      loadOrders(); // Reload orders list
    } on ApiException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('Failed to place order: ${e.toString()}'));
    }
  }

  // Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
      await _orderRepository.cancelOrder(orderId);
      loadOrders(); // Reload orders
    } on ApiException catch (e) {
      emit(OrderError(e.message));
    } catch (e) {
      emit(OrderError('Failed to cancel order: ${e.toString()}'));
    }
  }
}



