from app.utils.database import db

class FarmerProfile(db.Model):
    """Farmer profile model"""
    __tablename__ = 'farmer_profiles'
    
    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id', ondelete='CASCADE'), nullable=False, unique=True)
    farm_name = db.Column(db.String(200), nullable=False)
    farm_location = db.Column(db.String(200))
    established_year = db.Column(db.String(10))
    description = db.Column(db.Text)  # Farm description
    is_verified = db.Column(db.Boolean, default=False)
    contact_number = db.Column(db.String(20))
    email_address = db.Column(db.String(120))
    orders_completed = db.Column(db.Integer, default=0)
    total_earnings = db.Column(db.Float, default=0.0)
    currency = db.Column(db.String(10), default='DA')
    active_products = db.Column(db.Integer, default=0)
    
    def to_dict(self):
        """Convert farmer profile to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'farm_name': self.farm_name,
            'farm_location': self.farm_location,
            'established_year': self.established_year,
            'description': self.description,
            'is_verified': bool(self.is_verified),
            'contact_number': self.contact_number,
            'email_address': self.email_address,
            'orders_completed': self.orders_completed,
            'total_earnings': self.total_earnings,
            'currency': self.currency,
            'active_products': self.active_products,
        }

