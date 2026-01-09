from flask import Blueprint, request, jsonify
from app.utils.database import db
from app.models.delivery_address import DeliveryAddress
import uuid
from datetime import datetime

bp = Blueprint('delivery_addresses', __name__)

@bp.route('', methods=['GET'])
def get_addresses():
    """Get user's delivery addresses"""
    try:
        customer_id = request.args.get('customer_id')
        if not customer_id:
            return jsonify({'error': 'customer_id required'}), 400
        
        addresses = DeliveryAddress.query.filter_by(
            customer_id=customer_id
        ).order_by(
            DeliveryAddress.is_default.desc(),
            DeliveryAddress.created_at.desc()
        ).all()
        
        return jsonify({
            'addresses': [a.to_dict() for a in addresses],
            'count': len(addresses)
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@bp.route('', methods=['POST'])
def add_address():
    """Add delivery address"""
    try:
        data = request.get_json()
        print(f"🔵 Backend received address data: {data}")
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        customer_id = data.get('customer_id')
        address = data.get('address')
        city = data.get('city')
        postal_code = data.get('postal_code')
        is_default = data.get('is_default', False)
        
        print(f"🔵 Extracted: customer_id={customer_id}, address={address}, city={city}, postal_code={postal_code}, is_default={is_default}")
        
        if not customer_id or not address or not city:
            return jsonify({'error': 'customer_id, address, and city required'}), 400
    
        try:
            # Check if this is the first address for this customer
            existing_addresses = DeliveryAddress.query.filter_by(customer_id=customer_id).all()
            if len(existing_addresses) == 0:
                # First address - automatically set as default
                is_default = True
                print(f"🔵 First address for customer - automatically setting as default")
            elif is_default:
                # If setting as default, unset all other addresses
                DeliveryAddress.query.filter_by(customer_id=customer_id).update({'is_default': False})
            
            now = int(datetime.now().timestamp() * 1000)
            delivery_address = DeliveryAddress(
                id=str(uuid.uuid4()),
                customer_id=customer_id,
                address=address,
                city=city,
                postal_code=postal_code,
                is_default=is_default,
                created_at=now,
            )
            
            print(f"🔵 Created DeliveryAddress object: {delivery_address.id}")
            db.session.add(delivery_address)
            db.session.commit()
            print(f"✅ Address committed to database")
        except Exception as db_error:
            db.session.rollback()
            print(f"❌ Database error: {str(db_error)}")
            raise
        
        return jsonify({
            'message': 'Address added successfully',
            'address': delivery_address.to_dict()
        }), 201
    except Exception as e:
        db.session.rollback()
        print(f"❌ Backend error adding address: {str(e)}")
        import traceback
        print(f"❌ Traceback: {traceback.format_exc()}")
        return jsonify({'error': str(e)}), 500

@bp.route('/<address_id>', methods=['PUT'])
def update_address(address_id):
    """Update delivery address"""
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        address = DeliveryAddress.query.get(address_id)
        if not address:
            return jsonify({'error': 'Address not found'}), 404
        
        if 'address' in data:
            address.address = data['address']
        if 'city' in data:
            address.city = data['city']
        if 'postal_code' in data:
            address.postal_code = data['postal_code']
        if 'is_default' in data:
            is_default = data['is_default']
            if is_default:
                DeliveryAddress.query.filter_by(
                    customer_id=address.customer_id
                ).filter(
                    DeliveryAddress.id != address_id
                ).update({'is_default': False})
            address.is_default = is_default
        
        db.session.commit()
        
        return jsonify({
            'message': 'Address updated successfully',
            'address': address.to_dict()
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/<address_id>', methods=['DELETE'])
def delete_address(address_id):
    """Delete delivery address"""
    try:
        address = DeliveryAddress.query.get(address_id)
        if not address:
            return jsonify({'error': 'Address not found'}), 404
        
        db.session.delete(address)
        db.session.commit()
        
        return jsonify({'message': 'Address deleted successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@bp.route('/<address_id>/set-default', methods=['POST'])
def set_default_address(address_id):
    """Set address as default"""
    try:
        print(f"🔵 Setting address {address_id} as default")
        address = DeliveryAddress.query.get(address_id)
        if not address:
            return jsonify({'error': 'Address not found'}), 404
        
        try:
            all_addresses = DeliveryAddress.query.filter_by(
                customer_id=address.customer_id
            ).all()
            for addr in all_addresses:
                addr.is_default = False
            
            address.is_default = True
            db.session.commit()
            print(f"✅ Default address updated successfully")
        except Exception as db_error:
            db.session.rollback()
            print(f"❌ Database error: {str(db_error)}")
            raise
        
        return jsonify({
            'message': 'Default address updated',
            'address': address.to_dict()
        }), 200
    except Exception as e:
        db.session.rollback()
        print(f"❌ Error setting default address: {str(e)}")
        return jsonify({'error': str(e)}), 500

