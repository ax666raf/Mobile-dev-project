from app.utils.database import db
from datetime import datetime

class FCMToken(db.Model):
    """FCM Token model for storing device tokens for push notifications"""
    __tablename__ = 'fcm_tokens'
    
    id = db.Column(db.String(36), primary_key=True)
    user_id = db.Column(db.String(36), db.ForeignKey('users.id'), nullable=False, index=True)
    token = db.Column(db.Text, nullable=False, unique=True, index=True)
    device_type = db.Column(db.String(20))  # 'android' or 'ios'
    created_at = db.Column(db.Integer, nullable=False)
    updated_at = db.Column(db.Integer, nullable=False)
    
    # Relationship
    user = db.relationship('User', backref='fcm_tokens')
    
    def to_dict(self):
        """Convert FCM token to dictionary"""
        return {
            'id': self.id,
            'user_id': self.user_id,
            'token': self.token,
            'device_type': self.device_type,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
        }

