// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAvailability _$EmployeeAvailabilityFromJson(
  Map<String, dynamic> json,
) => EmployeeAvailability(
  employeeAvailabilityId: (json['employeeAvailabilityId'] as num).toInt(),
  dayOfWeek: json['dayOfWeek'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  service: json['service'] == null
      ? null
      : Service.fromJson(json['service'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmployeeAvailabilityToJson(
  EmployeeAvailability instance,
) => <String, dynamic>{
  'employeeAvailabilityId': instance.employeeAvailabilityId,
  'dayOfWeek': instance.dayOfWeek,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'modifiedDate': instance.modifiedDate.toIso8601String(),
  'service': instance.service?.toJson(),
};
