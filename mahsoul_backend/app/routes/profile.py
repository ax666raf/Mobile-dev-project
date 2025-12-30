from flask import Blueprint, request, jsonify
from app.utils.database import db
from app.models.user import User
from app.models.customer_profile import CustomerProfile
from app.models.farmer_profile import FarmerProfile
from datetime import datetime

bp = Blueprint('profile', __name__)

@bp.route('', methods=['GET'])
def get_profile():
    """Get user profile"""
    try:
        user_id = request.args.get('user_id')
        if not user_id:
            return jsonify({'error': 'user_id required'}), 400
        
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        profile_data = user.to_dict()
        
        # Add profile-specific data
        if user.user_type == 'customer' and user.customer_profile:
            profile_data['profile'] = user.customer_profile.to_dict()
        elif user.user_type == 'farmer' and user.farmer_profile:
            profile_data['profile'] = user.farmer_profile.to_dict()
        
        return jsonify(profile_data), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('', methods=['PUT'])
def update_profile():
    """Update user profile"""
    try:
        data = request.get_json()
        print(f"🔵 Backend received data: {data}")
        print(f"🔵 Backend request method: {request.method}")
        print(f"🔵 Backend request content type: {request.content_type}")
        print(f"🔵 Backend request args: {request.args}")
        print(f"🔵 Backend request form: {request.form}")
        
        if not data:
            print("❌ Backend: No data provided")
            return jsonify({'error': 'No data provided'}), 400
        
        user_id = data.get('user_id')
        print(f"🔵 Backend extracted user_id: {user_id}")
        if not user_id:
            print("❌ Backend: user_id not found in data")
            return jsonify({'error': 'user_id required'}), 400
        
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Update user fields
        if 'full_name' in data:
            user.full_name = data['full_name']
        if 'phone_number' in data:
            user.phone_number = data['phone_number']
        if 'profile_image_path' in data:
            user.profile_image_path = data['profile_image_path']
        
        user.updated_at = int(datetime.now().timestamp() * 1000)
        
        # Update profile-specific fields
        if user.user_type == 'customer' and user.customer_profile:
            if 'city' in data:
                user.customer_profile.city = data['city']
            if 'postal_code' in data:
                user.customer_profile.postal_code = data['postal_code']
        elif user.user_type == 'farmer' and user.farmer_profile:
            if 'farm_name' in data:
                user.farmer_profile.farm_name = data['farm_name']
            if 'farm_location' in data:
                user.farmer_profile.farm_location = data['farm_location']
            if 'established_year' in data:
                user.farmer_profile.established_year = data['established_year']
            if 'description' in data:
                user.farmer_profile.description = data['description']
            if 'contact_number' in data:
                user.farmer_profile.contact_number = data['contact_number']
            if 'email_address' in data:
                user.farmer_profile.email_address = data['email_address']
        
        db.session.commit()
        
        # Return updated profile
        profile_data = user.to_dict()
        if user.user_type == 'customer' and user.customer_profile:
            profile_data['profile'] = user.customer_profile.to_dict()
        elif user.user_type == 'farmer' and user.farmer_profile:
            profile_data['profile'] = user.farmer_profile.to_dict()
        
        return jsonify({
            'message': 'Profile updated successfully',
            'user': profile_data
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/image', methods=['POST'])
def update_profile_image():
    """Update profile image"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        user_id = data.get('user_id')
        image_path = data.get('image_path')
        
        if not user_id or not image_path:
            return jsonify({'error': 'user_id and image_path required'}), 400
        
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        user.profile_image_path = image_path
        user.updated_at = int(datetime.now().timestamp() * 1000)
        db.session.commit()
        
        return jsonify({
            'message': 'Profile image updated',
            'user': user.to_dict()
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

