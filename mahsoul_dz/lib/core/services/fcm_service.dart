import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mahsoul_dz/core/services/local_notification_service.dart';
import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotifications = LocalNotificationService();
  final ApiClient _apiClient = ApiClient();
  
  String? _fcmToken;
  Function(Map<String, dynamic>)? onNotificationTapped;

  Future<void> initialize() async {
    // Request permissions
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    try {
      _fcmToken = await _messaging.getToken();
      print('FCM Token: $_fcmToken');
    } catch (e) {
      print('⚠️ Failed to get FCM token: $e');
      print('⚠️ This is normal on emulators without Google Play Services');
      print('⚠️ FCM will work on physical devices or emulators with Google Play');
      _fcmToken = null;
    }
    
    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      print('FCM Token refreshed: $newToken');
      // Re-register token if we have a user ID
      // This will be called when user logs in
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages (when app is in background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Handle notification when app is opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleBackgroundMessage(initialMessage);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print('📬 Foreground message received!');
    print('   Title: ${message.notification?.title}');
    print('   Body: ${message.notification?.body}');
    print('   Data: ${message.data}');
    
    // Show local notification
    _localNotifications.showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: message.notification?.title ?? 'New Order',
      body: message.notification?.body ?? 'You have a new order',
      payload: message.data.toString(),
    );
    
    print('✅ Local notification shown');

    // Trigger callback if set
    if (onNotificationTapped != null) {
      onNotificationTapped!(message.data);
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print('Background message: ${message.notification?.title}');
    
    // Navigate to orders page
    if (onNotificationTapped != null) {
      onNotificationTapped!(message.data);
    }
  }

  String? get fcmToken => _fcmToken;

  Future<void> subscribeToFarmerTopic(String farmerId) async {
    await _messaging.subscribeToTopic('farmer_$farmerId');
  }

  Future<void> unsubscribeFromFarmerTopic(String farmerId) async {
    await _messaging.unsubscribeFromTopic('farmer_$farmerId');
  }

  /// Register FCM token with backend for a user
  Future<bool> registerToken(String userId) async {
    if (_fcmToken == null) {
      print('⚠️ No FCM token available to register');
      return false;
    }

    try {
      // Detect device type
      final deviceType = Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'unknown');
      
      final response = await _apiClient.post(
        ApiEndpoints.fcmTokens,
        data: {
          'user_id': userId,
          'token': _fcmToken,
          'device_type': deviceType,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ FCM token registered successfully for user $userId');
        return true;
      } else {
        print('⚠️ Failed to register FCM token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('⚠️ Error registering FCM token: $e');
      return false;
    }
  }

  /// Unregister FCM token (call when user logs out)
  Future<bool> unregisterToken(String userId) async {
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.userFcmTokens(userId),
      );

      if (response.statusCode == 200) {
        print('✅ FCM token unregistered successfully for user $userId');
        return true;
      } else {
        print('⚠️ Failed to unregister FCM token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('⚠️ Error unregistering FCM token: $e');
      return false;
    }
  }
}

// Note: The background message handler is now in main.dart as a top-level function