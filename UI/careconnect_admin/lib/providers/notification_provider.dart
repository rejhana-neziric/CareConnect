import 'dart:async';

import 'package:careconnect_admin/models/messages/appointment_notification.dart';
import 'package:careconnect_admin/services/singalr_service.dart';
import 'package:flutter/foundation.dart';

class NotificationProvider extends ChangeNotifier {
  final SignalRService _signalRService = SignalRService();
  final List<AppointmentNotification> _notifications = [];
  bool _isConnected = false;
  int? _userId;
  String? _hubUrl;
  StreamSubscription<Map<String, dynamic>>? _streamSubscription;

  final Set<String> _processedNotificationIds = {};

  List<AppointmentNotification> get notifications => _notifications;
  bool get isConnected => _isConnected;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification(AppointmentNotification notification) {
    final notificationKey =
        '${notification.id}_${notification.title}_${notification.appointmentId}';

    if (_processedNotificationIds.contains(notificationKey)) {
      debugPrint(
        '⚠️ Duplicate notification detected, skipping: $notificationKey',
      );
      return;
    }

    _processedNotificationIds.add(notificationKey);
    _notifications.insert(0, notification);
    notifyListeners();

    if (_processedNotificationIds.length > 100) {
      final excess = _processedNotificationIds.length - 100;
      _processedNotificationIds.removeAll(
        _processedNotificationIds.take(excess),
      );
    }
  }

  Future<void> initialize(String hubUrl, int userId) async {
    _hubUrl = hubUrl;
    _userId = userId;

    // Canceling existing subscription before creating new one
    await _streamSubscription?.cancel();

    try {
      await _signalRService.initialize(hubUrl, userId);
      _isConnected = true;
      notifyListeners();

      _streamSubscription = _signalRService.notificationStream.listen(
        _handleNotification,
        onError: (error) {
          debugPrint('Error in notification stream: $error');
        },
      );
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
      _isConnected = false;
      notifyListeners();

      Future.delayed(const Duration(seconds: 5), () {
        if (!_isConnected && _hubUrl != null && _userId != null) {
          initialize(_hubUrl!, _userId!);
        }
      });
    }
  }

  void _handleNotification(Map<String, dynamic> notificationData) {
    debugPrint('Provider received notification: ${notificationData['title']}');
    final notification = AppointmentNotification.fromMap(notificationData);
    addNotification(notification);
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _processedNotificationIds.clear();
    notifyListeners();
  }

  Future<void> reconnect() async {
    if (_hubUrl != null && _userId != null) {
      await initialize(_hubUrl!, _userId!);
    }
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _signalRService.disconnect();
    super.dispose();
  }
}
