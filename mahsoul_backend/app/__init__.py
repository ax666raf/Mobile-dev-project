from flask import Flask
from flask_cors import CORS
from config import Config
from app.utils.database import db, init_db


def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    # Enable CORS for Flutter app
    CORS(app, origins=app.config['CORS_ORIGINS'])
    
    # Initialize database (this will create all tables)
    init_db(app)
    
    # Import models to ensure they're registered with SQLAlchemy
    from app.models import (
        User, CustomerProfile, FarmerProfile, Product, ProductWeight,
        CartItem, Order, OrderItem, Review, DeliveryAddress, Notification, Favorite
    )
    
    # Register blueprints
    from app.routes import auth, products, cart, orders, profile, delivery_addresses, farmer, upload, notification, favorites
    
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
    
    # Configure static file serving for uploads
    from pathlib import Path
    from flask import send_from_directory
    uploads_dir = Path(__file__).parent.parent / 'uploads'
    uploads_dir.mkdir(exist_ok=True)
    
    @app.route('/uploads/<path:filename>')
    def uploaded_file(filename):
        """Serve uploaded files"""
        # Handle subdirectories (e.g., uploads/products/image.jpg)
        file_path = uploads_dir / filename
        if file_path.exists() and file_path.is_file():
            # Get the directory and filename
            directory = file_path.parent
            file_name = file_path.name
            return send_from_directory(str(directory), file_name)
        return {'error': 'File not found'}, 404
    
    return app

