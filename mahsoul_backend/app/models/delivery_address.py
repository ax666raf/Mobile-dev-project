from app.utils.database import db

class DeliveryAddress(db.Model):
    """Delivery address model"""
    __tablename__ = 'delivery_addresses'
    
    id = db.Column(db.String(36), primary_key=True)
    customer_id = db.Column(db.String(36), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    address = db.Column(db.String(500), nullable=False)
    city = db.Column(db.String(100), nullable=False)
    postal_code = db.Column(db.String(20))
    is_default = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.Integer, nullable=False)
    
    def to_dict(self):
        """Convert delivery address to dictionary"""
        return {
            'id': self.id,
            'customer_id': self.customer_id,
            'address': self.address,
            'city': self.city,
            'postal_code': self.postal_code,
            'is_default': bool(self.is_default),
            'created_at': self.created_at,
        }

