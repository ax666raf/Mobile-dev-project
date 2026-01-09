"""
Script to check if phone_number column exists in users table
Run with: python check_phone_number_column.py
"""
from app import create_app
from config import Config
from app.utils.database import db
from app.models.user import User
import sqlite3
from pathlib import Path

def check_phone_number_column():
    """Check if phone_number column exists and show user data"""
    app = create_app(Config)
    
    with app.app_context():
        # Get database path
        database_path = Path(app.config['SQLALCHEMY_DATABASE_URI'].replace('sqlite:///', '').split('?')[0])
        
        if not database_path.exists():
            print(f"❌ Database not found at: {database_path}")
            return
        
        print(f"📦 Database found at: {database_path}")
        print("=" * 50)
        
        # Method 1: Check using SQLite directly
        conn = sqlite3.connect(str(database_path))
        cursor = conn.cursor()
        
        try:
            # Check if phone_number column exists
            cursor.execute("PRAGMA table_info(users)")
            columns = cursor.fetchall()
            
            print("📋 Users table columns:")
            phone_column_exists = False
            for col in columns:
                col_name = col[1]
                col_type = col[2]
                is_nullable = not col[3]
                print(f"   - {col_name} ({col_type}) {'NULL' if is_nullable else 'NOT NULL'}")
                if col_name == 'phone_number':
                    phone_column_exists = True
            
            print("\n" + "=" * 50)
            
            if phone_column_exists:
                print("✅ phone_number column EXISTS in users table")
            else:
                print("❌ phone_number column DOES NOT EXIST in users table")
                print("   You need to run a migration to add it!")
                return
            
            # Check user data
            print("\n📊 User data (showing phone_number values):")
            cursor.execute("SELECT id, email, full_name, phone_number FROM users LIMIT 10")
            users = cursor.fetchall()
            
            if not users:
                print("   No users found in database")
            else:
                for user in users:
                    user_id, email, full_name, phone_number = user
                    phone_status = "✅ Has phone" if phone_number else "❌ NULL/Empty"
                    print(f"   - {email} ({full_name or 'No name'}) - {phone_status}: {phone_number or 'N/A'}")
            
        except Exception as e:
            print(f"❌ Error: {e}")
            import traceback
            traceback.print_exc()
        finally:
            conn.close()
        
        print("\n" + "=" * 50)
        
        # Method 2: Check using SQLAlchemy
        try:
            print("\n🔍 Checking using SQLAlchemy model...")
            users = User.query.limit(5).all()
            print(f"   Found {len(users)} users (showing first 5)")
            for user in users:
                try:
                    phone = user.phone_number
                    phone_status = "✅ Has phone" if phone else "❌ NULL/Empty"
                    print(f"   - {user.email} - {phone_status}: {phone or 'N/A'}")
                except AttributeError as e:
                    print(f"   - {user.email} - ❌ AttributeError: {e}")
        except Exception as e:
            print(f"❌ Error checking with SQLAlchemy: {e}")

if __name__ == '__main__':
    print("=" * 50)
    print("Check phone_number column in users table")
    print("=" * 50)
    check_phone_number_column()
    print("=" * 50)

