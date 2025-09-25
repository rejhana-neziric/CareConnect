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
  isBooked: json['isBooked'] as bool,
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  employee: Employee.fromJson(json['employee'] as Map<String, dynamic>),
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
  'isBooked': instance.isBooked,
  'service': instance.service?.toJson(),
  'employee': instance.employee.toJson(),
};
