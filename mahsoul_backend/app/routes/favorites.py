from flask import Blueprint, request, jsonify
from app.models.favorite import Favorite
from app.models.product import Product
from app.models.user import User
from app.utils.database import db
from datetime import datetime
import uuid

bp = Blueprint('favorites', __name__)

@bp.route('/customer/<customer_id>', methods=['GET'])
def get_customer_favorites(customer_id):
    """Get all favorites for a customer"""
    try:
        # Verify customer exists
        customer = User.query.get(customer_id)
        if not customer:
            return jsonify({'error': 'Customer not found'}), 404
        
        favorites = Favorite.query.filter_by(customer_id=customer_id).order_by(Favorite.created_at.desc()).all()
        
        return jsonify({
            'favorites': [f.to_dict(include_product=True) for f in favorites],
            'count': len(favorites)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@bp.route('/customer/<customer_id>/ids', methods=['GET'])
def get_customer_favorite_ids(customer_id):
    """Get just the product IDs of customer's favorites (for quick lookup)"""
    try:
        favorites = Favorite.query.filter_by(customer_id=customer_id).all()
        product_ids = [f.product_id for f in favorites]
        
        return jsonify({
            'product_ids': product_ids,
            'count': len(product_ids)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@bp.route('', methods=['POST'])
def add_favorite():
    """Add a product to favorites"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        customer_id = data.get('customer_id')
        product_id = data.get('product_id')
        
        if not customer_id:
            return jsonify({'error': 'Customer ID is required'}), 400
        if not product_id:
            return jsonify({'error': 'Product ID is required'}), 400
        
        # Verify customer exists
        customer = User.query.get(customer_id)
        if not customer:
            return jsonify({'error': 'Customer not found'}), 404
        
        # Verify product exists
        product = Product.query.get(product_id)
        if not product:
            return jsonify({'error': 'Product not found'}), 404
        
        # Check if already favorited
        existing = Favorite.query.filter_by(
            customer_id=customer_id,
            product_id=product_id
        ).first()
        
        if existing:
            return jsonify({
                'message': 'Product already in favorites',
                'favorite': existing.to_dict(include_product=True)
            }), 200
        
        # Create new favorite
        favorite = Favorite(
            id=str(uuid.uuid4()),
            customer_id=customer_id,
            product_id=product_id,
            created_at=int(datetime.now().timestamp() * 1000)
        )
        
        db.session.add(favorite)
        db.session.commit()
        
        return jsonify({
            'message': 'Product added to favorites',
            'favorite': favorite.to_dict(include_product=True)
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@bp.route('/<favorite_id>', methods=['DELETE'])
def remove_favorite(favorite_id):
    """Remove a product from favorites by favorite ID"""
    try:
        favorite = Favorite.query.get(favorite_id)
        if not favorite:
            return jsonify({'error': 'Favorite not found'}), 404
        
        db.session.delete(favorite)
        db.session.commit()
        
        return jsonify({'message': 'Product removed from favorites'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@bp.route('/customer/<customer_id>/product/<product_id>', methods=['DELETE'])
def remove_favorite_by_product(customer_id, product_id):
    """Remove a product from favorites by customer and product ID"""
    try:
        favorite = Favorite.query.filter_by(
            customer_id=customer_id,
            product_id=product_id
        ).first()
        
        if not favorite:
            return jsonify({'error': 'Favorite not found'}), 404
        
        db.session.delete(favorite)
        db.session.commit()
        
        return jsonify({'message': 'Product removed from favorites'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@bp.route('/customer/<customer_id>/product/<product_id>/check', methods=['GET'])
def check_favorite(customer_id, product_id):
    """Check if a product is in customer's favorites"""
    try:
        favorite = Favorite.query.filter_by(
            customer_id=customer_id,
            product_id=product_id
        ).first()
        
        return jsonify({
            'is_favorite': favorite is not None,
            'favorite_id': favorite.id if favorite else None
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
