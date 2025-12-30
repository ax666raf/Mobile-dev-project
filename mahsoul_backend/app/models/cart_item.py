from app.utils.database import db

class CartItem(db.Model):
    """Shopping cart item model"""
    __tablename__ = 'cart_items'
    
    id = db.Column(db.String(36), primary_key=True)
    customer_id = db.Column(db.String(36), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    product_id = db.Column(db.String(36), db.ForeignKey('products.id', ondelete='CASCADE'), nullable=False)
    selected_weight = db.Column(db.String(20), nullable=False)
    quantity = db.Column(db.Integer, default=1)
    created_at = db.Column(db.Integer, nullable=False)
    
    def to_dict(self, include_product=False):
        """Convert cart item to dictionary"""
        result = {
            'id': self.id,
            'customer_id': self.customer_id,
            'product_id': self.product_id,
            'selected_weight': self.selected_weight,
            'quantity': self.quantity,
            'created_at': self.created_at,
        }
        
        if include_product and self.product:
            result['product'] = self.product.to_dict()
        
        return result

