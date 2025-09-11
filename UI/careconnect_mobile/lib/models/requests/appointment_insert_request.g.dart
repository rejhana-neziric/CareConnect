// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentInsertRequest _$AppointmentInsertRequestFromJson(
  Map<String, dynamic> json,
) => AppointmentInsertRequest(
  userId: (json['userId'] as num).toInt(),
  employeeAvailabilityId: (json['employeeAvailabilityId'] as num).toInt(),
  appointmentType: json['appointmentType'] as String,
  attendanceStatusId: (json['attendanceStatusId'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  description: json['description'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$AppointmentInsertRequestToJson(
  AppointmentInsertRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'employeeAvailabilityId': instance.employeeAvailabilityId,
  'appointmentType': instance.appointmentType,
  'attendanceStatusId': instance.attendanceStatusId,
  'date': instance.date.toIso8601String(),
  'description': instance.description,
  'note': instance.note,
};
