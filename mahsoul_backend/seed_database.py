"""
Seed script to populate database with initial test data
Run with: python seed_database.py
"""
from app import create_app
from config import Config
from app.utils.database import db
from app.models.user import User
from app.models.customer_profile import CustomerProfile
from app.models.farmer_profile import FarmerProfile
from app.models.product import Product
from app.models.product_weight import ProductWeight
from app.models.delivery_address import DeliveryAddress
from app.models.order import Order
from app.models.order_item import OrderItem
from app.models.review import Review
import uuid
from datetime import datetime

def seed_database():
    """Populate database with test data"""
    app = create_app(Config)
    
    with app.app_context():
        
        existing_users = User.query.all()
        if existing_users:
            print("⚠️  Database already has data. Skipping seed.")
            print("   To reseed, delete the database file and run again.")
            return
        
        print("🌱 Seeding database...")
        now = int(datetime.now().timestamp() * 1000)
        
        # 1. Create Users
        print("   Creating users...")
        customer_id = str(uuid.uuid4())
        farmer_id = str(uuid.uuid4())
        
        # Customer user
        customer_user = User(
            id=customer_id,
            email='customer@test.com',
            password_hash=User.hash_password('customer123'),  # password: customer123
            user_type='customer',
            full_name='Test Customer',
            phone_number='+213 555 123 456',
            created_at=now,
            updated_at=now,
        )
        db.session.add(customer_user)
        
        # Farmer user
        farmer_user = User(
            id=farmer_id,
            email='farmer@test.com',
            password_hash=User.hash_password('farmer123'),  # password: farmer123
            user_type='farmer',
            full_name='Adam Farmer',
            phone_number='+213 555 789 012',
            created_at=now,
            updated_at=now,
        )
        db.session.add(farmer_user)
        db.session.flush()
        
        # 2. Create Customer Profile
        print("   Creating customer profile...")
        customer_profile = CustomerProfile(
            id=str(uuid.uuid4()),
            user_id=customer_id,
            city='Algiers',
            postal_code='16000',
            total_orders=5,
            join_date='2024-01-15',
        )
        db.session.add(customer_profile)
        
        # 3. Create Farmer Profile
        print("   Creating farmer profile...")
        farmer_profile = FarmerProfile(
            id=str(uuid.uuid4()),
            user_id=farmer_id,
            farm_name="Adam's Organic Farm",
            farm_location='Blida, Algeria',
            established_year='1985',
            is_verified=True,
            contact_number='+213 555 789 012',
            email_address='farm@example.com',
            orders_completed=152,
            total_earnings=98400.0,
            currency='DA',
            active_products=4,
        )
        db.session.add(farmer_profile)
        db.session.flush()
        
        # 4. Create Products
        print("   Creating products...")
        products_data = [
            {
                'name': 'Fresh Tomatoes',
                'description': 'Organic fresh tomatoes from local farms',
                'category': 'Vegetables',
                'price': 250.0,
                'origin': 'Blida, Algeria',
                'harvest_season': 'All Season',
                'is_organic': True,
                'storage_instructions': 'Keep in cool place',
                'image_path': 'lib/assets/tomate.png',
                'rating': 4.4,
                'review_count': 156,
                'weights': ['500g', '1kg'],
            },
            {
                'name': 'Fresh Apples',
                'description': 'Sweet and crunchy organic apples',
                'category': 'Fruits',
                'price': 350.0,
                'origin': 'Blida, Algeria',
                'harvest_season': 'Fall',
                'is_organic': True,
                'storage_instructions': 'Refrigerate for freshness',
                'image_path': 'lib/assets/IMAGE.png',
                'rating': 4.6,
                'review_count': 89,
                'weights': ['1kg', '2kg'],
            },
            {
                'name': 'Fresh Carrots',
                'description': 'Sweet and crunchy carrots',
                'category': 'Vegetables',
                'price': 180.0,
                'origin': 'Blida, Algeria',
                'harvest_season': 'Spring',
                'is_organic': False,
                'storage_instructions': 'Keep in refrigerator',
                'image_path': 'lib/assets/carrot.png',
                'rating': 4.2,
                'review_count': 134,
                'weights': ['500g', '1kg'],
            },
            {
                'name': 'Wheat',
                'description': 'Fresh wheat grains',
                'category': 'Grains',
                'price': 200.0,
                'origin': 'Blida, Algeria',
                'harvest_season': 'Summer',
                'is_organic': True,
                'storage_instructions': 'Store in dry place',
                'image_path': 'lib/assets/wheat-sack.png',
                'rating': 4.5,
                'review_count': 67,
                'weights': ['1kg', '5kg'],
            },
        ]
        
        product_ids = []
        for product_data in products_data:
            product_id = str(uuid.uuid4())
            product_ids.append(product_id)
            
            product = Product(
                id=product_id,
                farmer_id=farmer_id,
                name=product_data['name'],
                description=product_data['description'],
                category=product_data['category'],
                price=product_data['price'],
                currency='DA',
                origin=product_data['origin'],
                harvest_season=product_data['harvest_season'],
                is_organic=product_data['is_organic'],
                storage_instructions=product_data['storage_instructions'],
                image_path=product_data['image_path'],
                rating=product_data['rating'],
                review_count=product_data['review_count'],
                status='available',
                created_at=now,
                updated_at=now,
            )
            db.session.add(product)
            db.session.flush()
            
            # Add product weights
            for weight_value in product_data['weights']:
                weight = ProductWeight(
                    id=str(uuid.uuid4()),
                    product_id=product_id,
                    weight_value=weight_value,
                    is_available=True,
                )
                db.session.add(weight)
        
        # 5. Create Delivery Address
        print("   Creating delivery address...")
        delivery_address = DeliveryAddress(
            id=str(uuid.uuid4()),
            customer_id=customer_id,
            address='123 Main Street',
            city='Algiers',
            postal_code='16000',
            is_default=True,
            created_at=now,
        )
        db.session.add(delivery_address)
        
        # 6. Create Order
        print("   Creating order...")
        order_id = str(uuid.uuid4())
        order = Order(
            id=order_id,
            customer_id=customer_id,
            farmer_id=farmer_id,
            total_price=500.0,
            total_weight=2.0,
            status='pending',
            delivery_method='Home Delivery',
            delivery_address='123 Main Street, Algiers',
            payment_method='Cash',
            payment_status='pending',
            order_date=now,
            created_at=now,
            updated_at=now,
        )
        db.session.add(order)
        db.session.flush()
        
        # Create Order Item
        order_item = OrderItem(
            id=str(uuid.uuid4()),
            order_id=order_id,
            product_id=product_ids[0],  # Fresh Tomatoes
            product_name='Fresh Tomatoes',
            selected_weight='1kg',
            quantity=2,
            unit_price=250.0,
            total_price=500.0,
        )
        db.session.add(order_item)
        
        # 7. Create Reviews
        print("   Creating reviews...")
        review1 = Review(
            id=str(uuid.uuid4()),
            product_id=product_ids[0],  # Fresh Tomatoes
            customer_id=customer_id,
            rating=5.0,
            comment='Excellent quality! Very fresh and tasty.',
            created_at=now,
        )
        db.session.add(review1)
        
        review2 = Review(
            id=str(uuid.uuid4()),
            product_id=product_ids[1],  # Fresh Apples
            customer_id=customer_id,
            rating=4.5,
            comment='Good apples, perfect for cooking.',
            created_at=now,
        )
        db.session.add(review2)
        
        # Commit all changes
        db.session.commit()
        
        print("✅ Database seeded successfully!")
        print("\n📋 Test Credentials:")
        print("   Customer:")
        print("     Email: customer@test.com")
        print("     Password: customer123")
        print("   Farmer:")
        print("     Email: farmer@test.com")
        print("     Password: farmer123")
        print("\n🚀 You can now test the API endpoints!")

if __name__ == '__main__':
    seed_database()

