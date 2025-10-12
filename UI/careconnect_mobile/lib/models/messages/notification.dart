import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  String title;
  String body;
  String type;
  Map<String, dynamic> data;

  Notification({
    required this.title,
    required this.body,
    required this.type,
    required this.data,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
