// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentUpdateRequest _$AppointmentUpdateRequestFromJson(
  Map<String, dynamic> json,
) => AppointmentUpdateRequest(
  employeeAvailabilityId: (json['employeeAvailabilityId'] as num?)?.toInt(),
  appointmentType: json['appointmentType'] as String?,
  attendanceStatusId: (json['attendanceStatusId'] as num?)?.toInt(),
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  description: json['description'] as String?,
  note: json['note'] as String?,
);

Map<String, dynamic> _$AppointmentUpdateRequestToJson(
  AppointmentUpdateRequest instance,
) => <String, dynamic>{
  'employeeAvailabilityId': instance.employeeAvailabilityId,
  'appointmentType': instance.appointmentType,
  'attendanceStatusId': instance.attendanceStatusId,
  'date': instance.date?.toIso8601String(),
  'description': instance.description,
  'note': instance.note,
};
