from flask import Blueprint, request, jsonify
from app.utils.database import db
from app.models.product import Product
from sqlalchemy import or_

bp = Blueprint('products', __name__)

@bp.route('', methods=['GET'])
def get_products():
    """Get all products"""
    try:
        category = request.args.get('category')
        search = request.args.get('q')
        status = request.args.get('status', 'available')
        
        query = Product.query.filter_by(status=status)
        
        if category:
            query = query.filter_by(category=category)
        
        if search:
            query = query.filter(
                or_(
                    Product.name.like(f'%{search}%'),
                    Product.description.like(f'%{search}%')
                )
            )
        
        products = query.order_by(Product.created_at.desc()).all()
        
        return jsonify({
            'products': [p.to_dict() for p in products],
            'count': len(products)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/<product_id>', methods=['GET'])
def get_product(product_id):
    """Get product by ID"""
    try:
        product = Product.query.get(product_id)
        if not product:
            return jsonify({'error': 'Product not found'}), 404
        
        include_reviews = request.args.get('include_reviews', 'false').lower() == 'true'
        return jsonify(product.to_dict(include_reviews=include_reviews)), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/category/<category>', methods=['GET'])
def get_products_by_category(category):
    """Get products by category"""
    try:
        status = request.args.get('status', 'available')
        products = Product.query.filter_by(
            category=category,
            status=status
        ).order_by(Product.created_at.desc()).all()
        
        return jsonify({
            'products': [p.to_dict() for p in products],
            'count': len(products)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/search', methods=['GET'])
def search_products():
    """Search products"""
    try:
        query_param = request.args.get('q', '')
        
        if not query_param:
            return jsonify({'error': 'Search query required'}), 400
        
        status = request.args.get('status', 'available')
        products = Product.query.filter(
            or_(
                Product.name.like(f'%{query_param}%'),
                Product.description.like(f'%{query_param}%')
            ),
            Product.status == status
        ).order_by(Product.created_at.desc()).all()
        
        return jsonify({
            'products': [p.to_dict() for p in products],
            'count': len(products)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('/<product_id>/reviews', methods=['GET'])
def get_product_reviews(product_id):
    """Get reviews for a product"""
    try:
        product = Product.query.get(product_id)
        if not product:
            return jsonify({'error': 'Product not found'}), 404
        
        reviews = product.reviews
        return jsonify({
            'reviews': [r.to_dict(include_customer=True) for r in reviews],
            'count': len(reviews)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

