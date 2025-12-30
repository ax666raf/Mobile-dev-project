from app.utils.database import db

class Product(db.Model):
    """Product model"""
    __tablename__ = 'products'
    
    id = db.Column(db.String(36), primary_key=True)
    farmer_id = db.Column(db.String(36), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    name = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    category = db.Column(db.String(50), nullable=False)
    price = db.Column(db.Float, nullable=False)
    currency = db.Column(db.String(10), default='DA')
    origin = db.Column(db.String(100))
    harvest_season = db.Column(db.String(50))
    is_organic = db.Column(db.Boolean, default=False)
    storage_instructions = db.Column(db.Text)
    image_path = db.Column(db.String(255))
    rating = db.Column(db.Float, default=0.0)
    review_count = db.Column(db.Integer, default=0)
    status = db.Column(db.String(20), default='available')  # 'available', 'unavailable', 'out_of_stock'
    created_at = db.Column(db.Integer, nullable=False)
    updated_at = db.Column(db.Integer, nullable=False)
    
    # Relationships
    weights = db.relationship('ProductWeight', backref='product', cascade='all, delete-orphan')
    reviews = db.relationship('Review', backref='product', cascade='all, delete-orphan')
    cart_items = db.relationship('CartItem', backref='product', cascade='all, delete-orphan')
    order_items = db.relationship('OrderItem', backref='product', cascade='all, delete-orphan')
    favorites = db.relationship('Favorite', backref='product', cascade='all, delete-orphan')
    
    def to_dict(self, include_weights=True, include_reviews=False):
        """Convert product to dictionary"""
        result = {
            'id': self.id,
            'farmer_id': self.farmer_id,
            'name': self.name,
            'description': self.description,
            'category': self.category,
            'price': self.price,
            'currency': self.currency,
            'origin': self.origin,
            'harvest_season': self.harvest_season,
            'is_organic': bool(self.is_organic),
            'storage_instructions': self.storage_instructions,
            'image_path': self.image_path,
            'rating': self.rating,
            'review_count': self.review_count,
            'status': self.status,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
        }
        
        if include_weights:
            result['weights'] = [w.to_dict() for w in self.weights]
        
        if include_reviews:
            result['reviews'] = [r.to_dict() for r in self.reviews]
        
        return result

