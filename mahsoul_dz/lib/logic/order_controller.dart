import 'package:mahsoul_dz/views/models/customerSide/order_model.dart';

class OrderController {
  // Mock data - in production, this would fetch from an API
  List<OrderModel> getAllOrders() {
    return [
      OrderModel(
        id: '1',
        productName: 'Organic Tomatoes',
        farmName: "Adam's Organic Farm",
        price: '1000 DA',
        status: 'Awaiting Confirmation',
        imagePath: 'lib/assets/tomate.png',
        orderDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      OrderModel(
        id: '2',
        productName: 'Organic Carrots',
        farmName: "Adam's Organic Farm",
        price: '1000 DA',
        status: 'On Going',
        imagePath: 'lib/assets/carrot.png',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      OrderModel(
        id: '3',
        productName: 'Fresh Apples',
        farmName: "Green Valley Farm",
        price: '800 DA',
        status: 'Delivered',
        imagePath: 'lib/assets/IMAGE.png',
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  // Filter orders by status
  List<OrderModel> getFilteredOrders(String filter) {
    final allOrders = getAllOrders();
    return allOrders.where((order) => order.matchesFilter(filter)).toList();
  }

  // Get order by ID
  OrderModel? getOrderById(String id) {
    try {
      return getAllOrders().firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  // Contact farmer via phone
  void callFarmer(OrderModel order) {
    // In production, this would initiate a phone call
    print('Calling ${order.farmName} for order ${order.id}');
  }

  // Contact farmer via WhatsApp
  void messageOnWhatsApp(OrderModel order) {
    // In production, this would open WhatsApp
    print('Opening WhatsApp for ${order.farmName} regarding order ${order.id}');
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    // In production, this would make an API call
    await Future.delayed(const Duration(seconds: 1));
    print('Order $orderId cancelled');
    return true;
  }

  // Reorder
  Future<bool> reorder(OrderModel order) async {
    // In production, this would add items back to cart
    await Future.delayed(const Duration(seconds: 1));
    print('Reordering ${order.productName}');
    return true;
  }
}
