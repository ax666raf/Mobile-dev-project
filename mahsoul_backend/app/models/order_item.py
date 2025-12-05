from app.utils.database import db

class OrderItem(db.Model):
    """Order item model (line items in an order)"""
    __tablename__ = 'order_items'
    
    id = db.Column(db.String(36), primary_key=True)
    order_id = db.Column(db.String(36), db.ForeignKey('orders.id', ondelete='CASCADE'), nullable=False)
    product_id = db.Column(db.String(36), db.ForeignKey('products.id', ondelete='CASCADE'), nullable=False)
    product_name = db.Column(db.String(200), nullable=False)
    selected_weight = db.Column(db.String(20), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    unit_price = db.Column(db.Float, nullable=False)
    total_price = db.Column(db.Float, nullable=False)
    
    def to_dict(self):
        """Convert order item to dictionary"""
        return {
            'id': self.id,
            'order_id': self.order_id,
            'product_id': self.product_id,
            'product_name': self.product_name,
            'selected_weight': self.selected_weight,
            'quantity': self.quantity,
            'unit_price': self.unit_price,
            'total_price': self.total_price,
        }

