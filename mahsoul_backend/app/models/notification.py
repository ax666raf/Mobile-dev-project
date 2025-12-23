from app.utils.database import db
from datetime import datetime

class Notification(db.Model):
    __tablename__ = 'notifications'
    
    id = db.Column(db.String(50), primary_key=True)
    farmer_id = db.Column(db.String(50), db.ForeignKey('users.id'), nullable=False)
    order_id = db.Column(db.String(50), db.ForeignKey('orders.id'), nullable=False)
    title = db.Column(db.String(200), nullable=False)
    message = db.Column(db.Text, nullable=False)
    type = db.Column(db.String(50), default='order')  # 'order', 'system', etc.
    is_read = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.BigInteger, nullable=False)
    
    # Relationships
    farmer = db.relationship('User', backref='notifications')
    order = db.relationship('Order', backref='notifications')
    
    def to_dict(self):
        return {
            'id': self.id,
            'farmer_id': self.farmer_id,
            'order_id': self.order_id,
            'title': self.title,
            'message': self.message,
            'type': self.type,
            'is_read': self.is_read,
            'created_at': self.created_at,
            'order': {
                'id': self.order.id,
                'status': self.order.status,
                'total_price': self.order.total_price,
            } if self.order else None
        }