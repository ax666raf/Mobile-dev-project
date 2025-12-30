from app.utils.database import db
from datetime import datetime
import hashlib

class User(db.Model):
    """User model for authentication and user management"""
    __tablename__ = 'users'
    
    id = db.Column(db.String(36), primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False, index=True)
    password_hash = db.Column(db.String(255), nullable=False)
    user_type = db.Column(db.String(20), nullable=False)  # 'customer' or 'farmer'
    full_name = db.Column(db.String(100))
    phone_number = db.Column(db.String(20))
    profile_image_path = db.Column(db.String(255))
    created_at = db.Column(db.Integer, nullable=False)
    updated_at = db.Column(db.Integer, nullable=False)
    
    # Relationships
    customer_profile = db.relationship('CustomerProfile', backref='user', uselist=False, cascade='all, delete-orphan')
    farmer_profile = db.relationship('FarmerProfile', backref='user', uselist=False, cascade='all, delete-orphan')
    cart_items = db.relationship('CartItem', backref='customer', cascade='all, delete-orphan')
    orders_as_customer = db.relationship('Order', foreign_keys='Order.customer_id', backref='customer_user', cascade='all, delete-orphan')
    orders_as_farmer = db.relationship('Order', foreign_keys='Order.farmer_id', backref='farmer_user', cascade='all, delete-orphan')
    reviews = db.relationship('Review', backref='customer', cascade='all, delete-orphan')
    delivery_addresses = db.relationship('DeliveryAddress', backref='customer', cascade='all, delete-orphan')
    
    @staticmethod
    def hash_password(password):
        """Hash password using SHA-256 (matching Flutter app)"""
        return hashlib.sha256(password.encode()).hexdigest()
    
    def verify_password(self, password):
        """Verify password"""
        return self.password_hash == self.hash_password(password)
    
    def to_dict(self):
        """Convert user to dictionary"""
        return {
            'id': self.id,
            'email': self.email,
            'user_type': self.user_type,
            'full_name': self.full_name,
            'phone_number': self.phone_number,
            'profile_image_path': self.profile_image_path,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
        }

