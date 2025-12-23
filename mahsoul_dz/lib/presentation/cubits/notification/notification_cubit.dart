import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/models/shared/notification.dart';
import 'package:mahsoul_dz/data/repositories/notification_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'package:mahsoul_dz/presentation/cubits/notification/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;

  NotificationCubit(this._repository) : super(NotificationInitial());

  Future<void> loadNotifications(String farmerId, {bool unreadOnly = false}) async {
    emit(NotificationLoading());
    
    try {
      final notifications = await _repository.getFarmerNotifications(farmerId, unreadOnly: unreadOnly);
      final unreadCount = await _repository.getUnreadCount(farmerId);
      
      emit(NotificationLoaded(notifications, unreadCount));
    } on ApiException catch (e) {
      emit(NotificationError(e.message));
    } catch (e) {
      emit(NotificationError('Failed to load notifications: ${e.toString()}'));
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
      
      // Reload notifications
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        final updatedNotifications = currentState.notifications.map((n) {
          if (n.id == notificationId) {
            return NotificationModel(
              id: n.id,
              farmerId: n.farmerId,
              orderId: n.orderId,
              title: n.title,
              message: n.message,
              type: n.type,
              isRead: true, // Mark as read
              createdAt: n.createdAt,
              order: n.order,
            );
          }
          return n;
        }).toList();
        
        emit(NotificationLoaded(updatedNotifications, currentState.unreadCount - 1));
      }
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }

  Future<void> markAllAsRead(String farmerId) async {
    try {
      await _repository.markAllAsRead(farmerId);
      await loadNotifications(farmerId);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> refreshNotifications(String farmerId) async {
    await loadNotifications(farmerId);
  }
}