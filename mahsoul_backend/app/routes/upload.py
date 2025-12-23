from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
from werkzeug.exceptions import RequestEntityTooLarge
import os
import uuid
from pathlib import Path
from datetime import datetime

bp = Blueprint('upload', __name__)

# Allowed file extensions
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'webp', 'gif'}
MAX_FILE_SIZE = 5 * 1024 * 1024  # 5MB

# Base directory for uploads
basedir = Path(__file__).parent.parent.parent.resolve()
UPLOAD_FOLDER = basedir / 'uploads'

def allowed_file(filename):
    """Check if file extension is allowed"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def validate_file(file):
    """Validate uploaded file"""
    if not file:
        return None, 'No file provided'
    
    if file.filename == '':
        return None, 'No file selected'
    
    if not allowed_file(file.filename):
        return None, f'Invalid file type. Allowed types: {", ".join(ALLOWED_EXTENSIONS)}'
    
    # Check file size
    file.seek(0, os.SEEK_END)
    file_size = file.tell()
    file.seek(0)  # Reset file pointer
    
    if file_size > MAX_FILE_SIZE:
        return None, f'File too large. Maximum size: {MAX_FILE_SIZE / (1024*1024):.1f}MB'
    
    return True, None

@bp.route('/image', methods=['POST'])
def upload_image():
    """Upload image file"""
    try:
        # Check if file is in request
        if 'file' not in request.files:
            return jsonify({'error': 'No file provided'}), 400
        
        file = request.files['file']
        
        # Validate file
        is_valid, error_msg = validate_file(file)
        if not is_valid:
            return jsonify({'error': error_msg}), 400
        
        # Get upload type (product or profile)
        upload_type = request.form.get('type', 'product')  # Default to 'product'
        
        # Determine upload directory
        if upload_type == 'product':
            upload_dir = UPLOAD_FOLDER / 'products'
        elif upload_type == 'profile':
            upload_dir = UPLOAD_FOLDER / 'profiles'
        else:
            return jsonify({'error': 'Invalid upload type. Use "product" or "profile"'}), 400
        
        # Ensure directory exists
        upload_dir.mkdir(parents=True, exist_ok=True)
        
        # Generate unique filename
        file_ext = file.filename.rsplit('.', 1)[1].lower()
        unique_filename = f"{uuid.uuid4().hex}_{int(datetime.now().timestamp() * 1000)}.{file_ext}"
        
        # Secure filename
        secure_name = secure_filename(unique_filename)
        file_path = upload_dir / secure_name
        
        # Save file
        file.save(str(file_path))
        
        # Return relative path (relative to uploads folder)
        relative_path = f"uploads/{upload_type}s/{secure_name}"
        
        return jsonify({
            'message': 'Image uploaded successfully',
            'image_path': relative_path,
            'filename': secure_name
        }), 200
        
    except RequestEntityTooLarge:
        return jsonify({'error': f'File too large. Maximum size: {MAX_FILE_SIZE / (1024*1024):.1f}MB'}), 413
    except Exception as e:
        return jsonify({'error': f'Upload failed: {str(e)}'}), 500

@bp.route('/image/<path:image_path>', methods=['DELETE'])
def delete_image(image_path):
    """Delete uploaded image"""
    try:
        # Security: Only allow deletion of files in uploads directory
        if not image_path.startswith('uploads/'):
            return jsonify({'error': 'Invalid image path'}), 400
        
        file_path = basedir / image_path
        
        # Check if file exists
        if not file_path.exists():
            return jsonify({'error': 'File not found'}), 404
        
        # Delete file
        file_path.unlink()
        
        return jsonify({'message': 'Image deleted successfully'}), 200
        
    except Exception as e:
        return jsonify({'error': f'Delete failed: {str(e)}'}), 500

