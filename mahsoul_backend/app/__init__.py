from flask import Flask
from flask_cors import CORS
from config import Config
from app.utils.database import db, init_db


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    # Enable CORS for Flutter app
    CORS(app, origins=app.config['CORS_ORIGINS'])
    
    # Import models BEFORE initializing database (so SQLAlchemy knows about them)
    from app.models import (
        User, CustomerProfile, FarmerProfile, Product, ProductWeight, ProductImage,
        CartItem, Order, OrderItem, Review, DeliveryAddress, Notification, Favorite, FCMToken
    )
    
    # Initialize database (this will create all tables)
    init_db(app)
    
    # Register blueprints
    from app.routes import auth, products, cart, orders, profile, delivery_addresses, farmer, upload, notification, favorites, fcm_token
    
    app.register_blueprint(auth.bp, url_prefix='/api/auth')
    app.register_blueprint(products.bp, url_prefix='/api/products')
    app.register_blueprint(cart.bp, url_prefix='/api/cart')
    app.register_blueprint(orders.bp, url_prefix='/api/orders')
    app.register_blueprint(profile.bp, url_prefix='/api/profile')
    app.register_blueprint(delivery_addresses.bp, url_prefix='/api/addresses')
    app.register_blueprint(farmer.bp, url_prefix='/api/farmer')
    app.register_blueprint(upload.bp, url_prefix='/api/upload')
    app.register_blueprint(notification.bp, url_prefix='/api/notifications')
    app.register_blueprint(favorites.bp, url_prefix='/api/favorites')
    app.register_blueprint(fcm_token.bp, url_prefix='/api/fcm-tokens')
    
    # Configure static file serving for uploads
    from pathlib import Path
    from flask import send_from_directory, jsonify
    uploads_dir = Path(__file__).parent.parent / 'uploads'
    uploads_dir.mkdir(exist_ok=True)
    
    @app.route('/uploads/<path:filename>')
    def uploaded_file(filename):
        """Serve uploaded files"""
        try:
            # Handle subdirectories (e.g., profiles/image.jpg or products/image.jpg)
            file_path = uploads_dir / filename
            if file_path.exists() and file_path.is_file():
                # Get the directory and filename
                directory = file_path.parent
                file_name = file_path.name
                # Add proper headers for image serving
                response = send_from_directory(
                    str(directory), 
                    file_name,
                    mimetype=None,  # Let Flask auto-detect MIME type
                )
                # Add CORS headers
                response.headers.add('Access-Control-Allow-Origin', '*')
                response.headers.add('Access-Control-Allow-Methods', 'GET')
                return response
            return jsonify({'error': 'File not found'}), 404
        except Exception as e:
            print(f"Error serving file {filename}: {e}")
            return jsonify({'error': f'Error serving file: {str(e)}'}), 500
    
    return app

