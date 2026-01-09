from flask import Blueprint, request, jsonify
from app.utils.database import db
from app.models.product import Product
from app.models.review import Review
from sqlalchemy import or_
import uuid
from datetime import datetime

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
        return jsonify(product.to_dict(include_reviews=include_reviews, include_images=True)), 200
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


@bp.route('/<product_id>/reviews', methods=['POST'])
def create_review(product_id):
    """Create a review for a product"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Validate required fields
        customer_id = data.get('customer_id')
        rating = data.get('rating')
        comment = data.get('comment', '')
        
        if not customer_id:
            return jsonify({'error': 'Customer ID is required'}), 400
        if rating is None:
            return jsonify({'error': 'Rating is required'}), 400
        if not isinstance(rating, (int, float)) or rating < 1 or rating > 5:
            return jsonify({'error': 'Rating must be between 1 and 5'}), 400
        
        # Check product exists
        product = Product.query.get(product_id)
        if not product:
            return jsonify({'error': 'Product not found'}), 404
        
        # Check if user already reviewed this product
        existing_review = Review.query.filter_by(
            product_id=product_id,
            customer_id=customer_id
        ).first()
        
        if existing_review:
            # Update existing review
            existing_review.rating = float(rating)
            existing_review.comment = comment
            existing_review.created_at = int(datetime.now().timestamp() * 1000)
            db.session.commit()
            
            # Recalculate product rating
            _update_product_rating(product)
            
            return jsonify({
                'message': 'Review updated successfully',
                'review': existing_review.to_dict(include_customer=True)
            }), 200
        
        # Create new review
        review = Review(
            id=str(uuid.uuid4()),
            product_id=product_id,
            customer_id=customer_id,
            rating=float(rating),
            comment=comment,
            created_at=int(datetime.now().timestamp() * 1000)
        )
        
        db.session.add(review)
        db.session.commit()
        
        # Update product rating
        _update_product_rating(product)
        
        return jsonify({
            'message': 'Review created successfully',
            'review': review.to_dict(include_customer=True)
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


@bp.route('/<product_id>/reviews/<review_id>', methods=['DELETE'])
def delete_review(product_id, review_id):
    """Delete a review"""
    try:
        review = Review.query.get(review_id)
        if not review:
            return jsonify({'error': 'Review not found'}), 404
        
        if review.product_id != product_id:
            return jsonify({'error': 'Review does not belong to this product'}), 400
        
        product = Product.query.get(product_id)
        
        db.session.delete(review)
        db.session.commit()
        
        # Update product rating
        if product:
            _update_product_rating(product)
        
        return jsonify({'message': 'Review deleted successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


def _update_product_rating(product):
    """Helper function to update product rating after review changes"""
    reviews = product.reviews
    if reviews:
        total_rating = sum(r.rating for r in reviews)
        product.rating = total_rating / len(reviews)
        product.review_count = len(reviews)
    else:
        product.rating = 0.0
        product.review_count = 0
    db.session.commit()

