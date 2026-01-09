from flask import Blueprint, request, jsonify
from app.models.fcm_token import FCMToken
from app.models.user import User
from app.utils.database import db
from datetime import datetime
import uuid

bp = Blueprint('fcm_tokens', __name__)

@bp.route('', methods=['POST'])
def register_token():
    """Register or update FCM token for a user"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        user_id = data.get('user_id')
        token = data.get('token')
        device_type = data.get('device_type', 'android')  # Default to android
        
        if not user_id or not token:
            return jsonify({'error': 'user_id and token are required'}), 400
        
        # Verify user exists
        user = User.query.get(user_id)
        if not user:
            return jsonify({'error': 'User not found'}), 404
        
        # Check if token already exists for this user
        existing_token = FCMToken.query.filter_by(
            user_id=user_id,
            token=token
        ).first()
        
        if existing_token:
            # Update existing token
            existing_token.updated_at = int(datetime.now().timestamp() * 1000)
            existing_token.device_type = device_type
            db.session.commit()
            return jsonify({
                'message': 'Token updated successfully',
                'token': existing_token.to_dict()
            }), 200
        
        # Check if this token exists for another user (token migration)
        token_exists = FCMToken.query.filter_by(token=token).first()
        if token_exists:
            # Update to new user
            token_exists.user_id = user_id
            token_exists.device_type = device_type
            token_exists.updated_at = int(datetime.now().timestamp() * 1000)
            db.session.commit()
            return jsonify({
                'message': 'Token migrated to new user',
                'token': token_exists.to_dict()
            }), 200
        
        # Create new token
        now = int(datetime.now().timestamp() * 1000)
        fcm_token = FCMToken(
            id=str(uuid.uuid4()),
            user_id=user_id,
            token=token,
            device_type=device_type,
            created_at=now,
            updated_at=now,
        )
        
        db.session.add(fcm_token)
        db.session.commit()
        
        return jsonify({
            'message': 'Token registered successfully',
            'token': fcm_token.to_dict()
        }), 201
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/user/<user_id>', methods=['GET'])
def get_user_tokens(user_id):
    """Get all FCM tokens for a user"""
    try:
        tokens = FCMToken.query.filter_by(user_id=user_id).all()
        return jsonify({
            'tokens': [t.to_dict() for t in tokens],
            'count': len(tokens)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/<token_id>', methods=['DELETE'])
def delete_token(token_id):
    """Delete an FCM token"""
    try:
        token = FCMToken.query.get(token_id)
        if not token:
            return jsonify({'error': 'Token not found'}), 404
        
        db.session.delete(token)
        db.session.commit()
        
        return jsonify({'message': 'Token deleted successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/user/<user_id>', methods=['DELETE'])
def delete_user_tokens(user_id):
    """Delete all FCM tokens for a user"""
    try:
        tokens = FCMToken.query.filter_by(user_id=user_id).all()
        for token in tokens:
            db.session.delete(token)
        db.session.commit()
        
        return jsonify({
            'message': f'Deleted {len(tokens)} token(s) successfully'
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

