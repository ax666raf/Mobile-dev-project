from app.utils.database import db
from datetime import datetime
import uuid

class ProductImage(db.Model):
    """Product Image model for storing multiple images per product"""
    __tablename__ = 'product_images'
    
    id = db.Column(db.String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    product_id = db.Column(db.String(36), db.ForeignKey('products.id', ondelete='CASCADE'), nullable=False, index=True)
    image_path = db.Column(db.String(255), nullable=False)
    is_primary = db.Column(db.Boolean, default=False)  # First image is primary/cover
    display_order = db.Column(db.Integer, default=0)  # Order for displaying images
    created_at = db.Column(db.Integer, nullable=False, default=lambda: int(datetime.now().timestamp() * 1000))
    
    # Relationship
    product = db.relationship('Product', backref=db.backref('images', lazy=True, cascade='all, delete-orphan', order_by='ProductImage.display_order'))
    
    def to_dict(self):
        return {
            'id': self.id,
            'product_id': self.product_id,
            'image_path': self.image_path,
            'is_primary': self.is_primary,
            'display_order': self.display_order,
            'created_at': self.created_at,
        }

