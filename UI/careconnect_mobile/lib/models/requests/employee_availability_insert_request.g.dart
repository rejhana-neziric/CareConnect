// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_availability_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAvailabilityInsertRequest _$EmployeeAvailabilityInsertRequestFromJson(
  Map<String, dynamic> json,
) => EmployeeAvailabilityInsertRequest(
  employeeId: (json['employeeId'] as num).toInt(),
  serviceId: (json['serviceId'] as num?)?.toInt(),
  dayOfWeek: json['dayOfWeek'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
);

Map<String, dynamic> _$EmployeeAvailabilityInsertRequestToJson(
  EmployeeAvailabilityInsertRequest instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'serviceId': instance.serviceId,
  'dayOfWeek': instance.dayOfWeek,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
};
