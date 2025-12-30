from app.utils.database import db

class CustomerProfile(db.Model):
    """Customer profile model"""
    __tablename__ = 'customer_profiles'
    
    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False, unique=True)
    city = db.Column(db.String(100))
    postal_code = db.Column(db.String(20))
    total_orders = db.Column(db.Integer, default=0)
    join_date = db.Column(db.String(20))
    
    def to_dict(self):
        """Convert customer profile to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'city': self.city,
            'postal_code': self.postal_code,
            'total_orders': self.total_orders,
            'join_date': self.join_date,
        }

