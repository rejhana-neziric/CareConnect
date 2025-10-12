import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _hubConnection;

  final _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;

  Future<void> initialize(String hubUrl, int userId) async {
    // Preventing re-initialization if already connected
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      debugPrint('⚠️ SignalR already connected, skipping re-init.');
      return;
    }

    try {
      debugPrint('🔄 Initializing SignalR connection...');
      debugPrint('Hub URL: $hubUrl');
      debugPrint('User ID: $userId');

      final fullUrl = '$hubUrl?userId=$userId';
      debugPrint('Full URL: $fullUrl');

      _hubConnection = HubConnectionBuilder()
          .withUrl(fullUrl, options: HttpConnectionOptions())
          .withAutomaticReconnect(retryDelays: [0, 2000, 10000, 30000])
          .build();

      _hubConnection!.onreconnecting(({error}) {
        debugPrint('⚠️ SignalR reconnecting... Error: $error');
      });

      _hubConnection!.onreconnected(({connectionId}) {
        debugPrint('✅ SignalR reconnected: $connectionId');
      });

      _hubConnection!.onclose(({error}) {
        debugPrint('❌ SignalR connection closed: $error');
      });

      // Removing old handler before adding new one
      _hubConnection!.off('ReceiveNotification');
      _hubConnection!.on('ReceiveNotification', _handleNotification);
      debugPrint('✓ Registered ReceiveNotification handler');

      _hubConnection!.on('Connected', (arguments) {
        debugPrint('✅ Connection confirmed by server: $arguments');
      });

      debugPrint('🔄 Starting SignalR connection...');
      await _hubConnection!.start();

      debugPrint('✅ SignalR connection started successfully');
      debugPrint('Connection ID: ${_hubConnection!.connectionId}');
      debugPrint('Connection State: ${_hubConnection!.state}');

      try {
        await _hubConnection!.invoke('RegisterUser', args: [userId]);
        debugPrint('✓ User registered on hub');
      } catch (e) {
        debugPrint('⚠️ RegisterUser failed (might not be needed): $e');
      }

      debugPrint('✅ SignalR initialization complete');
    } catch (e, stackTrace) {
      debugPrint('❌ Error initializing SignalR: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  void _handleNotification(List<Object?>? arguments) {
    debugPrint('_handleNotification called');
    debugPrint('Arguments: $arguments');

    if (arguments == null || arguments.isEmpty) {
      debugPrint('❌ No arguments received');
      return;
    }

    try {
      final notification = arguments[0] as Map<String, dynamic>;
      debugPrint('✅ Notification parsed: $notification');

      final title = notification['title'] as String? ?? 'Notification';
      final body = notification['body'] as String? ?? '';
      final type = notification['type'] as String? ?? '';
      final data = notification['data'] as Map<String, dynamic>? ?? {};

      debugPrint('  Notification Details:');
      debugPrint('  Title: $title');
      debugPrint('  Body: $body');
      debugPrint('  Type: $type');
      debugPrint('  Data: $data');

      _notificationController.add({
        'title': title,
        'body': body,
        'type': type,
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });

      debugPrint('✅ Notification emitted to stream');
    } catch (e, stackTrace) {
      debugPrint('❌ Error handling notification: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> disconnect() async {
    try {
      debugPrint('🔄 Disconnecting from SignalR...');
      if (_hubConnection != null) {
        // Removing handlers before stopping
        _hubConnection!.off('ReceiveNotification');
        _hubConnection!.off('Connected');
        await _hubConnection!.stop();
        _hubConnection = null;
        debugPrint('✅ Disconnected from SignalR Hub');
      }
    } catch (e) {
      debugPrint('❌ Error disconnecting: $e');
    }
  }

  void dispose() async {
    debugPrint('🗑️ Disposing SignalR service');
    await disconnect();
    await _notificationController.close();
  }
}
