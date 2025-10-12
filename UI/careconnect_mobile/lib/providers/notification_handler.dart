// import 'package:careconnect_mobile/models/responses/notification_message.dart';
// import 'package:careconnect_mobile/providers/rabbitmq_service.dart';
// import 'package:careconnect_mobile/providers/signalr.dart';
// import 'package:flutter/material.dart';

// class NotificationHandler with ChangeNotifier {
//   final SignalRService _signalRService = SignalRService();
//   final String userId;
//   final String baseUrl; // Your API base URL

//   NotificationHandler({required this.userId, required this.baseUrl}) {
//     _initialize();
//   }

//   void _initialize() async {
//     try {
//       // Add notification handler before connecting
//       _signalRService.addNotificationHandler(_handleNotification);

//       await _signalRService.connect(baseUrl, userId);
//     } catch (e) {
//       print('Failed to initialize notification handler: $e');
//       // Implement retry logic here
//     }
//   }

//   void _handleNotification(NotificationMessage notification) {
//     // Show local notification
//     _showLocalNotification(notification);

//     // Update app state if needed
//     _updateAppState(notification);

//     notifyListeners();
//   }

//   void _showLocalNotification(NotificationMessage notification) {
//     // For mobile: use flutter_local_notifications
//     // For desktop: show snackbar or system notification

//     print('Notification: ${notification.title} - ${notification.body}');

//     // Example using scaffold messenger (for in-app notifications)
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //   SnackBar(
//     //     content: Text(notification.title),
//     //     backgroundColor: Colors.blue,
//     //   ),
//     // );
//   }

//   void _updateAppState(NotificationMessage notification) {
//     switch (notification.type) {
//       case 'appointment_status':
//         // Handle appointment status change
//         final appointmentId = notification.data['appointmentId'];
//         final newStatus = notification.data['newStatus'];
//         print('Appointment $appointmentId status changed to $newStatus');
//         break;
//       case 'general':
//         // Handle general notifications
//         break;
//     }
//   }

//   @override
//   void dispose() {
//     _signalRService.removeNotificationHandler(_handleNotification);
//     _signalRService.disconnect();
//     super.dispose();
//   }
// }
