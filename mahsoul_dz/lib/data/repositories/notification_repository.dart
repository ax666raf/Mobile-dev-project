import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'package:mahsoul_dz/data/models/shared/notification.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository(this._apiClient);

  Future<List<NotificationModel>> getFarmerNotifications(String farmerId, {bool unreadOnly = false}) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.notifications}/farmer/$farmerId',
        queryParameters: {
          'unread_only': unreadOnly.toString(),
          'limit': '50',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final notifications = data['notifications'] as List<dynamic>;
        return notifications.map((n) => NotificationModel.fromJson(n as Map<String, dynamic>)).toList();
      }
      throw ApiException('Failed to fetch notifications');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error fetching notifications: ${e.toString()}');
    }
  }

  Future<int> getUnreadCount(String farmerId) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.notifications}/farmer/$farmerId/unread-count',
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['unread_count'] as int;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiClient.put('${ApiEndpoints.notifications}/$notificationId/read');
    } catch (e) {
      throw ApiException('Failed to mark notification as read');
    }
  }

  Future<void> markAllAsRead(String farmerId) async {
    try {
      await _apiClient.put('${ApiEndpoints.notifications}/farmer/$farmerId/read-all');
    } catch (e) {
      throw ApiException('Failed to mark all notifications as read');
    }
  }
}