from app.utils.database import db

class Favorite(db.Model):
    """Customer favorite products model"""
    __tablename__ = 'favorites'
    
    id = db.Column(db.String(36), primary_key=True)
    customer_id = db.Column(db.String(36), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    product_id = db.Column(db.String(36), db.ForeignKey('products.id', ondelete='CASCADE'), nullable=False)
    created_at = db.Column(db.Integer, nullable=False)
    
    # Ensure unique combination of customer and product
    __table_args__ = (
        db.UniqueConstraint('customer_id', 'product_id', name='unique_customer_product_favorite'),
    )
    
    def to_dict(self, include_product=False):
        """Convert favorite to dictionary"""
        result = {
            'id': self.id,
            'customer_id': self.customer_id,
            'product_id': self.product_id,
            'created_at': self.created_at,
        }
        
        if include_product and self.product:
            result['product'] = self.product.to_dict()
        
        return result
