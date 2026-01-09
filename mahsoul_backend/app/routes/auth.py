from flask import Blueprint, request, jsonify
from app.utils.database import db
from app.models.user import User
from app.models.customer_profile import CustomerProfile
from app.models.farmer_profile import FarmerProfile
import uuid
from datetime import datetime

bp = Blueprint('auth', __name__)

@bp.route('/login', methods=['POST'])
def login():
    """User login endpoint"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        email = data.get('email')
        password = data.get('password')
        
        if not email or not password:
            return jsonify({'error': 'Email and password required'}), 400
        
        user = User.query.filter_by(email=email).first()
        
        if not user or not user.verify_password(password):
            return jsonify({'error': 'Invalid email or password'}), 401
        
        return jsonify({
            'message': 'Login successful',
            'user': user.to_dict()
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/signup', methods=['POST'])
def signup():
    """User registration endpoint"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        email = data.get('email')
        password = data.get('password')
        user_type = data.get('user_type')
        phone_number = data.get('phone_number')
        
        if not email or not password or not user_type:
            return jsonify({'error': 'Email, password, and user_type required'}), 400
        
        if not phone_number:
            return jsonify({'error': 'Phone number is required'}), 400
        
        if user_type not in ['customer', 'farmer']:
            return jsonify({'error': 'Invalid user_type. Must be "customer" or "farmer"'}), 400
        
        # Check if user exists
        if User.query.filter_by(email=email).first():
            return jsonify({'error': 'Email already registered'}), 400
        
        # Create user
        now = int(datetime.now().timestamp() * 1000)
        user = User(
            id=str(uuid.uuid4()),
            email=email,
            password_hash=User.hash_password(password),
            user_type=user_type,
            full_name=data.get('full_name'),
            phone_number=data.get('phone_number'),
            created_at=now,
            updated_at=now,
        )
        
        db.session.add(user)
        db.session.flush()
        
        # Create profile based on user type
        if user_type == 'customer':
            profile = CustomerProfile(
                id=str(uuid.uuid4()),
                user_id=user.id,
                city=data.get('city'),
                postal_code=data.get('postal_code'),
                total_orders=0,
                join_date=datetime.now().strftime('%Y-%m-%d'),
            )
            db.session.add(profile)
        elif user_type == 'farmer':
            profile = FarmerProfile(
                id=str(uuid.uuid4()),
                user_id=user.id,
                farm_name=data.get('full_name') or 'My Farm',
                farm_location=data.get('farm_location'),
                established_year=data.get('established_year'),
                orders_completed=0,
                total_earnings=0.0,
                currency='DA',
                active_products=0,
                is_verified=False,
            )
            db.session.add(profile)
        
        db.session.commit()
        
        return jsonify({
            'message': 'Registration successful',
            'user': user.to_dict()
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/me', methods=['GET'])
def get_current_user():
    """Get current user (requires user_id in query params for now)"""
    try:
        user_id = request.args.get('user_id')
        if not user_id:
            return jsonify({'error': 'user_id required'}), 400
        
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        return jsonify(user.to_dict()), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/logout', methods=['POST'])
def logout():
    """User logout endpoint"""
    # For now, just return success (token-based auth would invalidate token here)
    return jsonify({'message': 'Logout successful'}), 200

