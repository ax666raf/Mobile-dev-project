import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/data/repositories/auth_repository.dart';
import 'package:mahsoul_dz/data/repositories/product_repository.dart';
import 'package:mahsoul_dz/data/repositories/cart_repository.dart';
import 'package:mahsoul_dz/data/repositories/order_repository.dart';
import 'package:mahsoul_dz/data/repositories/profile_repository.dart';
import 'package:mahsoul_dz/data/repositories/delivery_address_repository.dart';
import 'package:mahsoul_dz/data/repositories/farmer_repository.dart';

class DependencyInjection {
  // Singleton ApiClient
  static final ApiClient _apiClient = ApiClient();

  // Repositories
  static final AuthRepository authRepository = AuthRepository(_apiClient);
  static final ProductRepository productRepository = ProductRepository(_apiClient);
  static final CartRepository cartRepository = CartRepository(_apiClient);
  static final OrderRepository orderRepository = OrderRepository(_apiClient);
  static final ProfileRepository profileRepository = ProfileRepository(_apiClient);
  static final DeliveryAddressRepository deliveryAddressRepository = DeliveryAddressRepository(_apiClient);
  static final FarmerRepository farmerRepository = FarmerRepository(_apiClient);
}

