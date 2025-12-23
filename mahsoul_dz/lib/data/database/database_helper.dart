import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern - only one instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mahsoul.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create all tables
  Future<void> _onCreate(Database db, int version) async {
    // 1. Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        user_type TEXT NOT NULL,
        full_name TEXT,
        phone_number TEXT,
        profile_image_path TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // 2. Customer profiles table
    await db.execute('''
      CREATE TABLE customer_profiles (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        city TEXT,
        postal_code TEXT,
        total_orders INTEGER DEFAULT 0,
        join_date TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // 3. Farmer profiles table
    await db.execute('''
      CREATE TABLE farmer_profiles (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        farm_name TEXT NOT NULL,
        farm_location TEXT,
        established_year TEXT,
        is_verified INTEGER DEFAULT 0,
        contact_number TEXT,
        email_address TEXT,
        orders_completed INTEGER DEFAULT 0,
        total_earnings REAL DEFAULT 0.0,
        currency TEXT DEFAULT 'DA',
        active_products INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // 4. Delivery addresses table
    await db.execute('''
      CREATE TABLE delivery_addresses (
        id TEXT PRIMARY KEY,
        customer_id TEXT NOT NULL,
        address TEXT NOT NULL,
        city TEXT NOT NULL,
        postal_code TEXT,
        is_default INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // 5. Products table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        farmer_id TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        currency TEXT DEFAULT 'DA',
        origin TEXT,
        harvest_season TEXT,
        is_organic INTEGER DEFAULT 0,
        storage_instructions TEXT,
        image_path TEXT,
        rating REAL DEFAULT 0.0,
        review_count INTEGER DEFAULT 0,
        status TEXT DEFAULT 'available',
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (farmer_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // 6. Product weights table
    await db.execute('''
      CREATE TABLE product_weights (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        weight_value TEXT NOT NULL,
        is_available INTEGER DEFAULT 1,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');

    // 7. Cart items table
    await db.execute('''
      CREATE TABLE cart_items (
        id TEXT PRIMARY KEY,
        customer_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        selected_weight TEXT NOT NULL,
        quantity INTEGER DEFAULT 1,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');

    // 8. Orders table
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        customer_id TEXT NOT NULL,
        farmer_id TEXT NOT NULL,
        total_price REAL NOT NULL,
        total_weight REAL NOT NULL,
        status TEXT NOT NULL,
        delivery_method TEXT NOT NULL,
        delivery_address TEXT NOT NULL,
        payment_method TEXT NOT NULL,
        payment_status TEXT NOT NULL,
        order_date INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (farmer_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');

    // 9. Order items table
    await db.execute('''
      CREATE TABLE order_items (
        id TEXT PRIMARY KEY,
        order_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        selected_weight TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
      )
    ''');

    // 10. Reviews table
    await db.execute('''
      CREATE TABLE reviews (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        customer_id TEXT NOT NULL,
        rating REAL NOT NULL,
        comment TEXT,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
        FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE CASCADE
      )
    ''');
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}



