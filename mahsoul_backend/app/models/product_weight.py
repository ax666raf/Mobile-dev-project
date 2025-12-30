from app.utils.database import db

class ProductWeight(db.Model):
    """Product weight options model"""
    __tablename__ = 'product_weights'
    
    id = db.Column(db.String(36), primary_key=True)
    product_id = db.Column(db.String(36), db.ForeignKey('products.id', ondelete='CASCADE'), nullable=False)
    weight_value = db.Column(db.String(20), nullable=False)  # e.g., '500g', '1kg', '2kg'
    is_available = db.Column(db.Boolean, default=True)
    
    def to_dict(self):
        """Convert product weight to dictionary"""
        return {
            'id': self.id,
            'product_id': self.product_id,
            'weight_value': self.weight_value,
            'is_available': bool(self.is_available),
        }

