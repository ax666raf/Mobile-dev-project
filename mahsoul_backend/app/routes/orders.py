from flask import Blueprint, request, jsonify
from app.utils.database import db
from app.models.order import Order
from app.models.order_item import OrderItem
from app.models.cart_item import CartItem
from app.models.product import Product
import uuid
from datetime import datetime
import re

bp = Blueprint('orders', __name__)

def calculate_price_for_weight(base_price, weight_str):
    """Calculate price based on selected weight.
    Price doubles for each weight increment (500g = 1x, 1kg = 2x, 2kg = 4x, etc.)
    """
    if not weight_str or base_price == 0:
        return base_price
    
    weight_str_clean = weight_str.lower().replace('kg', '').replace('g', '').strip()
    
    try:
        weight_value = float(weight_str_clean)
        if 'g' in weight_str.lower() and 'kg' not in weight_str.lower():
            weight_value = weight_value / 1000.0
    except (ValueError, TypeError):
        weight_value = 1.0
    
    multiplier = weight_value / 0.5
    return base_price * multiplier

@bp.route('', methods=['GET'])
def get_orders():
    """Get user's orders"""
    try:
        customer_id = request.args.get('customer_id')
        farmer_id = request.args.get('farmer_id')
        status = request.args.get('status')
        
        if not customer_id and not farmer_id:
            return jsonify({'error': 'customer_id or farmer_id required'}), 400
        
        query = Order.query
        
        if customer_id:
            query = query.filter_by(customer_id=customer_id)
        if farmer_id:
            query = query.filter_by(farmer_id=farmer_id)
        if status:
            query = query.filter_by(status=status)
        
        orders = query.order_by(Order.created_at.desc()).all()
        
        return jsonify({
            'orders': [o.to_dict(include_items=True) for o in orders],
            'count': len(orders)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/<order_id>', methods=['GET'])
def get_order(order_id):
    """Get order by ID"""
    try:
        order = Order.query.get(order_id)
        if not order:
            return jsonify({'error': 'Order not found'}), 404
        
        return jsonify(order.to_dict(include_items=True)), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('', methods=['POST'])
def place_order():
    """Place order from cart"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        customer_id = data.get('customer_id')
        delivery_address = data.get('delivery_address')
        payment_method = data.get('payment_method', 'Cash')
        delivery_method = data.get('delivery_method', 'Home Delivery')
        
        if not customer_id or not delivery_address:
            return jsonify({'error': 'customer_id and delivery_address required'}), 400
        
        cart_items = CartItem.query.filter_by(customer_id=customer_id).all()
        if not cart_items:
            return jsonify({'error': 'Cart is empty'}), 400
        
        total_price = 0.0
        total_weight = 0.0
        farmer_id = None
        
        for item in cart_items:
            product = Product.query.get(item.product_id)
            if not product:
                continue
            
            if farmer_id is None:
                farmer_id = product.farmer_id
            elif farmer_id != product.farmer_id:
                return jsonify({'error': 'All items must be from the same farmer'}), 400
            
            unit_price = calculate_price_for_weight(product.price, item.selected_weight)
            total_price += unit_price * item.quantity
        
        if not farmer_id:
            return jsonify({'error': 'Unable to determine farmer'}), 400
        
        now = int(datetime.now().timestamp() * 1000)
        order = Order(
            id=str(uuid.uuid4()),
            customer_id=customer_id,
            farmer_id=farmer_id,
            total_price=total_price,
            total_weight=total_weight,
            status='pending',
            delivery_method=delivery_method,
            delivery_address=delivery_address,
            payment_method=payment_method,
            payment_status='pending',
            order_date=now,
            created_at=now,
            updated_at=now,
        )
        
        db.session.add(order)
        db.session.flush()
        
        for item in cart_items:
            product = Product.query.get(item.product_id)
            if product:
                unit_price = calculate_price_for_weight(product.price, item.selected_weight)
                item_total_price = unit_price * item.quantity
                
                order_item = OrderItem(
                    id=str(uuid.uuid4()),
                    order_id=order.id,
                    product_id=product.id,
                    product_name=product.name,
                    selected_weight=item.selected_weight,
                    quantity=item.quantity,
                    unit_price=unit_price,
                    total_price=item_total_price,
                )
                db.session.add(order_item)
        
        for item in cart_items:
            db.session.delete(item)
        
        db.session.commit()
        
        return jsonify({
            'message': 'Order placed successfully',
            'order': order.to_dict(include_items=True)
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/<order_id>/status', methods=['PUT'])
def update_order_status(order_id):
    """Update order status"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        status = data.get('status')
        if not status:
            return jsonify({'error': 'status required'}), 400
        
        valid_statuses = ['pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled']
        if status not in valid_statuses:
            return jsonify({'error': f'Invalid status. Must be one of: {valid_statuses}'}), 400
        
        order = Order.query.get(order_id)
        if not order:
            return jsonify({'error': 'Order not found'}), 404
        
        order.status = status
        order.updated_at = int(datetime.now().timestamp() * 1000)
        db.session.commit()
        
        return jsonify({
            'message': 'Order status updated',
            'order': order.to_dict(include_items=True)
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/<order_id>/cancel', methods=['POST'])
def cancel_order(order_id):
    """Cancel order"""
    try:
        order = Order.query.get(order_id)
        if not order:
            return jsonify({'error': 'Order not found'}), 404
        
        if order.status in ['delivered', 'cancelled']:
            return jsonify({'error': f'Cannot cancel order with status: {order.status}'}), 400
        
        order.status = 'cancelled'
        order.updated_at = int(datetime.now().timestamp() * 1000)
        db.session.commit()
        
        return jsonify({
            'message': 'Order cancelled',
            'order': order.to_dict(include_items=True)
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

