// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_notification_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentNotificationMessage _$AppointmentNotificationMessageFromJson(
  Map<String, dynamic> json,
) => AppointmentNotificationMessage(
  appointmentId: (json['appointmentId'] as num).toInt(),
  clientId: (json['clientId'] as num).toInt(),
  employeeId: (json['employeeId'] as num).toInt(),
  status: $enumDecode(_$AppointmentStatusEnumMap, json['status']),
  previousStatus: $enumDecode(
    _$AppointmentStatusEnumMap,
    json['previousStatus'],
  ),
  appointmentDate: DateTime.parse(json['appointmentDate'] as String),
  serviceName: json['serviceName'] as String,
  changedAt: DateTime.parse(json['changedAt'] as String),
  changedBy: json['changedBy'] as String,
);

Map<String, dynamic> _$AppointmentNotificationMessageToJson(
  AppointmentNotificationMessage instance,
) => <String, dynamic>{
  'appointmentId': instance.appointmentId,
  'clientId': instance.clientId,
  'employeeId': instance.employeeId,
  'status': _$AppointmentStatusEnumMap[instance.status]!,
  'previousStatus': _$AppointmentStatusEnumMap[instance.previousStatus]!,
  'appointmentDate': instance.appointmentDate.toIso8601String(),
  'serviceName': instance.serviceName,
  'changedAt': instance.changedAt.toIso8601String(),
  'changedBy': instance.changedBy,
};

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.scheduled: 'scheduled',
  AppointmentStatus.confirmed: 'confirmed',
  AppointmentStatus.rescheduled: 'rescheduled',
  AppointmentStatus.reschedulerequested: 'reschedulerequested',
  AppointmentStatus.reschedulependingapproval: 'reschedulependingapproval',
  AppointmentStatus.canceled: 'canceled',
  AppointmentStatus.started: 'started',
  AppointmentStatus.completed: 'completed',
};
