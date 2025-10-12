class AppointmentNotification {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> data;
  final DateTime receivedAt;
  bool isRead;

  AppointmentNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.receivedAt,
    this.isRead = false,
  });

  factory AppointmentNotification.fromMap(Map<String, dynamic> map) {
    return AppointmentNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] as String? ?? '',
      body: map['body'] as String? ?? '',
      type: map['type'] as String? ?? '',
      data: map['data'] as Map<String, dynamic>? ?? {},
      receivedAt: DateTime.now(),
    );
  }

  int? get appointmentId {
    final id = data['appointmentId'];
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    return null;
  }

  String? get status => data['status'] as String?;
}
