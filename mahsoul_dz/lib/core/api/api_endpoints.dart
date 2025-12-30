class ApiEndpoints {
  // Auth endpoints
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String logout = '/auth/logout';
  static const String currentUser = '/auth/me';

  // Product endpoints
  static const String products = '/products';
  static String productById(String id) => '/products/$id';
  static String productsByCategory(String category) =>
      '/products/category/$category';
  static String productSearch = '/products/search';
  static String productReviews(String productId) =>
      '/products/$productId/reviews';

  // Cart endpoints
  static const String cart = '/cart';
  static String cartItem(String itemId) => '/cart/$itemId';
  static const String cartClear = '/cart/clear';

  // Order endpoints
  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';
  static String updateOrderStatus(String orderId) => '/orders/$orderId/status';
  static String cancelOrder(String orderId) => '/orders/$orderId/cancel';

  // Profile endpoints
  static const String profile = '/profile';
  static const String profileImage = '/profile/image';

  // Delivery address endpoints
  static const String addresses = '/addresses';
  static String addressById(String id) => '/addresses/$id';
  static String setDefaultAddress(String addressId) =>
      '/addresses/$addressId/set-default';

  // Farmer endpoints
  static const String farmerProducts = '/farmer/products';
  static String farmerProductById(String id) => '/farmer/products/$id';
  static const String farmerOrders = '/farmer/orders';
  static String farmerOrderStatus(String orderId) =>
      '/farmer/orders/$orderId/status';
  static const String farmerDashboard = '/farmer/dashboard';

  // Upload endpoints
  static const String uploadImage = '/upload/image';

  // notif endpoints
  static const String notifications = '/notifications';

  // Favorites endpoints
  static const String favorites = '/favorites';
  static String customerFavorites(String customerId) => '/favorites/customer/$customerId';
  static String customerFavoriteIds(String customerId) => '/favorites/customer/$customerId/ids';
  static String favoriteById(String favoriteId) => '/favorites/$favoriteId';
  static String removeFavoriteByProduct(String customerId, String productId) => 
      '/favorites/customer/$customerId/product/$productId';
  static String checkFavorite(String customerId, String productId) => 
      '/favorites/customer/$customerId/product/$productId/check';
}
