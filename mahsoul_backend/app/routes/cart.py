from flask import Blueprint, request, jsonify
from app.utils.database import db
from app.models.cart_item import CartItem
from app.models.product import Product
import uuid
from datetime import datetime
import re

bp = Blueprint('cart', __name__)

def calculate_price_for_weight(base_price, weight_str):
    """Calculate price based on selected weight.
    Price doubles for each weight increment (500g = 1x, 1kg = 2x, 2kg = 4x, etc.)
    """
    if not weight_str or base_price == 0:
        return base_price
    
    # Extract numeric value from weight string (e.g., "500g" -> 0.5, "1kg" -> 1, "2kg" -> 2)
    weight_str_clean = weight_str.lower().replace('kg', '').replace('g', '').strip()
    
    try:
        weight_value = float(weight_str_clean)
        # Convert grams to kg (if it's in grams, divide by 1000)
        if 'g' in weight_str.lower() and 'kg' not in weight_str.lower():
            weight_value = weight_value / 1000.0
    except (ValueError, TypeError):
        # If parsing fails, default to 1kg
        weight_value = 1.0
    
    # Calculate multiplier: base is 0.5kg (500g), so multiply by (weightValue / 0.5)
    # This means: 500g = 1x, 1kg = 2x, 2kg = 4x, etc.
    multiplier = weight_value / 0.5
    return base_price * multiplier

@bp.route('', methods=['GET'])
def get_cart():
    """Get user's cart"""
    try:
        customer_id = request.args.get('customer_id')
        if not customer_id:
            return jsonify({'error': 'customer_id required'}), 400
        
        cart_items = CartItem.query.filter_by(customer_id=customer_id).all()
        
        # Calculate total
        total = 0.0
        items_with_details = []
        for item in cart_items:
            product = Product.query.get(item.product_id)
            if product:
                # Calculate price based on selected weight
                # Price doubles for each weight increment (500g = 1x, 1kg = 2x, 2kg = 4x, etc.)
                unit_price = calculate_price_for_weight(product.price, item.selected_weight)
                
                item_dict = item.to_dict(include_product=True)
                item_dict['unit_price'] = unit_price
                item_dict['subtotal'] = unit_price * item.quantity
                total += item_dict['subtotal']
                items_with_details.append(item_dict)
        
        return jsonify({
            'items': items_with_details,
            'total': total,
            'count': len(items_with_details)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/add', methods=['POST'])
def add_to_cart():
    """Add item to cart"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        customer_id = data.get('customer_id')
        product_id = data.get('product_id')
        selected_weight = data.get('selected_weight')
        quantity = data.get('quantity', 1)
        
        if not customer_id or not product_id or not selected_weight:
            return jsonify({'error': 'customer_id, product_id, and selected_weight required'}), 400
        
        # Check if product exists
        product = Product.query.get(product_id)
        if not product:
            return jsonify({'error': 'Product not found'}), 404
        
        # Check if item already exists in cart
        existing_item = CartItem.query.filter_by(
            customer_id=customer_id,
            product_id=product_id,
            selected_weight=selected_weight
        ).first()
        
        if existing_item:
            # Update quantity
            existing_item.quantity += quantity
            db.session.commit()
            return jsonify({
                'message': 'Cart item updated',
                'item': existing_item.to_dict()
            }), 200
        
        # Create new cart item
        now = int(datetime.now().timestamp() * 1000)
        cart_item = CartItem(
            id=str(uuid.uuid4()),
            customer_id=customer_id,
            product_id=product_id,
            selected_weight=selected_weight,
            quantity=quantity,
            created_at=now,
        )
        
        db.session.add(cart_item)
        db.session.commit()
        
        return jsonify({
            'message': 'Item added to cart',
            'item': cart_item.to_dict(include_product=True)
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/<item_id>', methods=['PUT'])
def update_cart_item(item_id):
    """Update cart item quantity"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        quantity = data.get('quantity')
        if quantity is None or quantity < 1:
            return jsonify({'error': 'Valid quantity required'}), 400
        
        cart_item = CartItem.query.get(item_id)
        if not cart_item:
            return jsonify({'error': 'Cart item not found'}), 404
        
        cart_item.quantity = quantity
        db.session.commit()
        
        return jsonify({
            'message': 'Cart item updated',
            'item': cart_item.to_dict(include_product=True)
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/<item_id>', methods=['DELETE'])
def remove_from_cart(item_id):
    """Remove item from cart"""
    try:
        cart_item = CartItem.query.get(item_id)
        if not cart_item:
            return jsonify({'error': 'Cart item not found'}), 404
        
        db.session.delete(cart_item)
        db.session.commit()
        
        return jsonify({'message': 'Item removed from cart'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/clear', methods=['DELETE'])
def clear_cart():
    """Clear user's cart"""
    try:
        customer_id = request.args.get('customer_id')
        if not customer_id:
            return jsonify({'error': 'customer_id required'}), 400
        
        cart_items = CartItem.query.filter_by(customer_id=customer_id).all()
        for item in cart_items:
            db.session.delete(item)
        
        db.session.commit()
        
        return jsonify({'message': 'Cart cleared'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

