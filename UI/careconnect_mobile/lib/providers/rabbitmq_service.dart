// import 'dart:async';
// import 'dart:convert';

// import 'package:dart_amqp/dart_amqp.dart';
// import 'package:amqp_client/amqp_client.dart';
// import 'package:careconnect_mobile/models/responses/notification_message.dart';
// import 'package:flutter/foundation.dart';

// class RabbitMQService {
//   static final RabbitMQService _instance = RabbitMQService._internal();
//   factory RabbitMQService() => _instance;
//   RabbitMQService._internal();

//   late AmqpClient _client;
//   StreamController<NotificationMessage> _notificationController =
//       StreamController<NotificationMessage>.broadcast();

//   bool _isConnected = false;
//   String _currentUserId = '';

//   Stream<NotificationMessage> get notificationStream =>
//       _notificationController.stream;

//   Future<void> connect(String userId) async {
//     if (_isConnected && _currentUserId == userId) return;

//     _currentUserId = userId;

//     try {
//       // Close existing connection if any
//       if (_isConnected) {
//         await disconnect();
//       }

//       _client = AmqpClient(
//         host: 'localhost', // Replace with your RabbitMQ server
//         port: 5672,
//         username: 'guest',
//         password: 'guest',
//         vhost: '/',
//       );

//       await _client.connect();
//       _isConnected = true;

//       // Setup consumer for user-specific notifications
//       await _setupConsumer(userId);

//       if (kDebugMode) {
//         print('RabbitMQ connected for user: $userId');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('RabbitMQ connection failed: $e');
//       }
//       rethrow;
//     }
//   }

//   Future<void> _setupConsumer(String userId) async {
//     try {
//       final channel = await _client.channel();

//       // Create exchange if it doesn't exist
//       await channel.exchangeDeclare('easynetq.topic', 'topic', durable: true);

//       // Create queue for this user
//       final queueName = 'user_$userId';
//       await channel.queueDeclare(queueName, durable: false);

//       // Bind queue to exchange with user-specific routing key
//       await channel.queueBind(queueName, 'easynetq.topic', '#');

//       // Alternative: Bind to specific patterns
//       await channel.queueBind(queueName, 'easynetq.topic', 'user.$userId');
//       await channel.queueBind(queueName, 'easynetq.topic', 'appointment.*');

//       // Start consuming messages
//       final consumer = await channel.basicConsume(queueName);

//       consumer.listen((message) {
//         try {
//           final jsonString = utf8.decode(message.payload);
//           final jsonData = json.decode(jsonString);
//           final notification = NotificationMessage.fromJson(jsonData);

//           _notificationController.add(notification);

//           // Acknowledge message
//           channel.basicAck(message);

//           if (kDebugMode) {
//             print('Received notification: ${notification.title}');
//           }
//         } catch (e) {
//           if (kDebugMode) {
//             print('Error processing message: $e');
//           }
//         }
//       });
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error setting up consumer: $e');
//       }
//     }
//   }

//   Future<void> disconnect() async {
//     try {
//       await _client.close();
//       _isConnected = false;
//       _currentUserId = '';
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error disconnecting from RabbitMQ: $e');
//       }
//     }
//   }

//   Future<void> sendNotification(NotificationMessage notification) async {
//     if (!_isConnected) return;

//     try {
//       final channel = await _client.channel();

//       final message = AmqpMessage(
//         utf8.encode(json.encode(notification.toJson())),
//         properties: MessageProperties(
//           contentType: 'application/json',
//           deliveryMode: DeliveryMode.persistent,
//         ),
//       );

//       await channel.basicPublish(
//         message,
//         exchange: 'easynetq.topic',
//         routingKey: 'user.${notification.userId}',
//       );

//       if (kDebugMode) {
//         print('Notification sent to user ${notification.userId}');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error sending notification: $e');
//       }
//     }
//   }

//   bool get isConnected => _isConnected;
//   String get currentUserId => _currentUserId;
// }
