import 'package:mahsoul_dz/data/database/database_helper.dart';
import 'package:uuid/uuid.dart';

class SeedData {
  static Future<void> addDummyData() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;
    final uuid = const Uuid();
    final now = DateTime.now().millisecondsSinceEpoch;

    try {
      // Check if data already exists
      final existingUsers = await db.query('users');
      if (existingUsers.isNotEmpty) {
        return; // Data already seeded
      }

      // 1. Create dummy users
      final customerId = uuid.v4();
      final farmerId = uuid.v4();

      // Customer user
      await db.insert('users', {
        'id': customerId,
        'email': 'customer@test.com',
        'password_hash': '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // password: password
        'user_type': 'customer',
        'full_name': 'Test Customer',
        'phone_number': '+213 555 123 456',
        'created_at': now,
        'updated_at': now,
      });

      // Farmer user
      await db.insert('users', {
        'id': farmerId,
        'email': 'farmer@test.com',
        'password_hash': '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8', // password: password
        'user_type': 'farmer',
        'full_name': 'Adam Farmer',
        'phone_number': '+213 555 789 012',
        'created_at': now,
        'updated_at': now,
      });

      // 2. Create customer profile
      await db.insert('customer_profiles', {
        'id': uuid.v4(),
        'user_id': customerId,
        'city': 'Algiers',
        'postal_code': '16000',
        'total_orders': 5,
        'join_date': '2024-01-15',
      });

      // 3. Create farmer profile
      await db.insert('farmer_profiles', {
        'id': uuid.v4(),
        'user_id': farmerId,
        'farm_name': "Adam's Organic Farm",
        'farm_location': 'Blida, Algeria',
        'established_year': '1985',
        'is_verified': 1,
        'contact_number': '+213 555 789 012',
        'email_address': 'farm@example.com',
        'orders_completed': 152,
        'total_earnings': 98400.0,
        'currency': 'DA',
        'active_products': 12,
      });

      // 4. Create dummy products
      final product1Id = uuid.v4();
      final product2Id = uuid.v4();
      final product3Id = uuid.v4();
      final product4Id = uuid.v4();

      await db.insert('products', {
        'id': product1Id,
        'farmer_id': farmerId,
        'name': 'Fresh Tomatoes',
        'description': 'Organic fresh tomatoes from local farms',
        'category': 'Vegetables',
        'price': 250.0,
        'currency': 'DA',
        'origin': 'Blida, Algeria',
        'harvest_season': 'All Season',
        'is_organic': 1,
        'storage_instructions': 'Keep in cool place',
        'image_path': 'lib/assets/tomate.png',
        'rating': 4.4,
        'review_count': 156,
        'status': 'available',
        'created_at': now,
        'updated_at': now,
      });

      await db.insert('products', {
        'id': product2Id,
        'farmer_id': farmerId,
        'name': 'Fresh Apples',
        'description': 'Sweet and crunchy organic apples',
        'category': 'Fruits',
        'price': 350.0,
        'currency': 'DA',
        'origin': 'Blida, Algeria',
        'harvest_season': 'Fall',
        'is_organic': 1,
        'storage_instructions': 'Refrigerate for freshness',
        'image_path': 'lib/assets/IMAGE.png',
        'rating': 4.6,
        'review_count': 89,
        'status': 'available',
        'created_at': now,
        'updated_at': now,
      });

      await db.insert('products', {
        'id': product3Id,
        'farmer_id': farmerId,
        'name': 'Fresh Carrots',
        'description': 'Sweet and crunchy carrots',
        'category': 'Vegetables',
        'price': 180.0,
        'currency': 'DA',
        'origin': 'Blida, Algeria',
        'harvest_season': 'Spring',
        'is_organic': 0,
        'storage_instructions': 'Keep in refrigerator',
        'image_path': 'lib/assets/carrot.png',
        'rating': 4.2,
        'review_count': 134,
        'status': 'available',
        'created_at': now,
        'updated_at': now,
      });

      await db.insert('products', {
        'id': product4Id,
        'farmer_id': farmerId,
        'name': 'Wheat',
        'description': 'Fresh wheat grains',
        'category': 'Grains',
        'price': 200.0,
        'currency': 'DA',
        'origin': 'Blida, Algeria',
        'harvest_season': 'Summer',
        'is_organic': 1,
        'storage_instructions': 'Store in dry place',
        'image_path': 'lib/assets/wheat-sack.png',
        'rating': 4.5,
        'review_count': 67,
        'status': 'available',
        'created_at': now,
        'updated_at': now,
      });

      // 5. Create product weights
      await db.insert('product_weights', {
        'id': uuid.v4(),
        'product_id': product1Id,
        'weight_value': '500g',
        'is_available': 1,
      });
      await db.insert('product_weights', {
        'id': uuid.v4(),
        'product_id': product1Id,
        'weight_value': '1kg',
        'is_available': 1,
      });
      await db.insert('product_weights', {
        'id': uuid.v4(),
        'product_id': product2Id,
        'weight_value': '1kg',
        'is_available': 1,
      });
      await db.insert('product_weights', {
        'id': uuid.v4(),
        'product_id': product2Id,
        'weight_value': '2kg',
        'is_available': 1,
      });

      // 6. Create dummy delivery address
      await db.insert('delivery_addresses', {
        'id': uuid.v4(),
        'customer_id': customerId,
        'address': '123 Main Street',
        'city': 'Algiers',
        'postal_code': '16000',
        'is_default': 1,
        'created_at': now,
      });

      // 7. Create dummy orders
      final order1Id = uuid.v4();
      await db.insert('orders', {
        'id': order1Id,
        'customer_id': customerId,
        'farmer_id': farmerId,
        'total_price': 500.0,
        'total_weight': 2.0,
        'status': 'pending',
        'delivery_method': 'Home Delivery',
        'delivery_address': '123 Main Street, Algiers',
        'payment_method': 'Cash',
        'payment_status': 'pending',
        'order_date': now,
        'created_at': now,
        'updated_at': now,
      });

      await db.insert('order_items', {
        'id': uuid.v4(),
        'order_id': order1Id,
        'product_id': product1Id,
        'product_name': 'Fresh Tomatoes',
        'selected_weight': '1kg',
        'quantity': 2,
        'unit_price': 250.0,
        'total_price': 500.0,
      });

      // 8. Create dummy reviews
      await db.insert('reviews', {
        'id': uuid.v4(),
        'product_id': product1Id,
        'customer_id': customerId,
        'rating': 5.0,
        'comment': 'Excellent quality! Very fresh and tasty.',
        'created_at': now,
      });

      await db.insert('reviews', {
        'id': uuid.v4(),
        'product_id': product2Id,
        'customer_id': customerId,
        'rating': 4.5,
        'comment': 'Good apples, perfect for cooking.',
        'created_at': now,
      });
    } catch (e) {
      print('Error seeding data: $e');
    }
  }
}

