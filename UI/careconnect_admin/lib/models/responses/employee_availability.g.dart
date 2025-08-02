// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_availability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAvailability _$EmployeeAvailabilityFromJson(
  Map<String, dynamic> json,
) => EmployeeAvailability(
  dayOfWeek: json['dayOfWeek'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  isAvailable: json['isAvailable'] as bool,
  reasonOfUnavailability: json['reasonOfUnavailability'] as String?,
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  employee: Employee.fromJson(json['employee'] as Map<String, dynamic>),
  service: json['service'] == null
      ? null
      : Service.fromJson(json['service'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmployeeAvailabilityToJson(
  EmployeeAvailability instance,
) => <String, dynamic>{
  'dayOfWeek': instance.dayOfWeek,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime.toIso8601String(),
  'isAvailable': instance.isAvailable,
  'reasonOfUnavailability': instance.reasonOfUnavailability,
  'modifiedDate': instance.modifiedDate.toIso8601String(),
  'employee': instance.employee.toJson(),
  'service': instance.service?.toJson(),
};
