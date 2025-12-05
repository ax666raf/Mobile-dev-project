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
        CartItem, Order, OrderItem, Review, DeliveryAddress
    )
    
    # Register blueprints
    from app.routes import auth, products, cart, orders, profile, delivery_addresses, farmer
    
    app.register_blueprint(auth.bp, url_prefix='/api/auth')
    app.register_blueprint(products.bp, url_prefix='/api/products')
    app.register_blueprint(cart.bp, url_prefix='/api/cart')
    app.register_blueprint(orders.bp, url_prefix='/api/orders')
    app.register_blueprint(profile.bp, url_prefix='/api/profile')
    app.register_blueprint(delivery_addresses.bp, url_prefix='/api/addresses')
    app.register_blueprint(farmer.bp, url_prefix='/api/farmer')
    
    return app

