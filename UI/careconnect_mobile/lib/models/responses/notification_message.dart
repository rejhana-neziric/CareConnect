// class NotificationMessage {
//   final int id;
//   final String userId;
//   final String title;
//   final String body;
//   final Map<String, String> data;
//   final NotificationType type;
//   final DateTime timestamp;
//   final bool isRead;

//   NotificationMessage({
//     required this.id,
//     required this.userId,
//     required this.title,
//     required this.body,
//     required this.data,
//     required this.type,
//     required this.timestamp,
//     this.isRead = false,
//   });

//   factory NotificationMessage.fromJson(Map<String, dynamic> json) {
//     return NotificationMessage(
//       id: json['id'] as int,
//       userId: json['userId'] as String,
//       title: json['title'] as String,
//       body: json['body'] as String,
//       data: Map<String, String>.from(json['data'] as Map),
//       type: NotificationType.values.firstWhere(
//         (e) =>
//             e.toString() ==
//             'NotificationType.${_camelCase(json['type'] as String)}',
//         orElse: () => NotificationType.general,
//       ),
//       timestamp: DateTime.parse(json['timestamp'] as String),
//       isRead: json['isRead'] as bool? ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'userId': userId,
//       'title': title,
//       'body': body,
//       'data': data,
//       'type': type.toString().split('.').last,
//       'timestamp': timestamp.toIso8601String(),
//       'isRead': isRead,
//     };
//   }

//   NotificationMessage copyWith({
//     int? id,
//     String? userId,
//     String? title,
//     String? body,
//     Map<String, String>? data,
//     NotificationType? type,
//     DateTime? timestamp,
//     bool? isRead,
//   }) {
//     return NotificationMessage(
//       id: id ?? this.id,
//       userId: userId ?? this.userId,
//       title: title ?? this.title,
//       body: body ?? this.body,
//       data: data ?? this.data,
//       type: type ?? this.type,
//       timestamp: timestamp ?? this.timestamp,
//       isRead: isRead ?? this.isRead,
//     );
//   }

//   static String _camelCase(String str) {
//     if (str.isEmpty) return str;
//     return str[0].toLowerCase() + str.substring(1);
//   }
// }

// enum NotificationType {
//   appointmentConfirmed,
//   appointmentCancelled,
//   appointmentRejected,
//   appointmentReminder,
//   general,
// }

class NotificationMessage {
  final String userId;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final Map<String, dynamic> data;

  NotificationMessage({
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.data,
  });

  factory NotificationMessage.fromJson(Map<String, dynamic> json) {
    return NotificationMessage(
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      data: Map<String, dynamic>.from(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'data': data,
    };
  }
}
