// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_reschedule_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentRescheduleRequest _$AppointmentRescheduleRequestFromJson(
  Map<String, dynamic> json,
) => AppointmentRescheduleRequest(
  employeeAvailabilityId: (json['employeeAvailabilityId'] as num?)?.toInt(),
  date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$AppointmentRescheduleRequestToJson(
  AppointmentRescheduleRequest instance,
) => <String, dynamic>{
  'employeeAvailabilityId': instance.employeeAvailabilityId,
  'date': instance.date?.toIso8601String(),
};
