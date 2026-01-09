from flask import Blueprint, request, jsonify
from app.models.notification import Notification
from app.models.order import Order
from app.models.user import User
from app.utils.database import db
from app.utils.fcm_service import FCMService
from datetime import datetime
import uuid

bp = Blueprint('notifications', __name__)

@bp.route('/farmer/<farmer_id>', methods=['GET'])
def get_farmer_notifications(farmer_id):
    """Get all notifications for a farmer"""
    try:
        # Get query parameters
        unread_only = request.args.get('unread_only', 'false').lower() == 'true'
        limit = int(request.args.get('limit', 50))
        
        query = Notification.query.filter_by(farmer_id=farmer_id)
        
        if unread_only:
            query = query.filter_by(is_read=False)
        
        notifications = query.order_by(Notification.created_at.desc()).limit(limit).all()
        
        return jsonify({
            'notifications': [n.to_dict() for n in notifications],
            'unread_count': Notification.query.filter_by(
                farmer_id=farmer_id, 
                is_read=False
            ).count()
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/<notification_id>/read', methods=['PUT'])
def mark_as_read(notification_id):
    """Mark a notification as read"""
    try:
        notification = Notification.query.get(notification_id)
        if not notification:
            return jsonify({'error': 'Notification not found'}), 404
        
        notification.is_read = True
        db.session.commit()
        
        return jsonify({'message': 'Notification marked as read'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/farmer/<farmer_id>/read-all', methods=['PUT'])
def mark_all_as_read(farmer_id):
    """Mark all notifications as read for a farmer"""
    try:
        Notification.query.filter_by(
            farmer_id=farmer_id,
            is_read=False
        ).update({'is_read': True})
        db.session.commit()
        
        return jsonify({'message': 'All notifications marked as read'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/farmer/<farmer_id>/unread-count', methods=['GET'])
def get_unread_count(farmer_id):
    """Get unread notification count for a farmer"""
    try:
        count = Notification.query.filter_by(
            farmer_id=farmer_id,
            is_read=False
        ).count()
        
        return jsonify({'unread_count': count}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

def create_order_notification(order_id, farmer_id):
    """Helper function to create a notification when an order is placed and send push notification"""
    try:
        order = Order.query.get(order_id)
        if not order:
            return None
        
        # Get customer info
        customer = User.query.get(order.customer_id)
        customer_name = customer.full_name if customer else 'A customer'
        
        # Prepare notification message
        title = 'New Order Received'
        message = f'{customer_name} placed an order for {len(order.items)} item(s). Total: {order.total_price} DA'
        
        # Create notification in database
        notification = Notification(
            id=str(uuid.uuid4()),
            farmer_id=farmer_id,
            order_id=order_id,
            title=title,
            message=message,
            type='order',
            is_read=False,
            created_at=int(datetime.now().timestamp() * 1000)
        )
        
        db.session.add(notification)
        db.session.commit()
        
        # Send push notification
        try:
            FCMService.send_notification(
                user_id=farmer_id,
                title=title,
                body=message,
                data={
                    'type': 'order',
                    'order_id': order_id,
                    'notification_id': notification.id,
                    'user_type': 'farmer'
                }
            )
            print(f'✅ Push notification sent to farmer {farmer_id} for order {order_id}')
        except Exception as push_error:
            print(f'⚠️ Failed to send push notification: {push_error}')
            # Don't fail the whole operation if push fails
        
        return notification
    except Exception as e:
        db.session.rollback()
        print(f'Error creating notification: {e}')
        return None