from app.utils.database import db

class Order(db.Model):
    """Order model"""
    __tablename__ = 'orders'
    
    id = db.Column(db.String(36), primary_key=True)
    customer_id = db.Column(db.String(36), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    farmer_id = db.Column(db.String(36), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    total_price = db.Column(db.Float, nullable=False)
    total_weight = db.Column(db.Float, nullable=False)
    status = db.Column(db.String(20), nullable=False)  # 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'
    delivery_method = db.Column(db.String(50), nullable=False)
    delivery_address = db.Column(db.String(500), nullable=False)
    payment_method = db.Column(db.String(50), nullable=False)
    payment_status = db.Column(db.String(20), nullable=False)  # 'pending', 'paid', 'failed'
    order_date = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.Integer, nullable=False)
    updated_at = db.Column(db.Integer, nullable=False)
    
    # Relationships
    items = db.relationship('OrderItem', backref='order', cascade='all, delete-orphan')
    
    def to_dict(self, include_items=False):
        """Convert order to dictionary"""
        result = {
            'id': self.id,
            'customer_id': self.customer_id,
            'farmer_id': self.farmer_id,
            'total_price': self.total_price,
            'total_weight': self.total_weight,
            'status': self.status,
            'delivery_method': self.delivery_method,
            'delivery_address': self.delivery_address,
            'payment_method': self.payment_method,
            'payment_status': self.payment_status,
            'order_date': self.order_date,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
        }
        
        if include_items:
            result['items'] = [item.to_dict() for item in self.items]
        
        return result

