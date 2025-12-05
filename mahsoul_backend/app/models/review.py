from app.utils.database import db

class Review(db.Model):
    """Product review model"""
    __tablename__ = 'reviews'
    
    id = db.Column(db.String(36), primary_key=True)
    product_id = db.Column(db.String(36), db.ForeignKey('products.id', ondelete='CASCADE'), nullable=False)
    customer_id = db.Column(db.String(36), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    rating = db.Column(db.Float, nullable=False)  # 1.0 to 5.0
    comment = db.Column(db.Text)
    created_at = db.Column(db.Integer, nullable=False)
    
    def to_dict(self, include_customer=False):
        """Convert review to dictionary"""
        result = {
            'id': self.id,
            'product_id': self.product_id,
            'customer_id': self.customer_id,
            'rating': self.rating,
            'comment': self.comment,
            'created_at': self.created_at,
        }
        
        if include_customer and self.customer:
            result['customer'] = {
                'id': self.customer.id,
                'full_name': self.customer.full_name,
                'email': self.customer.email,
            }
        
        return result

