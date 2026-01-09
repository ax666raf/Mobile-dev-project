"""
FCM Service for sending push notifications using Firebase Admin SDK
"""
import os
import json
from pathlib import Path
from typing import List, Dict, Optional
from app.models.fcm_token import FCMToken
from app.utils.database import db

# Try to import firebase_admin, but handle gracefully if not installed
try:
    import firebase_admin
    from firebase_admin import credentials, messaging
    FIREBASE_AVAILABLE = True
except ImportError:
    FIREBASE_AVAILABLE = False
    print("⚠️ firebase-admin not installed. Install with: pip install firebase-admin")
    print("⚠️ Push notifications will not work until firebase-admin is installed and configured.")


class FCMService:
    """Service for sending Firebase Cloud Messaging push notifications"""
    
    _initialized = False
    
    @classmethod
    def initialize(cls):
        """Initialize Firebase Admin SDK"""
        if not FIREBASE_AVAILABLE:
            print("⚠️ Firebase Admin SDK not available")
            return False
        
        if cls._initialized:
            return True
        
        try:
            # Check if Firebase is already initialized
            try:
                firebase_admin.get_app()
                cls._initialized = True
                print("✅ Firebase Admin already initialized")
                return True
            except ValueError:
                # Not initialized yet, proceed with initialization
                pass
            
            # Try to initialize with service account key file
            service_account_path = os.getenv('FIREBASE_SERVICE_ACCOUNT_KEY')
            if service_account_path:
                # Handle relative paths (relative to backend directory)
                if not os.path.isabs(service_account_path):
                    # Get the backend directory (parent of app directory)
                    backend_dir = Path(__file__).parent.parent.parent
                    service_account_path = os.path.join(backend_dir, service_account_path)
                
                if os.path.exists(service_account_path):
                    cred = credentials.Certificate(service_account_path)
                    firebase_admin.initialize_app(cred)
                    cls._initialized = True
                    print(f"✅ Firebase Admin initialized with service account key: {service_account_path}")
                    return True
                else:
                    print(f"⚠️ Service account key file not found: {service_account_path}")
            
            # Try to initialize with environment variable (JSON string)
            service_account_json = os.getenv('FIREBASE_SERVICE_ACCOUNT_JSON')
            if service_account_json:
                cred_info = json.loads(service_account_json)
                cred = credentials.Certificate(cred_info)
                firebase_admin.initialize_app(cred)
                cls._initialized = True
                print("✅ Firebase Admin initialized with JSON environment variable")
                return True
            
            # Try default credentials (for Google Cloud environments)
            try:
                firebase_admin.initialize_app()
                cls._initialized = True
                print("✅ Firebase Admin initialized with default credentials")
                return True
            except Exception as e:
                print(f"⚠️ Could not initialize Firebase Admin: {e}")
                print("⚠️ Set FIREBASE_SERVICE_ACCOUNT_KEY or FIREBASE_SERVICE_ACCOUNT_JSON environment variable")
                return False
                
        except Exception as e:
            print(f"⚠️ Error initializing Firebase Admin: {e}")
            return False
    
    @classmethod
    def send_notification(
        cls,
        user_id: str,
        title: str,
        body: str,
        data: Optional[Dict] = None,
        image_url: Optional[str] = None
    ) -> bool:
        """
        Send push notification to all devices of a user
        
        Args:
            user_id: User ID to send notification to
            title: Notification title
            body: Notification body
            data: Additional data payload (optional)
            image_url: URL of image to show in notification (optional)
            
        Returns:
            bool: True if at least one notification was sent successfully
        """
        if not cls._initialized:
            cls.initialize()
        
        if not FIREBASE_AVAILABLE or not cls._initialized:
            print("⚠️ Cannot send notification: Firebase Admin not initialized")
            return False
        
        # Get all FCM tokens for the user
        tokens = FCMToken.query.filter_by(user_id=user_id).all()
        if not tokens:
            print(f"⚠️ No FCM tokens found for user {user_id}")
            return False
        
        # Prepare notification payload
        notification = messaging.Notification(
            title=title,
            body=body,
            image=image_url
        )
        
        # Prepare data payload
        message_data = data or {}
        message_data['user_id'] = user_id
        
        # Prepare Android-specific config
        android_config = messaging.AndroidConfig(
            priority='high',
            notification=messaging.AndroidNotification(
                channel_id='order_channel',
                sound='default',
                priority='high'
            )
        )
        
        # Prepare iOS-specific config
        apns_config = messaging.APNSConfig(
            payload=messaging.APNSPayload(
                aps=messaging.Aps(
                    alert=messaging.ApsAlert(
                        title=title,
                        body=body
                    ),
                    sound='default',
                    badge=1
                )
            )
        )
        
        success_count = 0
        failed_tokens = []
        
        # Send to each token
        for token_obj in tokens:
            try:
                message = messaging.Message(
                    token=token_obj.token,
                    notification=notification,
                    data={str(k): str(v) for k, v in message_data.items()},  # FCM data must be strings
                    android=android_config,
                    apns=apns_config
                )
                
                response = messaging.send(message)
                print(f"✅ Successfully sent notification to {token_obj.token[:20]}...: {response}")
                success_count += 1
                
            except Exception as e:
                print(f"⚠️ Failed to send notification to token {token_obj.token[:20]}...: {e}")
                failed_tokens.append(token_obj.id)
                # If token is invalid, delete it
                if 'invalid' in str(e).lower() or 'not found' in str(e).lower():
                    try:
                        db.session.delete(token_obj)
                        db.session.commit()
                        print(f"🗑️ Deleted invalid token: {token_obj.id}")
                    except Exception as delete_error:
                        print(f"⚠️ Error deleting invalid token: {delete_error}")
        
        # Clean up failed tokens
        if failed_tokens:
            print(f"⚠️ {len(failed_tokens)} token(s) failed, cleaned up invalid ones")
        
        return success_count > 0
    
    @classmethod
    def send_notification_to_tokens(
        cls,
        tokens: List[str],
        title: str,
        body: str,
        data: Optional[Dict] = None,
        image_url: Optional[str] = None
    ) -> Dict[str, int]:
        """
        Send push notification to specific FCM tokens
        
        Args:
            tokens: List of FCM tokens
            title: Notification title
            body: Notification body
            data: Additional data payload (optional)
            image_url: URL of image to show in notification (optional)
            
        Returns:
            Dict with 'success' and 'failure' counts
        """
        if not cls._initialized:
            cls.initialize()
        
        if not FIREBASE_AVAILABLE or not cls._initialized:
            print("⚠️ Cannot send notification: Firebase Admin not initialized")
            return {'success': 0, 'failure': len(tokens)}
        
        if not tokens:
            return {'success': 0, 'failure': 0}
        
        # Prepare notification payload
        notification = messaging.Notification(
            title=title,
            body=body,
            image=image_url
        )
        
        # Prepare data payload
        message_data = data or {}
        
        # Prepare Android-specific config
        android_config = messaging.AndroidConfig(
            priority='high',
            notification=messaging.AndroidNotification(
                channel_id='order_channel',
                sound='default',
                priority='high'
            )
        )
        
        # Prepare iOS-specific config
        apns_config = messaging.APNSConfig(
            payload=messaging.APNSPayload(
                aps=messaging.Aps(
                    alert=messaging.ApsAlert(
                        title=title,
                        body=body
                    ),
                    sound='default',
                    badge=1
                )
            )
        )
        
        success_count = 0
        failure_count = 0
        
        # Send to each token
        for token in tokens:
            try:
                message = messaging.Message(
                    token=token,
                    notification=notification,
                    data={str(k): str(v) for k, v in message_data.items()},
                    android=android_config,
                    apns=apns_config
                )
                
                response = messaging.send(message)
                print(f"✅ Successfully sent notification: {response}")
                success_count += 1
                
            except Exception as e:
                print(f"⚠️ Failed to send notification: {e}")
                failure_count += 1
        
        return {'success': success_count, 'failure': failure_count}

