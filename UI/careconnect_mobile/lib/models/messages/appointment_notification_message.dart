import 'package:careconnect_mobile/models/enums/appointment_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment_notification_message.g.dart';

@JsonSerializable()
class AppointmentNotificationMessage {
  int appointmentId;
  int clientId;
  int employeeId;
  AppointmentStatus status;
  AppointmentStatus previousStatus;
  DateTime appointmentDate;
  String serviceName;
  DateTime changedAt;
  String changedBy;

  AppointmentNotificationMessage({
    required this.appointmentId,
    required this.clientId,
    required this.employeeId,
    required this.status,
    required this.previousStatus,
    required this.appointmentDate,
    required this.serviceName,
    required this.changedAt,
    required this.changedBy,
  });

  factory AppointmentNotificationMessage.fromJson(Map<String, dynamic> json) =>
      _$AppointmentNotificationMessageFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentNotificationMessageToJson(this);
}
