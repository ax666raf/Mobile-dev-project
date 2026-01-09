from flask import Blueprint, request, jsonify
from app.utils.database import db
from app.models.product import Product
from app.models.product_weight import ProductWeight
from app.models.product_image import ProductImage
from app.models.order import Order
from app.models.farmer_profile import FarmerProfile
from sqlalchemy import func
import uuid
from datetime import datetime

bp = Blueprint('farmer', __name__)

# ========== PRODUCT ROUTES ==========

@bp.route('/products', methods=['GET'])
def get_farmer_products():
    """Get farmer's products"""
    try:
        farmer_id = request.args.get('farmer_id')
        category = request.args.get('category')
        status = request.args.get('status', 'available')
        
        if not farmer_id:
            return jsonify({'error': 'farmer_id required'}), 400
        
        query = Product.query.filter_by(farmer_id=farmer_id, status=status)
        
        if category:
            query = query.filter_by(category=category)
        
        products = query.order_by(Product.created_at.desc()).all()
        
        return jsonify({
            'products': [p.to_dict() for p in products],
            'count': len(products)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/products', methods=['POST'])
def add_product():
    """Add new product"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        farmer_id = data.get('farmer_id')
        name = data.get('name')
        category = data.get('category')
        price = data.get('price')
        
        if not farmer_id or not name or not category or price is None:
            return jsonify({'error': 'farmer_id, name, category, and price required'}), 400
        
        now = int(datetime.now().timestamp() * 1000)
        product = Product(
            id=str(uuid.uuid4()),
            farmer_id=farmer_id,
            name=name,
            description=data.get('description'),
            category=category,
            price=float(price),
            currency=data.get('currency', 'DA'),
            origin=data.get('origin'),
            harvest_season=data.get('harvest_season'),
            is_organic=data.get('is_organic', False),
            storage_instructions=data.get('storage_instructions'),
            image_path=data.get('image_path'),
            status=data.get('status', 'available'),
            created_at=now,
            updated_at=now,
        )
        
        db.session.add(product)
        db.session.flush()
        
        # Add product weights
        weights = data.get('weights', [])
        for weight_value in weights:
            weight = ProductWeight(
                id=str(uuid.uuid4()),
                product_id=product.id,
                weight_value=weight_value,
                is_available=True,
            )
            db.session.add(weight)
        
        # Add product images (multiple images support)
        image_paths = data.get('image_paths', [])
        if not image_paths and data.get('image_path'):
            # Backward compatibility: if single image_path provided, add it
            image_paths = [data.get('image_path')]
        
        for index, image_path in enumerate(image_paths):
            if image_path:  # Only add if image_path is not None/empty
                product_image = ProductImage(
                    id=str(uuid.uuid4()),
                    product_id=product.id,
                    image_path=image_path,
                    is_primary=(index == 0),  # First image is primary
                    display_order=index,
                )
                db.session.add(product_image)
                # Set product.image_path to first image for backward compatibility
                if index == 0:
                    product.image_path = image_path
        
        # Update farmer's active products count
        farmer_profile = FarmerProfile.query.filter_by(user_id=farmer_id).first()
        if farmer_profile:
            farmer_profile.active_products = Product.query.filter_by(
                farmer_id=farmer_id,
                status='available'
            ).count()
        
        db.session.commit()
        
        return jsonify({
            'message': 'Product added successfully',
            'product': product.to_dict(include_images=True)
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/products/<product_id>', methods=['PUT'])
def update_product(product_id):
    """Update product"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        product = Product.query.get(product_id)
        if not product:
            return jsonify({'error': 'Product not found'}), 404
        
        # Update fields
        updatable_fields = [
            'name', 'description', 'category', 'price', 'currency',
            'origin', 'harvest_season', 'is_organic', 'storage_instructions',
            'image_path', 'status'
        ]
        
        for field in updatable_fields:
            if field in data:
                setattr(product, field, data[field])
        
        product.updated_at = int(datetime.now().timestamp() * 1000)
        
        # Update weights if provided
        if 'weights' in data:
            ProductWeight.query.filter_by(product_id=product_id).delete()
            for weight_value in data['weights']:
                weight = ProductWeight(
                    id=str(uuid.uuid4()),
                    product_id=product_id,
                    weight_value=weight_value,
                    is_available=True,
                )
                db.session.add(weight)
        
        # Update product images if provided
        if 'image_paths' in data:
            # Delete existing images
            ProductImage.query.filter_by(product_id=product_id).delete()
            # Add new images
            image_paths = data.get('image_paths', [])
            for index, image_path in enumerate(image_paths):
                if image_path:  # Only add if image_path is not None/empty
                    product_image = ProductImage(
                        id=str(uuid.uuid4()),
                        product_id=product_id,
                        image_path=image_path,
                        is_primary=(index == 0),  # First image is primary
                        display_order=index,
                    )
                    db.session.add(product_image)
                    # Update product.image_path to first image for backward compatibility
                    if index == 0:
                        product.image_path = image_path
        elif 'image_path' in data and data.get('image_path'):
            # Backward compatibility: if single image_path provided, update images
            ProductImage.query.filter_by(product_id=product_id).delete()
            product_image = ProductImage(
                id=str(uuid.uuid4()),
                product_id=product_id,
                image_path=data['image_path'],
                is_primary=True,
                display_order=0,
            )
            db.session.add(product_image)
            product.image_path = data['image_path']
        
        db.session.commit()
        
        return jsonify({
            'message': 'Product updated successfully',
            'product': product.to_dict(include_images=True)
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/products/<product_id>', methods=['DELETE'])
def delete_product(product_id):
    """Delete product"""
    try:
        product = Product.query.get(product_id)
        if not product:
            return jsonify({'error': 'Product not found'}), 404
        
        farmer_id = product.farmer_id
        
        db.session.delete(product)
        
        farmer_profile = FarmerProfile.query.filter_by(user_id=farmer_id).first()
        if farmer_profile:
            farmer_profile.active_products = Product.query.filter_by(
                farmer_id=farmer_id,
                status='available'
            ).count()
        
        db.session.commit()
        
        return jsonify({'message': 'Product deleted successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

# ========== ORDER ROUTES ==========

@bp.route('/orders', methods=['GET'])
def get_farmer_orders():
    """Get farmer's orders"""
    try:
        farmer_id = request.args.get('farmer_id')
        status = request.args.get('status')
        
        if not farmer_id:
            return jsonify({'error': 'farmer_id required'}), 400
        
        query = Order.query.filter_by(farmer_id=farmer_id)
        
        if status:
            query = query.filter_by(status=status)
        
        orders = query.order_by(Order.created_at.desc()).all()
        
        # Include customer information in each order
        orders_data = []
        for order in orders:
            order_dict = order.to_dict(include_items=True)
            # Add customer information
            if order.customer_user:
                # Get phone number - check if column exists and has value
                customer_phone = None
                try:
                    customer_phone = order.customer_user.phone_number
                    if not customer_phone:
                        print(f"⚠️ Customer {order.customer_user.id} has no phone_number in database")
                except AttributeError as e:
                    print(f"⚠️ phone_number column might not exist in users table: {e}")
                
                order_dict['customer'] = {
                    'id': order.customer_user.id,
                    'full_name': order.customer_user.full_name,
                    'email': order.customer_user.email,
                    'phone_number': customer_phone,
                }
            orders_data.append(order_dict)
        
        return jsonify({
            'orders': orders_data,
            'count': len(orders)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/orders/<order_id>/status', methods=['PUT'])
def update_farmer_order_status(order_id):
    """Update order status (for farmer)"""
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
        
        # Update farmer stats if delivered
        if status == 'delivered':
            farmer_profile = FarmerProfile.query.filter_by(user_id=order.farmer_id).first()
            if farmer_profile:
                farmer_profile.orders_completed += 1
                farmer_profile.total_earnings += order.total_price
        
        db.session.commit()
        
        return jsonify({
            'message': 'Order status updated',
            'order': order.to_dict(include_items=True)
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

# ========== DASHBOARD ROUTES ==========

@bp.route('/dashboard', methods=['GET'])
def get_dashboard():
    """Get farmer dashboard statistics"""
    try:
        farmer_id = request.args.get('farmer_id')
        if not farmer_id:
            return jsonify({'error': 'farmer_id required'}), 400
        
        # Get farmer profile
        farmer_profile = FarmerProfile.query.filter_by(user_id=farmer_id).first()
        if not farmer_profile:
            return jsonify({'error': 'Farmer profile not found'}), 404
        
        # Get statistics
        total_earnings = db.session.query(func.sum(Order.total_price)).filter_by(
            farmer_id=farmer_id,
            status='delivered'
        ).scalar() or 0.0
        
        orders_completed = Order.query.filter_by(
            farmer_id=farmer_id,
            status='delivered'
        ).count()
        
        active_products = Product.query.filter_by(
            farmer_id=farmer_id,
            status='available'
        ).count()
        
        # Get order statistics by status
        order_stats = db.session.query(
            Order.status,
            func.count(Order.id)
        ).filter_by(
            farmer_id=farmer_id
        ).group_by(Order.status).all()
        
        order_statistics = {status: count for status, count in order_stats}
        
        return jsonify({
            'profile': farmer_profile.to_dict(),
            'statistics': {
                'total_earnings': float(total_earnings),
                'orders_completed': orders_completed,
                'active_products': active_products,
                'order_statistics': order_statistics,
            }
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

