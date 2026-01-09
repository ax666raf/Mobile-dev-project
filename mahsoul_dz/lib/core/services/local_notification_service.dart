import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel (required for Android 8.0+)
    try {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidImplementation != null) {
        const androidChannel = AndroidNotificationChannel(
          'order_channel',
          'Order Notifications',
          description: 'Notifications for new orders',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        );
        
        await androidImplementation.createNotificationChannel(androidChannel);
        print('✅ Android notification channel created: order_channel');
        
        // Request notification permissions for Android 13+
        final granted = await androidImplementation.requestNotificationsPermission();
        print('📱 Notification permission granted: $granted');
      }
    } catch (e) {
      print('⚠️ Error creating notification channel: $e');
    }

    _initialized = true;
    print('✅ Local notifications initialized');
  }

  Function(Map<String, dynamic>)? onNotificationTapped;

  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notification tapped! Payload: ${response.payload}');
    // Parse payload and trigger callback
    if (onNotificationTapped != null && response.payload != null) {
      try {
        // Payload is stored as string representation of map
        // For now, pass empty map - the navigation will use current user type
        onNotificationTapped!({});
      } catch (e) {
        print('⚠️ Error handling notification tap: $e');
      }
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await initialize();

    print('🔔 Attempting to show notification:');
    print('   ID: $id');
    print('   Title: $title');
    print('   Body: $body');
    print('   Channel: order_channel');

    final androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'Notifications for new orders',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      styleInformation: BigTextStyleInformation(body),
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(id, title, body, details, payload: payload);
      print('✅ Notification show() called successfully with ID: $id');
      print('   Check notification tray (swipe down from top)');
    } catch (e) {
      print('❌ Error showing notification: $e');
      print('   Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}