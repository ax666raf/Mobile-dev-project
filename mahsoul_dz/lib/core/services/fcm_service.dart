import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mahsoul_dz/core/services/local_notification_service.dart';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotifications = LocalNotificationService();
  
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
    _fcmToken = await _messaging.getToken();
    print('FCM Token: $_fcmToken');
    // TODO: Send token to backend to associate with farmer

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
    print('Foreground message: ${message.notification?.title}');
    
    // Show local notification
    _localNotifications.showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: message.notification?.title ?? 'New Order',
      body: message.notification?.body ?? 'You have a new order',
      payload: message.data.toString(),
    );

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
}

// Top-level function for background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.messageId}');
  // Handle background notification
}